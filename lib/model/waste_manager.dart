import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'waste_manager.g.dart';

@JsonSerializable()
class WasteManager extends BaseObject {
  User? user;
  String? title;
  String? description;
  String? phoneNumber;
  List<File>? files;
  String? area;
  List<double>? lngLat;

  static WasteManager fromJson(dynamic json) => _$WasteManagerFromJson(json);
}
