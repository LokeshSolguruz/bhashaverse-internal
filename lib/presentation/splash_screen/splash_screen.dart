import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../routes/app_routes.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/screen_util/screen_util.dart';
import '../../utils/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    ScreenUtil().init();

    Future.delayed(const Duration(seconds: 3)).then((value) {
      final bool isIntroShownAlready =
          Hive.box(hiveDBName).get(introShownAlreadyKey, defaultValue: false);

      Get.offNamed(isIntroShownAlready
          ? AppRoutes.homeRoute
          : AppRoutes.appLanguageRoute);
    });

    return Scaffold(
      backgroundColor: flushOrangeColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            imgAppLogoSmall,
            height: 100.toHeight,
            width: 100.toWidth,
          ),
        ),
      ),
    );
  }
}
