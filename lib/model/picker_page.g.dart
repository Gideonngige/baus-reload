// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picker_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickerPage _$PickerPageFromJson(Map<String, dynamic> json) => PickerPage()
  ..docs = (json['docs'] as List<dynamic>?)
      ?.map((e) => Picker.fromJson(e as Map<String, dynamic>))
      .toList()
  ..total = (json['total'] as num?)?.toInt()
  ..page = (json['page'] as num?)?.toInt()
  ..pages = (json['pages'] as num?)?.toInt()
  ..limit = (json['limit'] as num?)?.toInt()
  ..sort = json['sort'] as String?;
