// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) => Station()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..availabilitys = (json['availabilitys'] as List<dynamic>?)
      ?.map((e) => Availability.fromJson(e as Map<String, dynamic>))
      .toList()
  ..area = json['area'] as String?
  ..point = json['point'] == null
      ? null
      : Point.fromJson(json['point'] as Map<String, dynamic>)
  ..status = json['status'] as String?;
