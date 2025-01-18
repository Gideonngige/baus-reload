// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogLike _$BlogLikeFromJson(Map<String, dynamic> json) => BlogLike()
  ..id = json['_id'] as String?
  ..reference = json['reference'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..blog = json['blog'] == null
      ? null
      : Blog.fromJson(json['blog'] as Map<String, dynamic>);
