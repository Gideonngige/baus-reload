import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class PickerApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/picker', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(String pickerId, dynamic data) =>
      put('v1/picker/$pickerId', data: data);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/picker', queryParameters: query);
}
