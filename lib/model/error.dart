import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class Error {
  String? message;

  static Error fromJson(dynamic json) => _$ErrorFromJson(json);

}
