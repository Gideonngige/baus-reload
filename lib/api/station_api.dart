import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class StationApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/station', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(
          String stationId, Map<String, dynamic> data) =>
      put('v1/station', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/station', queryParameters: query);
}
