// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event()
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
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..files = (json['files'] as List<dynamic>?)
      ?.map((e) => File.fromJson(e as Map<String, dynamic>))
      .toList()
  ..rsvps = (json['rsvps'] as num?)?.toInt()
  ..tags = (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..partners = (json['partners'] as List<dynamic>?)
      ?.map((e) => Partner.fromJson(e as Map<String, dynamic>))
      .toList()
  ..rsvpd = json['rsvpd'] as bool? ?? false
  ..area = json['area'] as String?
  ..point = json['point'] == null
      ? null
      : Point.fromJson(json['point'] as Map<String, dynamic>);
