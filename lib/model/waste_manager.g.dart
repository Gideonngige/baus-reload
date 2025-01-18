// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WasteManager _$WasteManagerFromJson(Map<String, dynamic> json) => WasteManager()
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
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..files = (json['files'] as List<dynamic>?)
      ?.map((e) => File.fromJson(e as Map<String, dynamic>))
      .toList()
  ..area = json['area'] as String?
  ..lngLat = (json['lngLat'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList();
