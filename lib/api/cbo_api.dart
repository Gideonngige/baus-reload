import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class CboApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/cbo', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(
          String cboId, Map<String, dynamic> data) =>
      put('v1/cbo/$cboId', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/cbo', queryParameters: query);

  Future<Response<BaseResponse>> remove(String cboId) =>
      delete('v1/cbo/$cboId');
}
