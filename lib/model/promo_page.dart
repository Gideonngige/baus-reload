import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/promo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promo_page.g.dart';

@JsonSerializable()
class PromoPage extends Page<Promo> {
  static PromoPage fromJson(dynamic json) => _$PromoPageFromJson(json);
}
