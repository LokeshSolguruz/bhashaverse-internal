import 'package:bhashaverse/common/controller/language_model_controller.dart';
import 'package:bhashaverse/enums/gender_enum.dart';
import 'package:bhashaverse/enums/language_enum.dart';
import 'package:bhashaverse/utils/audio_player.dart';
import 'package:bhashaverse/utils/voice_recorder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../../../localization/localization_keys.dart';
import '../../../../../services/translation_app_api_client.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/permission_handler.dart';
import '../../../../../utils/snackbar_utils.dart';

class BottomNavTranslationController extends GetxController {
  late TranslationAppAPIClient _translationAppAPIClient;
  late LanguageModelController _languageModelController;

  TextEditingController sourceLanTextController = TextEditingController();
  TextEditingController targetLangTextController = TextEditingController();

  RxBool isTranslateCompleted = false.obs;
  RxBool isMicButtonTapped = false.obs;
  bool isMicPermissionGranted = false;
  RxBool isLsLoading = false.obs;
  RxString selectedSourceLanguage = ''.obs;
  RxString selectedTargetLanguage = ''.obs;
  dynamic targetTTSResponse;
  bool isLanguageSwapped = false;
  RxBool isRecordedViaMic = false.obs;

  final VoiceRecorder _voiceRecorder = VoiceRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final Box _hiveDBInstance;

  @override
  void onInit() {
    _translationAppAPIClient = Get.find();
    _languageModelController = Get.find();
    _hiveDBInstance = Hive.box(hiveDBName);
    super.onInit();
  }

  @override
  void onClose() {
    sourceLanTextController.dispose();
    targetLangTextController.dispose();
    super.onClose();
  }

  void swapSourceAndTargetLanguage() {
    if (isSourceAndTargetLangSelected()) {
      String tempSourceLanguage = selectedSourceLanguage.value;
      selectedSourceLanguage.value = selectedTargetLanguage.value;
      selectedTargetLanguage.value = tempSourceLanguage;
      if (isTranslateCompleted.value) {
        String tempSourceLangText = sourceLanTextController.value.text;
        sourceLanTextController.text = targetLangTextController.value.text;
        targetLangTextController.text = tempSourceLangText;
      }
      isLanguageSwapped = !isLanguageSwapped;
    } else {
      showDefaultSnackbar(message: kErrorSelectSourceAndTargetScreen.tr);
    }
  }

  bool isSourceAndTargetLangSelected() =>
      selectedSourceLanguage.value.isNotEmpty &&
      selectedTargetLanguage.value.isNotEmpty;

  String getSelectedSourceLanguageName() {
    if (selectedSourceLanguage.value.isEmpty) {
      return kTranslateSourceTitle.tr;
    } else {
      return selectedSourceLanguage.value;
    }
  }

  String getSelectedTargetLanguageName() {
    if (selectedTargetLanguage.value.isEmpty) {
      return kTranslateTargetTitle.tr;
    } else {
      return selectedTargetLanguage.value;
    }
  }

  String getSelectedSourceLangCode() => APIConstants.getLanguageCodeOrName(
        value: selectedSourceLanguage.value,
        returnWhat: LanguageMap.languageCode,
        lang_code_map: APIConstants.LANGUAGE_CODE_MAP,
      );

  String getSelectedTargetLangCode() => APIConstants.getLanguageCodeOrName(
      value: selectedTargetLanguage.value,
      returnWhat: LanguageMap.languageCode,
      lang_code_map: APIConstants.LANGUAGE_CODE_MAP);

  void startVoiceRecording() async {
    await PermissionHandler.requestPermissions().then((isPermissionGranted) {
      isMicPermissionGranted = isPermissionGranted;
    });
    if (isMicPermissionGranted) {
      // clear previous recording files and
      // update state
      resetAllValues();
      isMicButtonTapped.value = true;
      await _voiceRecorder.startRecordingVoice();
    } else {
      showDefaultSnackbar(message: errorMicPermission.tr);
    }
  }

  void stopVoiceRecordingAndGetResult() async {
    isMicButtonTapped.value = false;
    String? base64EncodedAudioContent =
        await _voiceRecorder.stopRecordingVoiceAndGetOutput();
    if (base64EncodedAudioContent == null ||
        base64EncodedAudioContent.isEmpty) {
      showDefaultSnackbar(message: errorInRecording.tr);
      return;
    } else {
      await getASROutput(base64EncodedAudioContent);
    }
  }

  Future<void> getASROutput(String base64EncodedAudioContent) async {
    isLsLoading.value = true;
    var asrPayloadToSend = {};
    asrPayloadToSend['modelId'] = _languageModelController
        .getAvailableASRModelsForLanguage(getSelectedSourceLangCode());
    asrPayloadToSend['task'] = 'asr';
    asrPayloadToSend['audioContent'] = base64EncodedAudioContent;
    asrPayloadToSend['source'] = getSelectedSourceLangCode();
    asrPayloadToSend['userId'] = null;

    var response = await _translationAppAPIClient.sendASRRequest(
        asrPayload: asrPayloadToSend);

    response.when(
      success: (data) async {
        sourceLanTextController.text = data['source'];
        isRecordedViaMic.value = true;
        await translateSourceLanguage();
      },
      failure: (error) {
        showDefaultSnackbar(
            message: error.message ?? APIConstants.kErrorMessageGenericError);
        isTranslateCompleted.value = true;
        isLsLoading.value = false;
      },
    );
  }

  Future<void> translateSourceLanguage() async {
    isLsLoading.value = true;
    var transPayload = {};
    transPayload['modelId'] =
        _languageModelController.getAvailableTranslationModel(
            getSelectedSourceLangCode(), getSelectedTargetLangCode());
    transPayload['task'] = 'translation';
    List<Map<String, dynamic>> source = [
      {'source': sourceLanTextController.text}
    ];
    transPayload['input'] = source;

    transPayload['userId'] = null;

    var transResponse = await _translationAppAPIClient.sendTranslationRequest(
        transPayload: transPayload);

    transResponse.when(
      success: (data) async {
        targetLangTextController.text = data['target'];
        await getTTSOutput();
      },
      failure: (error) {
        showDefaultSnackbar(
            message: error.message ?? APIConstants.kErrorMessageGenericError);
        isTranslateCompleted.value = true;
        isLsLoading.value = false;
      },
    );
  }

  Future<void> getTTSOutput() async {
    GenderEnum? preferredGender = GenderEnum.values
        .byName(_hiveDBInstance.get(preferredVoiceAssistantGender));
    var ttsPayload = {};

    ttsPayload['input'] = [
      {'source': sourceLanTextController.text}
    ];

    ttsPayload['modelId'] = _languageModelController
        .getAvailableTTSModel(getSelectedTargetLangCode());
    ttsPayload['task'] = APIConstants.TYPES_OF_MODELS_LIST[2];
    ttsPayload['input'][0]['source'] = targetLangTextController.text;
    ttsPayload['gender'] =
        preferredGender == GenderEnum.male ? 'male' : 'female';

    var responseList = await _translationAppAPIClient
        .sendTTSReqTranslation(ttsPayloadList: [ttsPayload]);

    responseList.when(
      success: (data) {
        List<String> ttsResponse = [
          data[0]['output']['audio'][0]['audioContent'] ?? '',
        ];
        targetTTSResponse = ttsResponse[0];
        isTranslateCompleted.value = true;
        isLsLoading.value = false;
        return ttsResponse;
      },
      failure: (error) {
        showDefaultSnackbar(
            message: error.message ?? APIConstants.kErrorMessageGenericError);
        isTranslateCompleted.value = true;
        isLsLoading.value = false;
      },
    );
  }

  void playTTSOutput(bool isPlayingForTarget) async {
    await PermissionHandler.requestPermissions().then((isPermissionGranted) {
      isMicPermissionGranted = isPermissionGranted;
    });
    if (isMicPermissionGranted) {
      if ((isPlayingForTarget && !isLanguageSwapped) ||
          (isLanguageSwapped && !isPlayingForTarget)) {
        if (targetTTSResponse != null && targetTTSResponse.isNotEmpty) {
          _audioPlayer.playAudioFromBase64(targetTTSResponse);
        } else {
          showDefaultSnackbar(message: noVoiceAssistantAvailable.tr);
        }
      } else {
        String? recordedAudioFilePath = _voiceRecorder.getAudioFilePath();
        if (recordedAudioFilePath != null && recordedAudioFilePath.isNotEmpty) {
          _audioPlayer.playAudioFromFile(_voiceRecorder.getAudioFilePath()!);
        }
      }
    }
  }

  void resetAllValues() {
    sourceLanTextController.clear();
    targetLangTextController.clear();
    isMicButtonTapped.value = false;
    isTranslateCompleted.value = false;
    isLanguageSwapped = false;
    isRecordedViaMic.value = false;
    _voiceRecorder.deleteRecordedFile();
    _audioPlayer.deleteTTSFile();
  }
}
