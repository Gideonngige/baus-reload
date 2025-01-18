import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_page.g.dart';

@JsonSerializable()
class TransactionPage extends Page<Transaction> {
  static TransactionPage fromJson(dynamic json) =>
      _$TransactionPageFromJson(json);

}
