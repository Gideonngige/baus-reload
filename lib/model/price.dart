import 'package:json_annotation/json_annotation.dart';

part 'price.g.dart';

@JsonSerializable()
class Price {
  String ? mode;
  double  ?cost;

  static Price fromJson(dynamic json) => _$PriceFromJson(json);

}
