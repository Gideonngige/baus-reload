// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionPage _$TransactionPageFromJson(Map<String, dynamic> json) =>
    TransactionPage()
      ..docs = (json['docs'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList()
      ..total = (json['total'] as num?)?.toInt()
      ..page = (json['page'] as num?)?.toInt()
      ..pages = (json['pages'] as num?)?.toInt()
      ..limit = (json['limit'] as num?)?.toInt()
      ..sort = json['sort'] as String?;
