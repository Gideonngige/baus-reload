import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog.g.dart';

@JsonSerializable()
class Blog extends BaseObject {
  User? user;
  String? title;
  String? description;
  List<File>? files;
  int? blogs;
  int? blogLikes;
  List<String>? tags;

  @JsonKey(defaultValue: false)
  bool? blogLiked;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  bool self = false;

  static Blog fromJson(dynamic json) => _$BlogFromJson(json);

  static Blog fromString(String json) => _$BlogFromJson(jsonDecode(json));
}
