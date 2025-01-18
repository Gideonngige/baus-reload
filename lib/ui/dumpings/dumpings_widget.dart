import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/item/dumping_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'dumpings_controller.dart';

class DumpingsWidget extends ResponsiveWidget<DumpingsController> {
  DumpingsWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'dumpings';

  @override
  DumpingsController get controller => Get.put(DumpingsController(), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            color: Colors.black,
          ),
          title: TitleText(
            text: 'Illegal Dumping',
            color: kAppTheme.primaryColor,
            fontSize: 22,
          ),
          actions: [
            TextButton(
              onPressed: () async => await Get.toNamed(Routes.kAddDumping),
              child: Text(
                'Report',
                style: TextStyle(color: kAppTheme.primaryColor),
              ),
            ),
            const Gap(10),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetch(true);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    () => controller.dumpings.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.dumpings.length,
                            itemBuilder: (context, index) => DumpingItemWidget(
                                dumping: controller.dumpings[index]),
                          )
                        : _emptyReportsContainer(screen.context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _emptyReportsContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        Image.asset(
          'assets/images/report_large.png',
          fit: BoxFit.cover,
          width: 200,
        ),
        const Gap(30),
        Text(
          'No new reports yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.grey.withOpacity(.5),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: TextButton(
            onPressed: () async {
              await controller.fetch(true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: kAppTheme.primaryColor),
                const Gap(5),
                Text(
                  'Refresh',
                  style: TextStyle(color: kAppTheme.primaryColor),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
