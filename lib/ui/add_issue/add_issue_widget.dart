import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_issue_controller.dart';

class AddIssueWidget extends ResponsiveWidget<AddIssueController> {
  final String? issueId;

  AddIssueWidget({super.key, required this.issueId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'issue $issueId';

  @override
  AddIssueController get controller => Get.put(
        AddIssueController(issueId: issueId),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: Text(controller.issueId == null
              ? 'Report a problem'
              : 'Add a response'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add_a_photo_outlined,
              ),
              onPressed: () async => controller.pickImage(),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Obx(
                    () => controller.file.value != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: Theme.of(screen.context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () => controller.pickImage(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  controller.file.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              border: InputBorder.none,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 4,
                            maxLines: 8,
                            onChanged: (value) =>
                                controller.message.value = value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Container(
                margin: const EdgeInsets.only(
                    right: 16, left: 16, top: 16, bottom: 24),
                child: ElevatedButton(
                  onPressed: () async {
                    controller.add();
                  },
                  child: controller.isAdding.isTrue
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text(controller.issueId == null ? 'Report' : 'Respond'),
                ),
              ),
            ),
          ],
        ),
      );
}
