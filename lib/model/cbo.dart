import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cbo.g.dart';

@JsonSerializable()
class Cbo extends BaseObject {
  User? user;
  String? title;
  String? description;
  List<File>? files;
  String? area;
  List<double>? lngLat;
  String? status;

  static Cbo fromJson(dynamic json) => _$CboFromJson(json);
}
