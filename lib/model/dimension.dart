import 'package:json_annotation/json_annotation.dart';

part 'dimension.g.dart';

@JsonSerializable()
class Dimension {
  int? height;
  int? width;
  int? orientation;

  static Dimension fromJson(dynamic json) => _$DimensionFromJson(json);
}
