// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rsvp _$RsvpFromJson(Map<String, dynamic> json) => Rsvp()
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
  ..event = json['event'] == null
      ? null
      : Event.fromJson(json['event'] as Map<String, dynamic>);
