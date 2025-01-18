import 'package:json_annotation/json_annotation.dart';

part 'balance.g.dart';

@JsonSerializable()
class Balance {
  double? available;

  double? held;

  static Balance fromJson(dynamic json) => _$BalanceFromJson(json);

}
