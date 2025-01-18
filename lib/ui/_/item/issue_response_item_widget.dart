import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/issue.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';

class IssueResponseItemWidget extends StatelessWidget {
  final Issue issue;

  const IssueResponseItemWidget({super.key, required this.issue});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  issue.user!.displayName!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  Util.formatDate(issue.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Palette.primary,
                      ),
                ),
              ],
            ),
            issue.file != null
                ? Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: FileWidget(
                          files: issue.file != null ? [issue.file!] : [],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                issue.message!,
              ),
            ),
          ],
        ),
      );
}
