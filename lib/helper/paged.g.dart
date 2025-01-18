// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paged<T> _$PagedFromJson<T>(Map<String, dynamic> json) => Paged<T>(
      Paged._listFromJson(json['docs'] as List),
      (json['total'] as num).toInt(),
      (json['page'] as num).toInt(),
      (json['pages'] as num).toInt(),
      (json['limit'] as num).toInt(),
      json['sort'] as String,
    );
