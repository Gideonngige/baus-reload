// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssuePage _$IssuePageFromJson(Map<String, dynamic> json) => IssuePage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Issue.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
