import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class EventApi extends BaseDio {
  Future<Response<BaseResponse>> create(FormData formData) =>
      post('v1/event', data: formData);

  Future<Response<BaseResponse>> comment(String eventId, FormData formData) =>
      post('v1/event/$eventId', data: formData);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/event', queryParameters: query);
}
