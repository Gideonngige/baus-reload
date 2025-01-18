// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dumping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dumping _$DumpingFromJson(Map<String, dynamic> json) => Dumping()
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
  ..message = json['message'] as String?
  ..file = json['file'] == null
      ? null
      : File.fromJson(json['file'] as Map<String, dynamic>)
  ..status = json['status'] as String?
  ..area = json['area'] as String?
  ..point = json['point'] == null
      ? null
      : Point.fromJson(json['point'] as Map<String, dynamic>);
