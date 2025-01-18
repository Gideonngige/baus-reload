import 'package:baustaka/model/blog.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog_page.g.dart';

@JsonSerializable()
class BlogPage extends Page<Blog> {
  static BlogPage fromJson(dynamic json) => _$BlogPageFromJson(json);

}
