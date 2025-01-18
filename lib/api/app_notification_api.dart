import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class AppNotificationApi extends BaseDio {
  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/notification', queryParameters: query);
}
