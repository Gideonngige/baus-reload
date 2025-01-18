// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picker _$PickerFromJson(Map<String, dynamic> json) => Picker()
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
  ..mode = json['mode'] as String?
  ..plate = json['plate'] as String?
  ..area = json['area'] as String?
  ..point = json['point'] == null
      ? null
      : Point.fromJson(json['point'] as Map<String, dynamic>)
  ..status = json['status'] as String?
  ..station = json['station'] == null
      ? null
      : Station.fromJson(json['station'] as Map<String, dynamic>);
