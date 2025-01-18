import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'csr.g.dart';

@JsonSerializable()
class Csr extends BaseObject {
  User? user;
  String? title;
  String? description;
  List<File>? files;

  static Csr fromJson(dynamic json) => _$CsrFromJson(json);
}
