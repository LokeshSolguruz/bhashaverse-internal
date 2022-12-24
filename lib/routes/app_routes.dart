import 'package:bhashaverse/presentation/home_screen/binding/home_binding.dart';
import 'package:bhashaverse/presentation/home_screen/home_screen.dart';
import 'package:bhashaverse/presentation/splash_screen/binding/splash_binding.dart';
import 'package:bhashaverse/presentation/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String homeRoute = '/home_route';
  static String splashRoute = '/splash_route';

  static List<GetPage> pages = [
    GetPage(
      name: splashRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: homeRoute,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
