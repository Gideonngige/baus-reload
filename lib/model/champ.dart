import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'champ.g.dart';

@JsonSerializable()
class Champ extends BaseObject {
  User? user;
  String? title;
  String? description;
  List<File>? files;
  String? area;
  List<double>? lngLat;
  String? status;

  static Champ fromJson(dynamic json) => _$ChampFromJson(json);
}
