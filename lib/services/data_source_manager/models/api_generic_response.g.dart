// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_generic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ApiGenericResponse _$$_ApiGenericResponseFromJson(
        Map<String, dynamic> json) =>
    _$_ApiGenericResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_ApiGenericResponseToJson(
        _$_ApiGenericResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
