import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class CsrApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/csr', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(
          String csrId, Map<String, dynamic> data) =>
      put('v1/csr/$csrId', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/csr', queryParameters: query);

  Future<Response<BaseResponse>> remove(String csrId) =>
      delete('v1/csr/$csrId');
}
