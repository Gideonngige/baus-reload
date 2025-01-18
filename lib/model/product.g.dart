// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..name = json['name'] as String?
  ..weeklyPickups = (json['weeklyPickups'] as num?)?.toInt()
  ..price = (json['price'] as num?)?.toDouble()
  ..discount = (json['discount'] as num?)?.toDouble()
  ..status = json['status'] as String?;
