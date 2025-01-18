import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/location.dart';
import 'package:baustaka/model/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends BaseObject {
  User? user, toUser;
  List<File>? files;
  String? description, locationName;
  Location? location;

  IconData? get iconData =>
      location != null ? Icons.location_on : files?.firstOrNull?.iconData;

  String get fromName =>
      '${user?.displayName ?? ''}${user?.isSelf == true ? ' (You)' : ''}';

  static Message fromJson(dynamic json) => _$MessageFromJson(json);
}
