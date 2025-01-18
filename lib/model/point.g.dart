// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Point _$PointFromJson(Map<String, dynamic> json) => Point()
  ..coordinates = (json['coordinates'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList();
