import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class BlogReportApi extends BaseDio {
  Future<Response<BaseResponse>> report(
          String blogId, Map<String, dynamic> data) =>
      post('v1/blog/report/$blogId', data: data);
}
