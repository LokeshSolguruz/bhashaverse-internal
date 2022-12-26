import 'package:get/get.dart';

import '../../../common/controller/language_model_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../services/translation_app_api_client.dart';
import '../../../utils/constants/api_constants.dart';

class SplashController extends GetxController {
  late TranslationAppAPIClient _translationAppAPIClient;
  late LanguageModelController _languageModelController;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    _translationAppAPIClient = Get.find();
    _languageModelController = Get.find();
    super.onInit();
  }

  void calcAvailableSourceAndTargetLanguages() async {
    List<dynamic> taskPayloads = [];
    for (String eachModelType in APIConstants.TYPES_OF_MODELS_LIST) {
      taskPayloads.add({
        "task": eachModelType,
        "sourceLanguage": "",
        "targetLanguage": "",
        "domain": "All",
        "submitter": "All",
        "userId": null
      });
    }

    var allModelResponse =
        await _translationAppAPIClient.getAllModels(taskPayloads: taskPayloads);
    allModelResponse.when(
      success: ((allModelList) {
        isLoading.value = false;
        _languageModelController
            .calcAvailableSourceAndTargetLanguages(allModelList);
        Get.offNamed(AppRoutes.homeRoute);
      }),
      failure: (error) {
        isLoading.value = false;
        Get.showSnackbar(GetSnackBar(message: error.message ?? ''));
        Get.offNamed(AppRoutes.homeRoute);
      },
    );
  }
}
