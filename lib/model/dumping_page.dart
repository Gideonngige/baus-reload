import 'package:baustaka/model/dumping.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dumping_page.g.dart';

@JsonSerializable()
class DumpingPage extends Page<Dumping> {
  static DumpingPage fromJson(dynamic json) => _$DumpingPageFromJson(json);

}
