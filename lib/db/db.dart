import 'package:baustaka/model/settings.dart';
import 'package:baustaka/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Db {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(SettingsAdapter());
  }
}
