import 'package:baustaka/db/type_id.dart';
import 'package:baustaka/helper/base_object.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: TypeId.kSettings)
class Settings {
  @HiveField(BaseObject.kBaseHiveIndex)
  String? initialRoute;

  @HiveField(BaseObject.kBaseHiveIndex + 1)
  bool? isOnline = false;
}
