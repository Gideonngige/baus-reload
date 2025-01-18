import 'dart:convert';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

_parseAndDecode(String response) {
  return BaseResponse.fromJson(jsonDecode(response));
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class BaseDio with DioMixin implements Dio {
  BaseDio() {
    httpClientAdapter = HttpClientAdapter();

    transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;

    interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));

    interceptors
        .add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
      final headers = await Session.headers();

      options.headers.addAll(headers);

      handler.next(options);
    }, onResponse: (response, handler) {
      handler.next(response);
    }, onError: (error, handler) async {
      int? code = error.response?.statusCode;

      String? message;

      if (error.response?.data is BaseResponse) {
        message = (error.response?.data as BaseResponse).error?.message;
      }

      if (code == 401) {
        if (message?.toLowerCase() == 'user not found') {
          await Session.register();
        } else if (message?.toLowerCase() == 'user not verified') {
          await Session.verify();
        } else {
          await Session.logout();
        }

        handler.next(
          DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.cancel,
          ),
        );
      } else {
        handler.next(error);
      }
    }));
  }

  @override
  BaseOptions get options => BaseOptions(
        baseUrl: kBaseApiUrl,
        followRedirects: false,
        connectTimeout: const Duration(
          seconds: 60,
        ),
        sendTimeout: const Duration(
          seconds: 60,
        ),
        receiveTimeout: const Duration(
          seconds: 60,
        ),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      );
}
