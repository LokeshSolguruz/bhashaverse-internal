import 'package:get/get.dart';

import '../controller/source_language_controller.dart';

class SourceLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SourceLanguageController());
  }
}
