// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issue _$IssueFromJson(Map<String, dynamic> json) => Issue()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..parent = json['parent'] as String?
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..message = json['message'] as String?
  ..file = json['file'] == null
      ? null
      : File.fromJson(json['file'] as Map<String, dynamic>)
  ..responses = (json['responses'] as num?)?.toInt()
  ..status = json['status'] as String?;
