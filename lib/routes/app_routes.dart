import 'package:bhashaverse/presentation/home_screen/binding/home_binding.dart';
import 'package:bhashaverse/presentation/home_screen/home_screen.dart';
import 'package:bhashaverse/presentation/onboarding/binding/onboarding_binding.dart';
import 'package:bhashaverse/presentation/onboarding/onboarding_screen.dart';
import 'package:bhashaverse/presentation/select_app_language/binding/app_language_binding.dart';
import 'package:bhashaverse/presentation/select_app_language/app_language.dart';
import 'package:bhashaverse/presentation/splash_screen/binding/splash_binding.dart';
import 'package:bhashaverse/presentation/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String homeRoute = '/home_route';
  static String splashRoute = '/splash_route';
  static String appLanguageRoute = '/app_language_route';
  static String onboardingRoute = '/onboarding_route';

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
      name: homeRoute,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
