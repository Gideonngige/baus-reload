import 'package:baustaka/config/theme.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/ui/_/image_widget.dart';
import 'package:baustaka/ui/files/web/file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesWidget extends StatelessWidget {
  final List<File> files;

  int get length => files.length;

  final double radius;
  final bool clickable;

  const FilesWidget({
    super.key,
    required this.files,
    this.radius = kDefaultRadius,
    this.clickable = true,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AspectRatio(
          aspectRatio: length == 2 ? 2 / 1 : 1 / 1,
          child: length < 4 ? _rows(context) : _columns(context),
        ),
      );

  _columns(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _column(context, files.sublist(0, 2 < length ? 2 : null)),
          if (length > 2) ...[
            const SizedBox(
              width: 2,
            ),
            _column(context, files.sublist(2, 5 < length ? 5 : null)),
          ],
        ],
      );

  _column(BuildContext context, List<File> filesToUse) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            filesToUse.length,
            (index) => <Widget>[
              if (index > 0)
                const SizedBox(
                  height: 2,
                ),
              _file(context, filesToUse[index]),
            ],
          ).expand((element) => element).toList(),
        ),
      );

  _rows(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row(
            context,
            files.sublist(
              0,
              length <= 2
                  ? null
                  : length == 3
                      ? 1
                      : 2,
            ),
          ),
          if (length > 2) ...[
            const SizedBox(
              height: 2,
            ),
            _row(context, files.sublist(length == 3 ? 1 : 2)),
          ],
        ],
      );

  _row(BuildContext context, List<File> filesToUse) => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            filesToUse.length,
            (index) => <Widget>[
              if (index > 0)
                const SizedBox(
                  width: 2,
                ),
              _file(context, filesToUse[index]),
            ],
          ).expand((element) => element).toList(),
        ),
      );

  _file(
    BuildContext context,
    File file,
  ) {
    final index = files.indexOf(file);

    return Expanded(
      child: GestureDetector(
        onTap: clickable
            ? () async => await Get.to(
                  () => FilePreviewWidget(
                    initialPosition: index,
                    files: files,
                  ),
                )
            : null,
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageWidget(
                file: file,
              ),
            ),
            if (index == 4 && files.length > 5)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: Text(
                      '+${files.length - 5}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
