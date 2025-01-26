import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:dio/dio.dart';

class AuthApi extends BaseDio {
  Future<Response<BaseResponse>> auth({Map<String, dynamic>? query}) => get(
        'v1/auth',
        queryParameters: query,
      );

  Future<Response<BaseResponse>> register(Map<String, dynamic> data) =>
      post('v1/auth/firebase', data: data.toRequestBody());
}
