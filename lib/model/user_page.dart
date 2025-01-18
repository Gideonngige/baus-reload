import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_page.g.dart';

@JsonSerializable()
class UserPage extends Page<User> {
  static UserPage fromJson(dynamic json) => _$UserPageFromJson(json);
}
