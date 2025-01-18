// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_like_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogLikePage _$BlogLikePageFromJson(Map<String, dynamic> json) => BlogLikePage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => BlogLike.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
