import 'package:json_annotation/json_annotation.dart';

abstract class BaseObject {
  static const kBaseHiveIndex = 3;

  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'reference')
  String? reference;

  DateTime? createdAt;

  DateTime? updatedAt;

  bool? deleted;

  bool get hide => deleted == true;

  @override
  String toString() {
    return id ?? super.toString();
  }
}
