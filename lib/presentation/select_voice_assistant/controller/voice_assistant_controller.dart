import 'package:get/get.dart';

import '../../../enums/gender_enum.dart';

class VoiceAssistantController extends GetxController {
  final Rx<GenderEnum> _selectedGender = (GenderEnum.male).obs;

  GenderEnum getSelectedGender() => _selectedGender.value;

  void setSelectedGender(GenderEnum selectedGender) {
    _selectedGender.value = selectedGender;
  }
}
