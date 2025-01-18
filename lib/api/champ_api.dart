import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class ChampApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/champ', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(
          String champId, Map<String, dynamic> data) =>
      put('v1/champ/$champId', data: data.toRequestBody());

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/champ', queryParameters: query);

  Future<Response<BaseResponse>> remove(String champId) =>
      delete('v1/champ/$champId');
}
