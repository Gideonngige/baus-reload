import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/custom_searchbar.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/events/events_tabs_controller.dart';
import 'package:baustaka/ui/events/events_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsTabsWidget extends ResponsiveWidget<EventsTabsController> {
  EventsTabsWidget({super.key});

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => 'events-tabs';

  @override
  EventsTabsController get controller => Get.put(
        EventsTabsController(),
        tag: tag,
      );

  Future openModalSheet() {
    return showModalBottomSheet(
        context: screen.context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 14),
                // drag handle bar
                Center(
                  child: Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Image.asset('assets/images/reward.png'),
                const TitleText(
                  text: 'Invite your friends',
                  color: Colors.black,
                  fontSize: 24,
                ),
                TitleText(
                  text: 'Get Rewarded',
                  color: kAppTheme.primaryColor,
                  fontSize: 20,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const CustomSearchBar(
            hintText: 'Search Events',
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.whatshot,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: controller.tabController,
                  labelColor: Palette.primary,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      text: 'Clean ups',
                    ),
                    Tab(
                      text: 'Mangroove planting',
                    ),
                    Tab(
                      text: 'Bin donations',
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  EventsWidget(
                    tags: 'beach cleanup',
                  ),
                  EventsWidget(
                    tags: 'mangroove planting',
                  ),
                  EventsWidget(
                    tags: 'bin donation',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
