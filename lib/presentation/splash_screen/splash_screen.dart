import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
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
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offNamed(AppRoutes.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Welcome'),
        ),
      ),
    );
  }
}
