import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class SystemApi extends BaseDio {
  Future<Response<BaseResponse>> ping() => get('v1/system');
}
