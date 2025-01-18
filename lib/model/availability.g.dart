// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Availability _$AvailabilityFromJson(Map<String, dynamic> json) => Availability()
  ..from = json['from'] == null ? null : DateTime.parse(json['from'] as String)
  ..to = json['to'] == null ? null : DateTime.parse(json['to'] as String)
  ..frequency = json['frequency'] as String?;
