import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_notification.g.dart';

@JsonSerializable()
class AppNotification extends BaseObject {
  File? avatar;
  User? user;
  String? title;
  @JsonKey(name: 'message')
  String? body;
  String? route;
  AppNotificationStatus? status;
  AppNotificationType? type;

  static AppNotification fromJson(dynamic json) =>
      _$AppNotificationFromJson(json);
}

enum AppNotificationStatus {
  @JsonValue('read')
  read,
  @JsonValue('unread')
  unread,
  @JsonValue('pending')
  pending,
}

enum AppNotificationType {
  @JsonValue('hidden')
  hidden,
  @JsonValue('visible')
  visible,
  @JsonValue('transaction')
  transaction,
  @JsonValue('post')
  post,
}
