// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoPage _$PromoPageFromJson(Map<String, dynamic> json) => PromoPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Promo.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
