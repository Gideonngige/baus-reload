import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:dio/dio.dart';

class DumpingApi extends BaseDio {
  Future<Response<BaseResponse>> create(FormData data) =>
      post('v1/dumping', data: data);

  Future<Response<BaseResponse>> update(
          String dumpingId, Map<String, dynamic> data) =>
      put('v1/dumping/$dumpingId', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/dumping', queryParameters: query);

  Future<Response<BaseResponse>> remove(String dumpingId) =>
      delete('v1/dumping/$dumpingId');
}
