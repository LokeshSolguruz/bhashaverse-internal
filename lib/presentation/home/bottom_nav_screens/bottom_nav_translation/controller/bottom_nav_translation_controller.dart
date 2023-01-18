import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bhashaverse/common/controller/language_model_controller.dart';
import 'package:bhashaverse/utils/wavefrom_style.dart';
import 'package:bhashaverse/enums/gender_enum.dart';
import 'package:bhashaverse/enums/language_enum.dart';
import 'package:bhashaverse/utils/voice_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
  RxBool isRecordedViaMic = false.obs;
  RxBool isPlayingSource = false.obs;
  RxBool isPlayingTarget = false.obs;
  RxBool isKeyboardVisible = false.obs;
  String sourcePath = '';
  String targetPath = '';
  RxInt maxDuration = 0.obs;
  RxInt currentDuration = 0.obs;
  File? targetLanAudioFile;

  final VoiceRecorder _voiceRecorder = VoiceRecorder();

  late final Box _hiveDBInstance;

  late PlayerController controller;

  @override
  void onInit() {
    _translationAppAPIClient = Get.find();
    _languageModelController = Get.find();
    _hiveDBInstance = Hive.box(hiveDBName);

    controller = PlayerController();

    controller.onCompletion.listen((event) {
      isPlayingSource.value = false;
      isPlayingTarget.value = false;
    });

    controller.onCurrentDurationChanged.listen((duration) {
      currentDuration.value = duration;
    });

    controller.onPlayerStateChanged.listen((_) {
      switch (controller.playerState) {
        case PlayerState.initialized:
          maxDuration.value = controller.maxDuration;
          break;
        case PlayerState.paused:
          isPlayingSource.value = false;
          isPlayingTarget.value = false;
          currentDuration.value = 0;
          break;
        case PlayerState.stopped:
          currentDuration.value = 0;
          break;
        default:
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    sourceLanTextController.dispose();
    targetLangTextController.dispose();
    disposePlayer();
    deleteAudioFiles();
    super.onClose();
  }

  void swapSourceAndTargetLanguage() {
    if (isSourceAndTargetLangSelected()) {
      String tempSourceLanguage = selectedSourceLanguage.value;
      selectedSourceLanguage.value = selectedTargetLanguage.value;
      selectedTargetLanguage.value = tempSourceLanguage;
      resetAllValues();
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
                  genderResponse['output']['audio'][0]['audioContent'] ?? '';
            } else {
              targetTTSResponseForFemale =
                  genderResponse['output']['audio'][0]['audioContent'] ?? '';
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
    if (isPlayingForTarget) {
      GenderEnum? preferredGender = GenderEnum.values
          .byName(_hiveDBInstance.get(preferredVoiceAssistantGender));

      bool isMaleTTSAvailable = targetTTSResponseForMale != null &&
          targetTTSResponseForMale.isNotEmpty;

      bool isFemaleTTSAvailable = targetTTSResponseForFemale != null &&
          targetTTSResponseForFemale.isNotEmpty;

      Uint8List? fileAsBytes;
      if ((preferredGender == GenderEnum.male && isMaleTTSAvailable) ||
          (!isFemaleTTSAvailable && isMaleTTSAvailable)) {
        if (preferredGender == GenderEnum.female) {
          showDefaultSnackbar(message: femaleVoiceAssistantNotAvailable.tr);
        }
        fileAsBytes = base64Decode(targetTTSResponseForMale);
      } else if ((preferredGender == GenderEnum.female &&
              isFemaleTTSAvailable) ||
          (!isMaleTTSAvailable && isFemaleTTSAvailable)) {
        if (preferredGender == GenderEnum.male) {
          showDefaultSnackbar(message: maleVoiceAssistantNotAvailable.tr);
        }
        fileAsBytes = base64Decode(targetTTSResponseForFemale);
      } else {
        showDefaultSnackbar(message: noVoiceAssistantAvailable.tr);
      }

      if (fileAsBytes != null) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        targetPath =
            '${appDocDir.path}/$defaultTTSPlayName${DateTime.now().millisecondsSinceEpoch}.wav';
        targetLanAudioFile = File(targetPath);
        if (targetLanAudioFile != null && !await targetLanAudioFile!.exists()) {
          await targetLanAudioFile?.writeAsBytes(fileAsBytes);
        }
        isPlayingTarget.value = true;
        await prepareWaveforms(targetPath, isForTargeLanguage: true);
        isPlayingSource.value = false;
      }
    } else {
      String? recordedAudioFilePath = _voiceRecorder.getAudioFilePath();
      if (recordedAudioFilePath != null && recordedAudioFilePath.isNotEmpty) {
        sourcePath = _voiceRecorder.getAudioFilePath()!;
        isPlayingSource.value = true;
        await prepareWaveforms(sourcePath, isForTargeLanguage: false);
        isPlayingTarget.value = false;
      }
    }
  }

  void resetAllValues() async {
    sourceLanTextController.clear();
    targetLangTextController.clear();
    isMicButtonTapped.value = false;
    isTranslateCompleted.value = false;
    isRecordedViaMic.value = false;
    await deleteAudioFiles();
    maxDuration.value = 0;
    currentDuration.value = 0;
    sourcePath = '';
    targetTTSResponseForMale = null;
    targetTTSResponseForFemale = null;
    await stopPlayer();
    sourcePath = '';
    targetPath = '';
  }

  Future<void> prepareWaveforms(
    String filePath, {
    required bool isForTargeLanguage,
  }) async {
    if (controller.playerState == PlayerState.playing ||
        controller.playerState == PlayerState.paused) {
      controller.stopPlayer();
    }
    await controller.preparePlayer(
        path: filePath,
        noOfSamples: WaveformStyle.getDefaultPlayerStyle(
                isRecordedAudio: !isForTargeLanguage)
            .getSamplesForWidth(WaveformStyle.getDefaultWidth));
    maxDuration.value = controller.maxDuration;
    startOrStopPlayer();
  }

  void startOrStopPlayer() async {
    controller.playerState.isPlaying
        ? await controller.pausePlayer()
        : await controller.startPlayer(
            finishMode: FinishMode.pause,
          );
  }

  disposePlayer() async {
    await stopPlayer();
    controller.dispose();
  }

  Future<void> stopPlayer() async {
    if (controller.playerState.isPlaying) {
      await controller.stopPlayer();
    }
    isPlayingTarget.value = false;
    isPlayingSource.value = false;
  }

  Future<void> deleteAudioFiles() async {
    _voiceRecorder.deleteRecordedFile();
    if (targetLanAudioFile != null && !await targetLanAudioFile!.exists()) {
      await targetLanAudioFile?.delete();
    }
  }
}
