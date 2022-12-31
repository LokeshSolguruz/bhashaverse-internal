import 'dart:collection';
import 'package:bhashaverse/utils/constants/api_constants.dart';
import 'package:get/get.dart';

import '../../enums/language_enum.dart';
import '../../models/search_model.dart';

class LanguageModelController extends GetxController {
  final Set<String> _allAvailableSourceLanguages = {};
  RxList<dynamic> get allAvailableSourceLanguages =>
      SplayTreeSet.from(_allAvailableSourceLanguages).toList().obs;

  final Set<String> _availableTargetLangsForSelectedSourceLang = {};
  Set<String> get availableTargetLangsForSelectedSourceLang =>
      SplayTreeSet.from(_availableTargetLangsForSelectedSourceLang);

  final Set<String> _allAvailableTargetLanguages = {};
  RxList<dynamic> get allAvailableTargetLanguages =>
      SplayTreeSet.from(_allAvailableTargetLanguages).toList().obs;

  late SearchModel _availableASRModels;
  SearchModel get availableASRModels => _availableASRModels;

  late SearchModel _availableTranslationModels;
  SearchModel get availableTranslationModels => _availableTranslationModels;

  late SearchModel _availableTTSModels;
  SearchModel get availableTTSModels => _availableTTSModels;

  void calcAvailableSourceAndTargetLanguages(List<dynamic> allModelList) {
    /// TODO: Handel when perticular model not available
    _availableASRModels = allModelList.firstWhere((eachTaskResponse) {
      return eachTaskResponse['taskType'] == 'asr';
    })['modelInstance'];
    _availableTranslationModels = allModelList.firstWhere((eachTaskResponse) =>
        eachTaskResponse['taskType'] == 'translation')['modelInstance'];
    _availableTTSModels = allModelList.firstWhere((eachTaskResponse) =>
        eachTaskResponse['taskType'] == 'tts')['modelInstance'];

    //Retrieve ASR Models
    Set<String> availableASRModelLanguagesSet = {};
    for (Data eachASRModel in _availableASRModels.data) {
      availableASRModelLanguagesSet
          .add(eachASRModel.languages[0].sourceLanguage.toString());
    }

    //Retrieve TTS Models
    Set<String> availableTTSModelLanguagesSet = {};
    for (Data eachTTSModel in _availableTTSModels.data) {
      availableTTSModelLanguagesSet
          .add(eachTTSModel.languages[0].sourceLanguage.toString());
    }

    var availableTranslationModelsList = _availableTranslationModels.data;

    if (availableASRModelLanguagesSet.isEmpty ||
        availableTTSModelLanguagesSet.isEmpty ||
        availableTranslationModelsList.isEmpty) {
      throw Exception('Models not retrieved!');
    }

    Set<String> allASRAndTTSLangCombinationsSet = {};
    for (String eachASRAvailableLang in availableASRModelLanguagesSet) {
      for (String eachTTSAvailableLang in availableTTSModelLanguagesSet) {
        allASRAndTTSLangCombinationsSet
            .add('$eachASRAvailableLang-$eachTTSAvailableLang');
      }
    }
    Set<String> availableTransModelLangCombinationsSet = {};
    for (Data eachTranslationModel in availableTranslationModelsList) {
      availableTransModelLangCombinationsSet.add(
          '${eachTranslationModel.languages[0].sourceLanguage}-${eachTranslationModel.languages[0].targetLanguage}');
    }

    Set<String> canUseSourceAndTargetLangSet = allASRAndTTSLangCombinationsSet
        .intersection(availableTransModelLangCombinationsSet);

    for (String eachUseableLangPair in canUseSourceAndTargetLangSet) {
      _allAvailableSourceLanguages.add(APIConstants.getLanguageCodeOrName(
          value: eachUseableLangPair.split('-')[0],
          returnWhat: LanguageMap.devanagariName,
          lang_code_map: APIConstants.LANGUAGE_CODE_MAP));
      _allAvailableTargetLanguages.add(APIConstants.getLanguageCodeOrName(
          value: eachUseableLangPair.split('-')[1],
          returnWhat: LanguageMap.devanagariName,
          lang_code_map: APIConstants.LANGUAGE_CODE_MAP));
    }
  }
}
