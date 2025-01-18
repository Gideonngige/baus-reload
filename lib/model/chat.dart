import 'package:json_annotation/json_annotation.dart';
import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/message.dart';
import 'package:baustaka/model/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat extends BaseObject {
  User? user;
  Message? message;

  String get summary =>
      '${message?.user?.isSelf == true ? 'You' : message?.user?.displayName ?? ''}: ${message?.description}';

  static Chat fromJson(dynamic json) => _$ChatFromJson(json);
}
