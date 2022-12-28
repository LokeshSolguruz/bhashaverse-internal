import 'package:get/get.dart';

import '../controller/target_language_controller.dart';

class TargetLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TargetLanguageController());
  }
}
