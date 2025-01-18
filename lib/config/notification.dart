import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const kAndroidNotificationChannel = AndroidNotificationChannel(
  'all_notifications_channel',
  'All notifications',
  importance: Importance.defaultImportance,
);
