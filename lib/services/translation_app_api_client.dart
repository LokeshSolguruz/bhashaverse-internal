import 'package:bhashaverse/utils/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/search_model.dart';
import 'data_source_manager/exception/app_exceptions.dart';
import 'data_source_manager/models/api_result.dart';
import 'network_error.dart';

class TranslationAppAPIClient {
  late Dio _dio;

  static TranslationAppAPIClient? translationAppAPIClient;

  TranslationAppAPIClient(dio) {
    _dio = dio;
  }

  static TranslationAppAPIClient getAPIClientInstance() {
    var options = BaseOptions(
      baseUrl: APIConstants.STS_BASE_URL,
      connectTimeout: 80000,
      receiveTimeout: 50000,
    );

    translationAppAPIClient =
        translationAppAPIClient ?? TranslationAppAPIClient(Dio(options));
    return translationAppAPIClient!;
  }

  Future<Result<AppException, dynamic>> getAllModels(
      {required List<dynamic> taskPayloads}) async {
    try {
      final asrTranslationTtsResponses =
          await Future.wait(taskPayloads.map((eachTaskPayload) {
        /// TODO: Handel when perticular model not available
        return _dio.post(APIConstants.SEARCH_REQ_URL, data: eachTaskPayload);
      }));

      List<Map<String, dynamic>> asrTranslationTTSResponsesList = [];

      /*
      Could have done asrTranslationTtsResponses.map((e){}) but to access the index of each element,
      use .asMap().entries.map((e){}). Index: e.key, Original Value: e.value
      */
      asrTranslationTtsResponses.asMap().entries.map((eachResponse) {
        asrTranslationTTSResponsesList.add({
          'taskType': taskPayloads[eachResponse.key]['task'],
          'modelInstance': SearchModel.fromJson(eachResponse.value.data)
        });
      }).toList();

      return Result.success(asrTranslationTTSResponsesList);
    } on DioError catch (error) {
      return Result.failure(
          AppException(NetworkError(error).getErrorModel().errorMessage));
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Other Exception::: ${error.toString()}');
      }
      return Result.failure(AppException('Something went wrong'));
    }
  }

  Future<Result<AppException, dynamic>> sendASRRequest(
      {required asrPayload}) async {
    try {
      var response = await _dio.post(APIConstants.ASR_REQ_URL,
          data: asrPayload,
          options: Options(
              headers: {'Content-Type': 'application/json', 'Accept': '*/*'}));
      return Result.success(response.data['data']);
    } on DioError catch (error) {
      return Result.failure(
          AppException(NetworkError(error).getErrorModel().errorMessage));
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Other Exception::: ${error.toString()}');
      }
      return Result.failure(AppException('Something went wrong'));
    }
  }

  Future<Result<AppException, dynamic>> sendTranslationRequest(
      {required transPayload}) async {
    try {
      var response = await _dio.post(APIConstants.TRANS_REQ_URL,
          data: transPayload,
          options: Options(
              headers: {'Content-Type': 'application/json', 'Accept': '*/*'}));
      return Result.success(response.data['output'][0]);
    } on DioError catch (error) {
      return Result.failure(
          AppException(NetworkError(error).getErrorModel().errorMessage));
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Other Exception::: ${error.toString()}');
      }
      return Result.failure(AppException('Something went wrong'));
    }
  }

  Future<dynamic> sendTTSRequest({required ttsPayload}) async {
    try {
      var response = await _dio.post(APIConstants.TTS_REQ_URL,
          data: ttsPayload,
          options: Options(
              headers: {'Content-Type': 'application/json', 'Accept': '*/*'}));
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Result<AppException, dynamic>> sendTTSReqTranslation(
      {required List<dynamic> ttsPayloadList}) async {
    try {
      final ttsResponsesList = await Future.wait(ttsPayloadList.map(
          (eachTaskPayload) => _dio.post(APIConstants.TTS_REQ_URL,
              data: eachTaskPayload,
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Accept': '*/*'
              }))));

      List<Map<String, dynamic>> ttsOutputResponsesList = [];

      /*
      Could have done asrTranslationTtsResponses.map((e){}) but to access the index of each element,
      use .asMap().entries.map((e){}). Index: e.key, Original Value: e.value
      */
      ttsResponsesList.asMap().entries.map((eachResponse) {
        if (eachResponse.value.statusCode == 200) {
          ttsOutputResponsesList.add({
            'gender': ttsPayloadList[eachResponse.key]['gender'],
            'output': eachResponse.value.data
          });
        }
      }).toList();
      if (ttsOutputResponsesList.isNotEmpty) {
        return Result.success(ttsOutputResponsesList);
      } else {
        return Result.failure(
            AppException(APIConstants.kErrorMessageGenericError));
      }
    } on DioError catch (error) {
      return Result.failure(
          AppException(NetworkError(error).getErrorModel().errorMessage));
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Other Exception::: ${error.toString()}');
      }
      return Result.failure(
          AppException(APIConstants.kErrorMessageGenericError));
    }
  }
}
