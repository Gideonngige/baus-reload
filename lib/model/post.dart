import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/point.dart';
import 'package:baustaka/model/product.dart';
import 'package:baustaka/model/promo.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends BaseObject {
  User? user;
  Product? product;
  Promo? promo;
  String? type;
  List<String>? categories;
  List<String>? groups;
  String? area;
  Point? point;
  String? mode;
  int? total;
  DateTime? date;
  String? frequency;
  String? description;
  String? phoneNumber;
  double? price;
  double? discount;
  String? payment;
  List<File>? files;
  String? status;
  Station? station;
  Picker? picker;
  String? client;

  static Post fromJson(dynamic json) => _$PostFromJson(json);
}
