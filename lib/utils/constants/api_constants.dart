// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:bhashaverse/enums/language_enum.dart';

class APIConstants {
  static const String ASR_CALLBACK_AZURE_URL =
      'https://meity-dev-asr.ulcacontrib.org/asr/v1/recognize';
  static const String ASR_CALLBACK_CDAC_URL =
      'https://cdac.ulcacontrib.org/asr/v1/recognize';
  static const String STS_BASE_URL =
      'https://meity-auth.ulcacontrib.org/ulca/apis';

  static const String SEARCH_REQ_URL = '/v0/model/search';
  static const String ASR_REQ_URL = '/asr/v1/model/compute';
  static const String TRANS_REQ_URL = '/v0/model/compute';
  static const String TTS_REQ_URL = '/v0/model/compute';

  static const int kApiUnknownErrorCode = 0;
  static const int kApiCanceledCode = -1;
  static const int kApiConnectionTimeoutCode = -2;
  static const int kApiDefaultCode = -3;
  static const int kApiReceiveTimeoutCode = -4;
  static const int kApiSendTimeoutCode = -5;
  static const int kApiUnAuthorizedExceptionErrorCode = 401;
  static const int kApiDataConflictCode = 409;

  static const String kApiUnknownError = 'UNKNOWN_ERROR';
  static const String kApiCanceled = 'API_CANCELED';
  static const String kApiConnectionTimeout = 'CONNECT_TIMEOUT';
  static const String kApiDefault = 'DEFAULT';
  static const String kApiReceiveTimeout = 'RECEIVE_TIMEOUT';
  static const String kApiSendTimeout = 'SEND_TIMEOUT';
  static const String kApiResponseError = 'RESPONSE_ERROR';
  static const String kApiDataConflict = 'DATA_CONFLICT';

  // Common masked error messages
  static const String kErrorMessageConnectionTimeout = 'Connection timed out';
  static const String kErrorMessageNetworkError = 'Network error';
  static const String kErrorMessageGenericError = 'Something went wrong';

  // HandshakeException
  static const String kApiAuthExceptionError = 'AUTH_EXCEPTION';
  static const String kErrorMessageUnAuthorizedException =
      'UnAuthorized. Please login again';

  static final List<String> TYPES_OF_MODELS_LIST = [
    'asr',
    'translation',
    'tts'
  ]; // This shall be same as keys in DEFAULT_MODEL_ID, DEFAULT_MODEL_TYPES

  static final LANGUAGE_CODE_MAP = {
    'language_codes': [
      {'language_name': 'اردو', 'language_code': 'ur'},
      {'language_name': 'ଓଡିଆ', 'language_code': 'or'},
      {'language_name': 'தமிழ்', 'language_code': 'ta'},
      {'language_name': 'हिन्दी', 'language_code': 'hi'},
      {'language_name': 'डोगरी', 'language_code': 'doi'},
      {'language_name': 'తెలుగు', 'language_code': 'te'},
      {'language_name': 'नेपाली', 'language_code': 'ne'},
      {'language_name': 'English', 'language_code': 'en'},
      {'language_name': 'ਪੰਜਾਬੀ', 'language_code': 'pa'},
      {'language_name': 'සිංහල', 'language_code': 'si'},
      {'language_name': 'मराठी', 'language_code': 'mr'},
      {'language_name': 'ಕನ್ನಡ', 'language_code': 'kn'},
      {'language_name': 'বাংলা', 'language_code': 'bn'},
      {'language_name': 'संस्कृत', 'language_code': 'sa'},
      {'language_name': 'অসমীয়া', 'language_code': 'as'},
      {'language_name': 'ગુજરાતી', 'language_code': 'gu'},
      {'language_name': 'मैथिली', 'language_code': 'mai'},
      {'language_name': 'भोजपुरी', 'language_code': 'bho'},
      {'language_name': 'മലയാളം', 'language_code': 'ml'},
      {'language_name': 'राजस्थानी', 'language_code': 'raj'},
      {'language_name': 'Bodo', 'language_code': 'brx'},
      {'language_name': 'মানিপুরি', 'language_code': 'mni'},
    ]
  };

  static String getLanguageCodeOrName(
      {required String value,
      required returnWhat,
      required Map<String, List<Map<String, String>>> lang_code_map}) {
    // If Language Code is to be returned that means the value received is a language name
    try {
      if (returnWhat == LanguageMap.languageCode) {
        var returningLangPair = lang_code_map['language_codes']!.firstWhere(
            (eachLanguageCodeNamePair) =>
                eachLanguageCodeNamePair['language_name']!.toLowerCase() ==
                value.toLowerCase());
        return returningLangPair['language_code'] ?? 'No Language Code Found';
      }

      var returningLangPair = lang_code_map['language_codes']!.firstWhere(
          (eachLanguageCodeNamePair) =>
              eachLanguageCodeNamePair['language_code']!.toLowerCase() ==
              value.toLowerCase());
      return returningLangPair['language_name'] ?? 'No Language Name Found';
    } catch (e) {
      return 'No Return Value Found';
    }
  }
}
