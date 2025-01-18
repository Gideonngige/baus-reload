import 'package:baustaka/helper/base_dio.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';

class PromoApi extends BaseDio {
  Future<Response<BaseResponse>> create(FormData formData) =>
      post('v1/promo', data: formData);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) =>
      get('v1/promo', queryParameters: query);

  Future<Response<BaseResponse>> update(
          String promoId, Map<String, dynamic> data) =>
      put('v1/promo/$promoId', data: data);
}
