import 'package:baustaka/model/blog_like.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog_like_page.g.dart';

@JsonSerializable()
class BlogLikePage extends Page<BlogLike> {
  static BlogLikePage fromJson(dynamic json) => _$BlogLikePageFromJson(json);

}
