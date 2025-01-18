import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:dio/dio.dart';

class UserApi extends BaseDio {
  Future<Response<BaseResponse>> updateSelf(Map<String, dynamic> data) =>
      put('v1/user', data: data);

  Future<Response<BaseResponse>> update(
          String userId, Map<String, dynamic> data) =>
      put('v1/user/$userId', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/user', queryParameters: query);

  Future<Response<BaseResponse>> remove(String userId) =>
      delete('v1/user/$userId');
}
