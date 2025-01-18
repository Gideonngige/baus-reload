import 'package:baustaka/model/event.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_page.g.dart';

@JsonSerializable()
class EventPage extends Page<Event> {
  static EventPage fromJson(dynamic json) => _$EventPageFromJson(json);
}
