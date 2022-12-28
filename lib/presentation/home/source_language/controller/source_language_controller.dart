import 'package:get/get.dart';

import '../../../../models/app_language_model.dart';
import '/utils/constants/app_constants.dart';

class SourceLanguageController extends GetxController {
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
      image: imgEnglish,
      title: AppStrings.english,
      subTitle: AppStrings.english,
    ));
    languageList.add(AppLanguageModel(
      image: imgHindi,
      title: AppStrings.hindiNative,
      subTitle: AppStrings.hindi,
    ));
    languageList.add(AppLanguageModel(
      image: imgMarathi,
      title: AppStrings.marathiNative,
      subTitle: AppStrings.marathi,
    ));
    languageList.add(AppLanguageModel(
      image: imgPunjabi,
      title: AppStrings.punjabiNative,
      subTitle: AppStrings.punjabi,
    ));
    languageList.add(AppLanguageModel(
      image: imgBengali,
      title: AppStrings.bengaliNative,
      subTitle: AppStrings.bengali,
    ));
    languageList.add(AppLanguageModel(
      image: imgTamil,
      title: AppStrings.tamilNative,
      subTitle: AppStrings.tamil,
    ));
    languageList.add(AppLanguageModel(
      image: imgKannada,
      title: AppStrings.kannadaNative,
      subTitle: AppStrings.kannada,
    ));

    return languageList;
  }

  List<AppLanguageModel> getAppLanguageList() => _getAppLanguageList();
}
