import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/issue.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueItemWidget extends StatelessWidget {
  final Issue issue;

  const IssueItemWidget({super.key, required this.issue});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async => await Get.toNamed('${Routes.kIssue}${issue.id}'),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (issue.file != null)
                      Container(
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.only(right: 16),
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.grey.shade200,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: FileWidget(
                            files: issue.file != null ? [issue.file!] : [],
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            issue.message!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${Util.formatDate(issue.createdAt)} · ${issue.status!.capitalize}',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
