import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../animation/lottie_animation.dart';
import '../widgets/custom_bottom_bar.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/theme/app_colors.dart';
import '../../home/home_screen/controller/home_controller.dart';
import '../bottom_nav_screens/bottom_nav_translation/controller/bottom_nav_translation_controller.dart';
import '../bottom_nav_screens/bottom_nav_settings/bottom_nav_settings.dart';
import '../bottom_nav_screens/bottom_nav_translation/bottom_nav_translation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _homeController;
  late BottomNavTranslationController _bottomNavTranslationController;

  @override
  void initState() {
    _homeController = Get.find();
    _bottomNavTranslationController = Get.find();
    super.initState();
    _homeController.calcAvailableSourceAndTargetLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sassyGreen,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(
          () => Stack(
            clipBehavior: Clip.none,
            children: [
              getCurrentBottomWidget(_homeController.bottomBarIndex.value),
              if (_homeController.isModelsLoading.value ||
                  _bottomNavTranslationController.isLsLoading.value)
                LottieAnimation(
                    context: context,
                    lottieAsset: _homeController.isModelsLoading.value
                        ? animationHomeLoading
                        : animationTranslationLoading,
                    footerText: _homeController.isModelsLoading.value
                        ? AppStrings.kHomeLoadingAnimationText
                        : AppStrings.kTranslationLoadingAnimationText),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => _homeController.isModelsLoading.value ||
                _bottomNavTranslationController.isLsLoading.value
            ? const SizedBox.shrink()
            : CustomBottomBar(
                currentIndex: _homeController.bottomBarIndex.value,
                onChanged: (int index) {
                  _homeController.bottomBarIndex.value = index;
                },
              ),
      ),
    );
  }

  Widget getCurrentBottomWidget(int index) {
    switch (index) {
      case 0:
        return const BottomNavTranslation();
      // TODO: uncomment after chat feature added
      // case 1:
      //   return const BottomNavChat();
      case 1:
        return const BottomNavSettings();
      default:
        return const BottomNavTranslation();
    }
  }
}
