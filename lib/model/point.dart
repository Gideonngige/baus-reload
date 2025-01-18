import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'point.g.dart';

@JsonSerializable()
class Point {
  List<double> ? coordinates;

  static Point fromJson(dynamic json) => _$PointFromJson(json);

  static Point fromString(String json) => _$PointFromJson(jsonDecode(json));
}
