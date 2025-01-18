import 'package:dio/dio.dart';
import 'package:baustaka/helper/base_dio.dart';

class FileApi extends BaseDio {
  Future<Response> retrieve(String filename) => get(
        'v1/file/$filename',
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
}
