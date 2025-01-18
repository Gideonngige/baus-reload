import 'package:baustaka/config/routes.dart';
import 'package:baustaka/ui/_/custom_drop_down_widget.dart';
import 'package:baustaka/ui/_/item/issue_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'issues_controller.dart';

class IssuesWidget extends ResponsiveWidget<IssuesController> {
  IssuesWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'issues';

  @override
  IssuesController get controller => Get.put(IssuesController(), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
          actions: [
            IconButton(
              onPressed: () async => await Get.toNamed(Routes.kAddIssue),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetch(true);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Obx(
                  () => CustomDropDownWidget(
                    labelText: 'Status',
                    value: controller.status.value,
                    onChanged: (value) async {
                      controller.status.value = value!;
                      controller.fetch(true);
                    },
                    items: const [
                      'All',
                      'Open',
                      'Closed',
                    ],
                  ),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      controller.fetch(false);
                    }
                    return false;
                  },
                  child: Obx(
                    () => controller.issues.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.issues.length,
                            itemBuilder: (context, index) => IssueItemWidget(
                                issue: controller.issues[index]),
                          )
                        : ListView(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(48),
                                  child: controller.isFetching.isTrue
                                      ? const CircularProgressIndicator()
                                      : const Text('No issues reported'),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
