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
  dynamic targetTTSResponseForMale;
  dynamic targetTTSResponseForFemale;
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
    var ttsPayloadForMale = {};

    ttsPayloadForMale['input'] = [
      {'source': targetLangTextController.text}
    ];

    ttsPayloadForMale['modelId'] = _languageModelController
        .getAvailableTTSModel(getSelectedTargetLangCode());
    ttsPayloadForMale['task'] = APIConstants.TYPES_OF_MODELS_LIST[2];
    ttsPayloadForMale['gender'] = 'male';

    var ttsPayloadForFemale = {};
    ttsPayloadForFemale.addAll(ttsPayloadForMale);
    ttsPayloadForFemale['gender'] = 'female';

    var responseList = await _translationAppAPIClient.sendTTSReqTranslation(
        ttsPayloadList: [ttsPayloadForMale, ttsPayloadForFemale]);

    responseList.when(
      success: (data) {
        if (data != null && data.isNotEmpty) {
          for (var genderResponse in data) {
            if (genderResponse['gender'] == 'male') {
              targetTTSResponseForMale =
                  data[0]['output']['audio'][0]['audioContent'] ?? '';
            } else {
              targetTTSResponseForFemale =
                  data[0]['output']['audio'][0]['audioContent'] ?? '';
            }
          }
        }

        isTranslateCompleted.value = true;
        isLsLoading.value = false;
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
        GenderEnum? preferredGender = GenderEnum.values
            .byName(_hiveDBInstance.get(preferredVoiceAssistantGender));

        bool isMaleTTSAvailable = targetTTSResponseForMale != null &&
            targetTTSResponseForMale.isNotEmpty;

        bool isFemaleTTSAvailable = targetTTSResponseForFemale != null &&
            targetTTSResponseForFemale.isNotEmpty;

        _audioPlayer.deleteTTSFile();

        if ((preferredGender == GenderEnum.male && isMaleTTSAvailable) ||
            (!isFemaleTTSAvailable && isMaleTTSAvailable)) {
          if (preferredGender == GenderEnum.female) {
            showDefaultSnackbar(message: femaleVoiceAssistantNotAvailable.tr);
          }
          _audioPlayer.playAudioFromBase64(targetTTSResponseForMale);
        } else if ((preferredGender == GenderEnum.female &&
                isFemaleTTSAvailable) ||
            (!isMaleTTSAvailable && isFemaleTTSAvailable)) {
          if (preferredGender == GenderEnum.male) {
            showDefaultSnackbar(message: maleVoiceAssistantNotAvailable.tr);
          }
          _audioPlayer.playAudioFromBase64(targetTTSResponseForFemale);
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
    isRecordedViaMic.value = false;
    _voiceRecorder.deleteRecordedFile();
    _audioPlayer.deleteTTSFile();
    targetTTSResponseForMale = null;
    targetTTSResponseForFemale = null;
  }
}
