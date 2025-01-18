import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'picker_page.g.dart';

@JsonSerializable()
class PickerPage extends Page<Picker> {
  static PickerPage fromJson(dynamic json) => _$PickerPageFromJson(json);
}
