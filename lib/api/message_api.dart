import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:dio/dio.dart';

class MessageApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/message', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(String messageId, dynamic data) =>
      put('v1/message/$messageId', data: data);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/message', queryParameters: query);

  Future<Response<BaseResponse>> remove(String messageId) =>
      delete('v1/message/$messageId');
}
