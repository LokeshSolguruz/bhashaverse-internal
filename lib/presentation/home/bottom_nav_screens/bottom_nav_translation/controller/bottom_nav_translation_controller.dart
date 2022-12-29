import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/app_constants.dart';

class BottomNavTranslationController extends GetxController {
  Rx<TextEditingController> inputFieldController =
      (TextEditingController()).obs;
  Rx<TextEditingController> targetLangTextController =
      (TextEditingController()).obs;
  RxBool isTranslateCompleted = false.obs;
  RxBool isMicButtonTapped = false.obs;
  RxBool isVisible = true.obs;

  RxString selectedSourceLanguage = ''.obs;
  RxString selectedTargetLanguage = ''.obs;

  @override
  void onClose() {
    super.onClose();
    inputFieldController.value.dispose();
  }

  void interchangeSourceAndTargetLanguage() {
    if (isSourceAndTargetLangSelected()) {
      String tempSourceLanguage = selectedSourceLanguage.value;
      selectedSourceLanguage.value = selectedTargetLanguage.value;
      selectedTargetLanguage.value = tempSourceLanguage;
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
      selectedSourceLanguage.value.isNotEmpty &&
      selectedTargetLanguage.value.isNotEmpty;

  String getSelectedSourceLanguageName() {
    if (selectedSourceLanguage.value.isEmpty) {
      return AppStrings.kTranslateSourceTitle;
    } else {
      return selectedSourceLanguage.value;
    }
  }

  String getSelectedTargetLanguageName() {
    if (selectedTargetLanguage.value.isEmpty) {
      return AppStrings.kTranslateTargetTitle;
    } else {
      return selectedTargetLanguage.value;
    }
  }

  void showErrorSourceAndTargetNotSelected() {
    Get.showSnackbar(const GetSnackBar(
      message: 'Please select source and target language first',
      isDismissible: true,
      duration: Duration(seconds: 3),
    ));
  }
}
