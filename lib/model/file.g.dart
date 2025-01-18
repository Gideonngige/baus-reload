// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

File _$FileFromJson(Map<String, dynamic> json) => File()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..filename = json['filename'] as String?
  ..thumbnail = json['thumbnail'] as String?
  ..type = json['type'] as String?
  ..size = (json['size'] as num?)?.toInt()
  ..dimension = json['dimensions'] == null
      ? null
      : Dimension.fromJson(json['dimensions'] as Map<String, dynamic>)
  ..hash = json['hash'] as String?;
