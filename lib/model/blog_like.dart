import 'dart:convert';

import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog_like.g.dart';

@JsonSerializable()
class BlogLike extends BaseObject {
  User? user;
  Blog? blog;

  static BlogLike fromJson(dynamic json) => _$BlogLikeFromJson(json);

  static BlogLike fromString(String json) =>
      _$BlogLikeFromJson(jsonDecode(json));

}
