// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPage _$PostPageFromJson(Map<String, dynamic> json) => PostPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
