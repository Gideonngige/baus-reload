import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class WasteManagerApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/waste-manager', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(
          String wasteManagerId, Map<String, dynamic> data) =>
      put('v1/waste-manager/$wasteManagerId', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/waste-manager', queryParameters: query);

  Future<Response<BaseResponse>> remove(String wasteManagerId) =>
      delete('v1/waste-manager/$wasteManagerId');
}
