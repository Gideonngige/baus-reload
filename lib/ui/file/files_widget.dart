import 'package:baustaka/config/theme.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/ui/_/image_widget.dart';
import 'package:baustaka/ui/file/file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesWidget extends StatelessWidget {
  final List<File> files;

  int get length => files.length;

  final double radius;

  const FilesWidget({
    super.key,
    required this.files,
    this.radius = kDefaultRadius,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AspectRatio(
          aspectRatio: length == 2 ? 2 / 1 : 1 / 1,
          child: length < 4 ? _rows() : _columns(),
        ),
      );

  _columns() => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _column(files.sublist(0, 2 < length ? 2 : null)),
          if (length > 2) ...[
            const SizedBox(
              width: 2,
            ),
            _column(files.sublist(2)),
          ],
        ],
      );

  _column(List<File> filesToUse) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            filesToUse.length,
            (index) => <Widget>[
              if (index > 0)
                const SizedBox(
                  height: 2,
                ),
              _file(filesToUse[index]),
            ],
          ).expand((element) => element).toList(),
        ),
      );

  _rows() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (length > 2) ...[
            _row(files.sublist(2)),
            const SizedBox(
              height: 2,
            ),
          ],
          _row(files.sublist(0, 2 < length ? 2 : null)),
        ],
      );

  _row(List<File> filesToUse) => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            filesToUse.length,
            (index) => <Widget>[
              if (index > 0)
                const SizedBox(
                  width: 2,
                ),
              _file(filesToUse[index]),
            ],
          ).expand((element) => element).toList(),
        ),
      );

  _file(File file) => Expanded(
        child: GestureDetector(
          onTap: () async => await Get.to(
            () => FilePreviewWidget(
              file: file,
            ),
          ),
          child: ImageWidget(
            file: file,
          ),
        ),
      );
}
