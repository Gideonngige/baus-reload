import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class IssueApi extends BaseDio {
  Future<Response<BaseResponse>> create(FormData formData) =>
      post('v1/issue', data: formData);

  Future<Response<BaseResponse>> comment(String issueId, FormData formData) =>
      post('v1/issue/$issueId', data: formData);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/issue', queryParameters: query);
}
