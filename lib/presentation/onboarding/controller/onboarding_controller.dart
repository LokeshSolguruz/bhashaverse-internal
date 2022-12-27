import 'package:get/get.dart';

import '/models/onboarding_model.dart';
import '/utils/constants/app_constants.dart';

class OnboardingController extends GetxController {
  final RxInt _currentPageIndex = 0.obs;

  int getCurrentPageIndex() => _currentPageIndex.value;

  void setCurrentPageIndex(int index) {
    _currentPageIndex.value = index;
  }

// Get onboarding page list
  List<OnboardingModel> _onboardingPageList() {
    List<OnboardingModel> pages = <OnboardingModel>[];

    pages.add(OnboardingModel(
      imagePath: imgOnboarding1,
      headerText: AppStrings.speechRecognition,
      bodyText: AppStrings.automaticallyRecognizeAndConvert,
    ));
    pages.add(OnboardingModel(
      imagePath: imgOnboarding2,
      headerText: AppStrings.speechToSpeechTranslation,
      bodyText: AppStrings.translateYourVoiceInOneIndianLanguage,
    ));
    pages.add(OnboardingModel(
      imagePath: imgOnboarding3,
      headerText: AppStrings.languageTranslation,
      bodyText: AppStrings.translateSentencesFromOneIndianLanguageToAnother,
    ));
    pages.add(OnboardingModel(
      imagePath: imgOnboarding4,
      headerText: AppStrings.bhashaverseChatBot,
      bodyText: AppStrings.translateSentencesFromOneIndianLanguageToAnother,
    ));

    return pages;
  }

  List<OnboardingModel> getOnboardingPageList() => _onboardingPageList();
}
