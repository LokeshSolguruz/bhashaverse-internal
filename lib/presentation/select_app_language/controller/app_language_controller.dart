import 'package:get/get.dart';

import '../../../models/app_language_model.dart';
import '/utils/constants/app_constants.dart';

class AppLanguageController extends GetxController {
  final _selectedLanguage = Rxn<int>();

  int? getSelectedLanguageIndex() {
    return _selectedLanguage.value;
  }

  void setSelectedLanguageIndex(int index) {
    _selectedLanguage.value = index;
  }

// Get app language list
  List<AppLanguageModel> _getAppLanguageList() {
    List<AppLanguageModel> languageList = <AppLanguageModel>[];

    languageList.add(AppLanguageModel(
      title: AppStrings.english,
      subTitle: AppStrings.english,
    ));
    languageList.add(AppLanguageModel(
      title: AppStrings.hindiNative,
      subTitle: AppStrings.hindi,
    ));
    languageList.add(AppLanguageModel(
      title: AppStrings.marathiNative,
      subTitle: AppStrings.marathi,
    ));
    languageList.add(AppLanguageModel(
      title: AppStrings.punjabiNative,
      subTitle: AppStrings.punjabi,
    ));
    languageList.add(AppLanguageModel(
      title: AppStrings.bengaliNative,
      subTitle: AppStrings.bengali,
    ));
    languageList.add(AppLanguageModel(
      title: AppStrings.tamilNative,
      subTitle: AppStrings.tamil,
    ));
    languageList.add(AppLanguageModel(
      title: AppStrings.kannadaNative,
      subTitle: AppStrings.kannada,
    ));

    return languageList;
  }

  List<AppLanguageModel> getAppLanguageList() => _getAppLanguageList();
}
