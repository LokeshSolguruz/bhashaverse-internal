import 'package:bhashaverse/enums/gender_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isTransLiterationOn = false.obs;
  Rx<GenderEnum> selectedGender = (GenderEnum.male).obs;
  Rx<ThemeMode> selectedThemeMode = (ThemeMode.light).obs;
}
