import 'package:json_annotation/json_annotation.dart';
import 'package:baustaka/helper/base_object.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends BaseObject {
  String? name;
  int? weeklyPickups;
  double? price;
  double? discount;
  String? status;

  static Product fromJson(dynamic json) => _$ProductFromJson(json);
}
