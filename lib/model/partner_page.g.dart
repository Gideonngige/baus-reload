// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerPage _$PartnerPageFromJson(Map<String, dynamic> json) => PartnerPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Partner.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
