import 'package:bhashaverse/presentation/home/home_screen/binding/home_binding.dart';
import 'package:bhashaverse/presentation/home/home_screen/home_screen.dart';
import 'package:bhashaverse/presentation/home/source_language/binding/source_language_binding.dart';
import 'package:bhashaverse/presentation/home/source_language/source_language_screen.dart';
import 'package:bhashaverse/presentation/home/target_lanugage/binding/target_language_binding.dart';
import 'package:bhashaverse/presentation/home/target_lanugage/target_language_screen.dart';
import 'package:bhashaverse/presentation/onboarding/binding/onboarding_binding.dart';
import 'package:bhashaverse/presentation/onboarding/onboarding_screen.dart';
import 'package:bhashaverse/presentation/select_app_language/binding/app_language_binding.dart';
import 'package:bhashaverse/presentation/select_app_language/app_language.dart';
import 'package:bhashaverse/presentation/select_voice_assistant/binding/voice_assistant_binding.dart';
import 'package:bhashaverse/presentation/select_voice_assistant/voice_assistant_screen.dart';
import 'package:bhashaverse/presentation/splash_screen/binding/splash_binding.dart';
import 'package:bhashaverse/presentation/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String homeRoute = '/home_route';
  static String splashRoute = '/splash_route';
  static String appLanguageRoute = '/app_language_route';
  static String voiceAssistantRoute = '/voice_assistant_route';
  static String onboardingRoute = '/onboarding_route';
  static String bottomNavTranslation = '/bottom_nav_translation';
  static String translateFrom = '/translate_from_route';
  static String translateTo = '/translate_to_route';

  static List<GetPage> pages = [
    GetPage(
      name: splashRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: appLanguageRoute,
      page: () => const AppLanguage(),
      binding: AppLanguageBinding(),
    ),
    GetPage(
      name: onboardingRoute,
      page: () => const OnBoardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: voiceAssistantRoute,
      page: () => const VoiceAssistantScreen(),
      binding: VoiceAssistantBinding(),
    ),
    GetPage(
      name: homeRoute,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: translateFrom,
      page: () => const SourceLanguageScreen(),
      binding: SourceLanguageBinding(),
    ),
    GetPage(
      name: translateTo,
      page: () => const TargetLanguageScreen(),
      binding: TargetLanguageBinding(),
    ),
  ];
}
