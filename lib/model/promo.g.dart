// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promo _$PromoFromJson(Map<String, dynamic> json) => Promo()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..file = json['file'] == null
      ? null
      : File.fromJson(json['file'] as Map<String, dynamic>)
  ..dateStart = json['dateStart'] == null
      ? null
      : DateTime.parse(json['dateStart'] as String)
  ..dateEnd =
      json['dateEnd'] == null ? null : DateTime.parse(json['dateEnd'] as String)
  ..points = (json['points'] as num?)?.toInt()
  ..discount = (json['discount'] as num?)?.toDouble()
  ..max = (json['max'] as num?)?.toDouble()
  ..status = json['status'] as String?
  ..code = json['code'] as String?;
