import 'package:get/get.dart';

class LanguageSelectionController extends GetxController {
  final _selectedLanguage = Rxn<int>();

  int? getSelectedLanguageIndex() {
    return _selectedLanguage.value;
  }

  void setSelectedLanguageIndex(int index) {
    _selectedLanguage.value = index;
  }
}
