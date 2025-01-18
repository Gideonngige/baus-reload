import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/event.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rsvp.g.dart';

@JsonSerializable()
class Rsvp extends BaseObject {
  User? user;
  Event? event;

  static Rsvp fromJson(dynamic json) => _$RsvpFromJson(json);

  static Rsvp fromString(String json) => _$RsvpFromJson(jsonDecode(json));
}
