import 'package:baustaka/model/station.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station_page.g.dart';

@JsonSerializable()
class StationPage extends Page<Station> {
  static StationPage fromJson(dynamic json) => _$StationPageFromJson(json);
}
