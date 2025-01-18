import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class BlogApi extends BaseDio {
  Future<Response<BaseResponse>> create(FormData formData) =>
      post('v1/blog', data: formData);

  Future<Response<BaseResponse>> comment(String blogId, FormData formData) =>
      post('v1/blog/$blogId', data: formData);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/blog', queryParameters: query);
}
