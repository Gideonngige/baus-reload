import 'package:baustaka/model/partner.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_page.g.dart';

@JsonSerializable()
class PartnerPage extends Page<Partner> {
  static PartnerPage fromJson(dynamic json) => _$PartnerPageFromJson(json);
}
