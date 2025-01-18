// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dumping_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DumpingPage _$DumpingPageFromJson(Map<String, dynamic> json) => DumpingPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Dumping.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
