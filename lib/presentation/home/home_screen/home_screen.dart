import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_bottom_bar.dart';
import '../../../utils/theme/app_colors.dart';
import 'controller/home_controller.dart';
import '../bottom_nav_screens/bottom_nav_chat/bottom_nav_chat.dart';
import '../bottom_nav_screens/bottom_nav_settings/bottom_nav_settings.dart';
import '../bottom_nav_screens/bottom_nav_translation/bottom_nav_translation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _homeController;

  @override
  void initState() {
    _homeController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sassyGreen,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(
          () => getCurrentBottomWidget(_homeController.bottomBarIndex.value),
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomBar(
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
      case 1:
        return const BottomNavChat();
      case 2:
        return const BottomNavSettings();
      default:
        return const BottomNavTranslation();
    }
  }
}
