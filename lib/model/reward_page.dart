import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/reward.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_page.g.dart';

@JsonSerializable()
class RewardPage extends Page<Reward> {
  static RewardPage fromJson(dynamic json) => _$RewardPageFromJson(json);
}
