import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review extends BaseObject {
  String? sale;
  double? rating;
  String? comment;

  static Review fromJson(dynamic json) => _$ReviewFromJson(json);

  static Review fromString(String json) => _$ReviewFromJson(jsonDecode(json));
}
