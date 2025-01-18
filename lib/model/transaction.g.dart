// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..type = json['type'] as String?
  ..method = json['method'] as String?
  ..amount = (json['amount'] as num?)?.toDouble()
  ..fees = (json['fees'] as num?)?.toDouble()
  ..currency = json['currency'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..status = json['status'] as String?;
