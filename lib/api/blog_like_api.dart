import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class BlogLikeApi extends BaseDio {
  Future<Response<BaseResponse>> toggle(Map<String, dynamic> data) =>
      post('v1/blog/like', data: data);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/blog/like', queryParameters: query);
}
