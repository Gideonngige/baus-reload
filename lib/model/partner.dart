import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable()
class Partner extends BaseObject {
  String? title;
  String? description;
  List<File>? files;
  String? phoneNumber;
  String? email;
  String? status;

  static Partner fromJson(dynamic json) => _$PartnerFromJson(json);

  static Partner fromString(String json) => _$PartnerFromJson(jsonDecode(json));
}
