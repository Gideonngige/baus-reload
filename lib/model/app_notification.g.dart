// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification()
      ..id = json['_id'] as String?
      ..reference = json['reference'] as String?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String)
      ..deleted = json['deleted'] as bool?
      ..avatar = json['avatar'] == null
          ? null
          : File.fromJson(json['avatar'] as Map<String, dynamic>)
      ..user = json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>)
      ..title = json['title'] as String?
      ..body = json['body'] as String?
      ..route = json['route'] as String?
      ..status =
          $enumDecodeNullable(_$AppNotificationStatusEnumMap, json['status'])
      ..type = $enumDecodeNullable(_$AppNotificationTypeEnumMap, json['type']);

const _$AppNotificationStatusEnumMap = {
  AppNotificationStatus.read: 'read',
  AppNotificationStatus.unread: 'unread',
};

const _$AppNotificationTypeEnumMap = {
  AppNotificationType.hidden: 'hidden',
  AppNotificationType.visible: 'visible',
};
