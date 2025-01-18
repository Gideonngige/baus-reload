import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue.g.dart';

@JsonSerializable()
class Issue extends BaseObject {
  String? parent;
  User? user;
  String? message;
  File? file;
  int? responses;
  String? status;

  static Issue fromJson(dynamic json) => _$IssueFromJson(json);

  static Issue fromString(String json) => _$IssueFromJson(jsonDecode(json));
}
