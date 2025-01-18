import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/rsvp.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rsvp_page.g.dart';

@JsonSerializable()
class RsvpPage extends Page<Rsvp> {
  static RsvpPage fromJson(dynamic json) => _$RsvpPageFromJson(json);
}
