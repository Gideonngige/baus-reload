import 'package:flutter/material.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:baustaka/ui/_/icon_widget.dart';

class FileItemWidget extends StatelessWidget {
  final File file;
  final String? subtitle;
  final bool showThumbnail;

  const FileItemWidget({
    super.key,
    required this.file,
    this.subtitle,
    this.showThumbnail = true,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showThumbnail) ...[
              ClipRRect(
                child: FileWidget(
                  files: [file],
                  countVisible: false,
                ),
              ),
              const Divider(
                height: 0,
              ),
            ],
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: IconWidget(file.iconData),
                    title: Text(
                      file.bytes,
                    ),
                    subtitle: subtitle != null ? Text(subtitle!) : null,
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    try {
                      await file.share(subtitle: subtitle);
                    } catch (e) {
                      Util.toast(e);
                    }
                  },
                  child: const Text('Share'),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
}
