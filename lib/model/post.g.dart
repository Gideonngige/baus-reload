// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post()
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
  ..product = json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>)
  ..promo = json['promo'] == null
      ? null
      : Promo.fromJson(json['promo'] as Map<String, dynamic>)
  ..type = json['type'] as String?
  ..categories =
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..groups =
      (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..area = json['area'] as String?
  ..point = json['point'] == null
      ? null
      : Point.fromJson(json['point'] as Map<String, dynamic>)
  ..mode = json['mode'] as String?
  ..total = (json['total'] as num?)?.toInt()
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..frequency = json['frequency'] as String?
  ..description = json['description'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..discount = (json['discount'] as num?)?.toDouble()
  ..payment = json['payment'] as String?
  ..files = (json['files'] as List<dynamic>?)
      ?.map((e) => File.fromJson(e as Map<String, dynamic>))
      .toList()
  ..status = json['status'] as String?
  ..station = json['station'] == null
      ? null
      : Station.fromJson(json['station'] as Map<String, dynamic>)
  ..picker = json['picker'] == null
      ? null
      : Picker.fromJson(json['picker'] as Map<String, dynamic>)
  ..client = json['client'] as String?;
