// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationPage _$StationPageFromJson(Map<String, dynamic> json) => StationPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Station.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
