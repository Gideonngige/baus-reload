import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';

class ProductApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) =>
      post('v1/product', data: data.toRequestBody());

  Future<Response<BaseResponse>> update(String productId, dynamic data) =>
      put('v1/product/$productId', data: data);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/product', queryParameters: query);
}
