import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward extends BaseObject {
  User? user;
  String? type;
  int? points;

  static Reward fromJson(dynamic json) => _$RewardFromJson(json);
}
