import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/point.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dumping.g.dart';

@JsonSerializable()
class Dumping extends BaseObject {
  User? user;
  String? message;
  File? file;
  String? status;
  String? area;
  Point? point;

  static Dumping fromJson(dynamic json) => _$DumpingFromJson(json);

  static Dumping fromString(String json) => _$DumpingFromJson(jsonDecode(json));


}
