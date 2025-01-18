import 'package:json_annotation/json_annotation.dart';
import 'package:baustaka/model/page.dart';
import 'package:baustaka/model/product.dart';

part 'product_page.g.dart';

@JsonSerializable()
class ProductPage extends Page<Product> {
  static ProductPage fromJson(dynamic json) => _$ProductPageFromJson(json);
}
