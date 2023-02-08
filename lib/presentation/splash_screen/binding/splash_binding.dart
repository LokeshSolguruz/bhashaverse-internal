import 'package:get/get.dart';

import '../../../common/controller/language_model_controller.dart';
import '../../../services/translation_app_api_client.dart';
import '../../../utils/mic_streamer.dart';
import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TranslationAppAPIClient.getAPIClientInstance(), permanent: true);
    Get.put(LanguageModelController());
    Get.put(MicStreamer());
    Get.put(SplashController());
  }
}
