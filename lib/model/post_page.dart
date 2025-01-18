import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_page.g.dart';

@JsonSerializable()
class PostPage extends Page<Post> {
  static PostPage fromJson(dynamic json) => _$PostPageFromJson(json);

}
