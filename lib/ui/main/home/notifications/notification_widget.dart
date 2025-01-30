import 'package:baustaka/config/fonts.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/model/app_notification.dart';
import 'package:baustaka/ui/_/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationWidget extends StatelessWidget {
  final AppNotification notification;

  const NotificationWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: SizedBox.square(
          dimension: 48,
          child: ClipOval(
            child: ImageWidget(
              file: notification.avatar,
              placeholder: Icon(
                notification.status == AppNotificationStatus.unread
                    ? Icons.notifications
                    : Icons.notifications_none,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          notification.title ?? 'Baus Notification',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: notification.status == AppNotificationStatus.unread
                    ? Fonts.kBold
                    : null,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Text(
              notification.body ?? '',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black,
                fontFamily:
                  notification.status == AppNotificationStatus.unread
                    ? Fonts.kBold
                    : null,
                ),
            ),
            Text(
              notification.updatedAt?.ago ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,
                ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: notification.route != null
            ? () async => await Get.toNamed(notification.route ?? '')
            : null,
      );
}
