import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/cbos/cbos_widget.dart';
import 'package:baustaka/ui/csrs/csrs_widget.dart';
import 'package:baustaka/ui/explore/explore_tabs_controller.dart';
import 'package:baustaka/ui/waste_managers/waste_managers_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreTabsWidget extends ResponsiveWidget<ExploreTabsController> {
  ExploreTabsWidget({super.key});

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => 'explore-tabs';

  @override
  ExploreTabsController get controller => Get.put(
        ExploreTabsController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          text: 'Waste managers',
                        ),
                        Tab(
                          text: 'Community-based organisations',
                        ),
                        Tab(
                          text: 'Corporate social responsibility programs',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    WasteManagersWidget(),
                    CbosWidget(),
                    CsrsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
