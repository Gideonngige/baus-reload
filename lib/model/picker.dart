import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/point.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'picker.g.dart';

@JsonSerializable()
class Picker extends BaseObject {
  User? user;
  String? mode;
  String? plate;
  String? area;
  Point? point;
  String? status;
  Station? station;

  static Picker fromJson(dynamic json) => _$PickerFromJson(json);
}
