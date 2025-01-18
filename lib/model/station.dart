import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/availability.dart';
import 'package:baustaka/model/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station.g.dart';

@JsonSerializable()
class Station extends BaseObject {
  String? title;
  String? description;
  List<Availability>? availabilitys;
  String? area;
  Point? point;
  String? status;

  static Station fromJson(dynamic json) => _$StationFromJson(json);

  static Station fromString(String json) => _$StationFromJson(jsonDecode(json));
}
