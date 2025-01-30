import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class AppNotificationApi extends BaseDio {
  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) async {
    // rawResponse is already typed
    final rawResponse = await get('v1/notification', queryParameters: query);

    // If rawResponse.data is a BaseResponse, just cast data:
    final baseResp = rawResponse.data as BaseResponse;

    return Response<BaseResponse>(
      data: baseResp,
      statusCode: rawResponse.statusCode,
      statusMessage: rawResponse.statusMessage,
      requestOptions: rawResponse.requestOptions,
      isRedirect: rawResponse.isRedirect,
      redirects: rawResponse.redirects,
      extra: rawResponse.extra,
      headers: rawResponse.headers,
    );
  }
}
