import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class TransactionApi extends BaseDio {
  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/transaction', queryParameters: query);

  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/transaction', data: data);
}
