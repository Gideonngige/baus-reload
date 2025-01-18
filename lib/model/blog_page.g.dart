// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogPage _$BlogPageFromJson(Map<String, dynamic> json) => BlogPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Blog.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
