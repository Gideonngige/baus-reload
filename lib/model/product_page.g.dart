// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPage _$ProductPageFromJson(Map<String, dynamic> json) => ProductPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
