import 'package:get/get.dart';

import '../../../../common/controller/language_model_controller.dart';
import '../../../../services/translation_app_api_client.dart';
import '../../bottom_nav_screens/bottom_nav_settings/controller/settings_controller.dart';
import '../../bottom_nav_screens/bottom_nav_translation/controller/bottom_nav_translation_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TranslationAppAPIClient.getAPIClientInstance(), permanent: true);
    Get.put(LanguageModelController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BottomNavTranslationController());
    Get.lazyPut(() => SettingsController());
  }
}
