// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RsvpPage _$RsvpPageFromJson(Map<String, dynamic> json) => RsvpPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Rsvp.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
