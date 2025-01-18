import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:baustaka/helper/base_object.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends BaseObject {
  String? type;
  List<double>? coordinates;

  double? get latitude => coordinates?.last;

  double? get longitude => coordinates?.first;

  LatLng? get latLng => latitude != null && longitude != null
      ? LatLng(latitude!, longitude!)
      : null;

  static Location fromJson(dynamic json) => _$LocationFromJson(json);
}
