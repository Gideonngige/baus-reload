import 'dart:io' as io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:baustaka/api/file_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/base_object.dart';
import 'package:baustaka/model/dimension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'file.g.dart';

@JsonSerializable()
class File extends BaseObject {
  String? filename;
  String? thumbnail;
  String? type;
  int? size;
  @JsonKey(name: 'dimensions')
  Dimension? dimension;
  String? hash;

  double get aspectRatio => dimension!.orientation! % 2 == 0
      ? dimension!.height! / dimension!.width!
      : dimension!.width! / dimension!.height!;

  String get urlThumbnail => '${kBaseApiUrl}v1/file/$thumbnail';

  String get url => '${kBaseApiUrl}v1/file/$filename';

  IconData get iconData {
    switch (type) {
      case 'video':
        return Icons.play_circle;
      case 'image':
        return Icons.image;
      default:
        return Icons.file_present;
    }
  }

  String get bytes {
    if (size! <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    var i = (log(size!) / log(1024)).floor();

    return '${(size! / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  Future<io.File> download() async {
    final storage = await getApplicationDocumentsDirectory();

    final file = io.File('${storage.path}/$filename');

    final response = await Get.put(FileApi()).retrieve(filename!);

    await (await (await file.open(
      mode: io.FileMode.write,
    ))
            .writeFrom(response.data))
        .close();

    return file;
  }

  Future<io.File> share({String? subtitle}) async {
    final file = await download();

    await Share.shareXFiles(
      [XFile(file.path)],
      text: subtitle,
    );

    return file;
  }

  static File fromJson(dynamic json) => _$FileFromJson(json);
}
