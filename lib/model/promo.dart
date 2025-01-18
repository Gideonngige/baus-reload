import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promo.g.dart';

@JsonSerializable()
class Promo extends BaseObject {
  File? file;
  DateTime? dateStart;
  DateTime? dateEnd;
  int? points;
  double? discount;
  double? max;
  String? status;
  String? code;

  static Promo fromJson(dynamic json) => _$PromoFromJson(json);

  static Promo fromString(String json) => _$PromoFromJson(jsonDecode(json));
}
