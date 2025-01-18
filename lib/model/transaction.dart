import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends BaseObject {
  User? user;
  String? type;
  String? method;
  double? amount;
  double? fees;
  String? currency;
  String? phoneNumber;
  String? status;

  static Transaction fromJson(dynamic json) => _$TransactionFromJson(json);

}
