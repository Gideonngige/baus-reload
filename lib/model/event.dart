import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/partner.dart';
import 'package:baustaka/model/point.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends BaseObject {
  User? user;
  String? title;
  String? description;
  DateTime? date;
  List<File>? files;
  int? rsvps;
  List<String>? tags;
  List<Partner>? partners;

  @JsonKey(defaultValue: false)
  bool? rsvpd;

  String? area;
  Point? point;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  bool self = false;

  static Event fromJson(dynamic json) => _$EventFromJson(json);

  static Event fromString(String json) => _$EventFromJson(jsonDecode(json));
}
