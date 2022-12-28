import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/app_language_model.dart';

class BottomNavTranslationController extends GetxController {
  Rx<TextEditingController> inputFieldController =
      (TextEditingController()).obs;
  Rx<TextEditingController> targetLangTextController =
      (TextEditingController()).obs;
  RxBool isTranslateCompleted = false.obs;
  RxBool isMicButtonTapped = false.obs;
  RxBool isVisible = true.obs;

  var sourceLanguage = Rxn<AppLanguageModel>();
  var targetLanguage = Rxn<AppLanguageModel>();

  @override
  void onClose() {
    super.onClose();
    inputFieldController.value.dispose();
  }

  void interchangeSourceAndTargetLanguage() {
    if (isSourceAndTargetLangSelected()) {
      AppLanguageModel tempLanguage = sourceLanguage.value!;
      sourceLanguage.value = targetLanguage.value;
      targetLanguage.value = tempLanguage;
      if (isTranslateCompleted.value) {
        String tempSourceLangText = inputFieldController.value.text;
        inputFieldController.value.text = targetLangTextController.value.text;
        targetLangTextController.value.text = tempSourceLangText;
      }
    } else {
      showErrorSourceAndTargetNotSelected();
    }
  }

  bool isSourceAndTargetLangSelected() =>
      sourceLanguage.value != null && targetLanguage.value != null;

  void showErrorSourceAndTargetNotSelected() {
    Get.showSnackbar(const GetSnackBar(
      message: 'Please select source and target language first',
      isDismissible: true,
      duration: Duration(seconds: 3),
    ));
  }
}
