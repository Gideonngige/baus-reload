// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardPage _$RewardPageFromJson(Map<String, dynamic> json) => RewardPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Reward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
