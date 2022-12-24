import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import 'presentation/splash_screen/binding/splash_binding.dart';
import 'routes/app_routes.dart';
import 'utils/constants/app_constants.dart';
import 'utils/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await Hive.openBox(hiveDBName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      getPages: AppRoutes.pages,
      initialBinding: SplashBinding(),
      initialRoute: AppRoutes.splashRoute,
    );
  }
}
