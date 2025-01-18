import 'package:baustaka/config/key.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/db/type_id.dart';
import 'package:baustaka/model/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsDb {
  static Future<Box<Settings>> settings() async {
    return await Hive.openBox<Settings>(TypeId.kSettings.toString());
  }

  static Future<String> getInitialRoute() async {
    var box = await SettingsDb.settings();

    return box.get(kSettings)?.initialRoute ?? Routes.kMain;
  }

  static Future<void> setInitialRoute(String initialRoute) async {
    var box = await SettingsDb.settings();

    await box.put(kSettings,
        (box.get(kSettings) ?? Settings())..initialRoute = initialRoute);
  }

  static Future<bool> isOnline() async {
    var box = await SettingsDb.settings();

    return box.get(kSettings)?.isOnline ?? false;
  }

  static Future<void> setOnline(bool isOnline) async {
    var box = await SettingsDb.settings();

    await box.put(
        kSettings, (box.get(kSettings) ?? Settings())..isOnline = isOnline);
  }
}
