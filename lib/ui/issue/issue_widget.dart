import 'package:baustaka/config/palette.dart';
import 'package:baustaka/ui/_/item/issue_item_widget.dart';
import 'package:baustaka/ui/_/item/issue_response_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/issue/issue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueWidget extends ResponsiveWidget<IssueController> {
  final String issueId;

  IssueWidget({super.key, required this.issueId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'issue $issueId';

  @override
  IssueController get controller => Get.put(
        IssueController(issueId: issueId),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                controller.fetchResponses(false);
              }
              return false;
            },
            child: Obx(
              () => controller.issue.value == null
                  ? ListView()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.responses.length + 1,
                            itemBuilder: (context, index) => index == 0
                                ? IssueItemWidget(
                                    issue: controller.issue.value!)
                                : IssueResponseItemWidget(
                                    issue: controller.responses[index - 1]),
                          ),
                        ),
                        if (controller.issue.value!.status == 'open')
                          SafeArea(
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 16,
                                top: 12.0,
                                bottom: 12.0,
                                left:
                                    controller.file.value == null ? 6.0 : 12.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  controller.file.value == null
                                      ? IconButton(
                                          iconSize: 20.0,
                                          icon: const Icon(
                                            Icons.add_a_photo_outlined,
                                            color: Colors.black87,
                                          ),
                                          onPressed: () =>
                                              controller.pickImage(),
                                        )
                                      : Stack(
                                          children: [
                                            Container(
                                              width: 60.0,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  controller.file.value!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                gradient: LinearGradient(
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter,
                                                  colors: [
                                                    Colors.black
                                                        .withOpacity(0.16),
                                                    Colors.black
                                                        .withOpacity(0.05),
                                                    Colors.transparent,
                                                  ],
                                                  stops: const [0.0, 0.3, 1.0],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .file.value = null,
                                                  child: CircleAvatar(
                                                    // backgroundColor: Colors.white.withOpacity(0.16),
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.25),
                                                    radius: 10.0,
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      child: TextField(
                                        controller:
                                            controller.textFieldController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          isCollapsed: true,
                                          hintText: 'Add comment',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        onChanged: (value) =>
                                            controller.message.value = value,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  IconButton(
                                    iconSize: 20.0,
                                    icon: controller.isAdding.isTrue
                                        ? const SizedBox(
                                            height: 16.0,
                                            width: 16.0,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                              strokeWidth: 2.0,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.send,
                                            color: Palette.primary,
                                          ),
                                    onPressed: () {
                                      FocusScope.of(screen.context).unfocus();
                                      controller.add();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ),
      );
}
