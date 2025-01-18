import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'availability.g.dart';

@JsonSerializable()
class Availability {
  DateTime? from;
  DateTime? to;
  String? frequency;

  static Availability fromJson(dynamic json) => _$AvailabilityFromJson(json);

  static Availability fromString(String json) =>
      _$AvailabilityFromJson(jsonDecode(json));

}
