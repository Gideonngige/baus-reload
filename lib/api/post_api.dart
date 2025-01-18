import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:dio/dio.dart';

class PostApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/post', data: data.toRequestBody());

  Future<Response<BaseResponse>> price(Map<String, dynamic> data) =>
      post('v1/post/price', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(String postId, dynamic data) =>
      put('v1/post/$postId', data: data);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/post', queryParameters: query);
}
