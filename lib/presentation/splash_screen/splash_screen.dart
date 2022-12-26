import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/screen_util/screen_util.dart';
import '../../utils/theme/app_colors.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController _splashController;

  @override
  void initState() {
    _splashController = Get.find();
    super.initState();
    ScreenUtil().init();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offNamed(AppRoutes.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: flushOrangeColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            imgSplashLogo,
            height: 100.toHeight,
            width: 100.toWidth,
          ),
        ),
      ),
    );
  }
}
