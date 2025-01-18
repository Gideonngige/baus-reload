import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keep_alive_widget.dart';
import 'package:baustaka/ui/blogs/blogs_widget.dart';
import 'package:baustaka/ui/events/events_tabs_widget.dart';
import 'package:baustaka/ui/explore/explore_tabs_widget.dart';
import 'package:baustaka/ui/main/home/home_widget.dart';
import 'package:baustaka/ui/main/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainWidget extends GetResponsiveView<MainController> {
  final pages = [
    KeepAliveWidget(
      key: const Key('shop'),
      child: Container(),
    ),
    KeepAliveWidget(
      key: const Key('blogs'),
      child: BlogsWidget(),
    ),
    KeepAliveWidget(
      key: const Key('home'),
      child: HomeWidget(),
    ),
    KeepAliveWidget(
      key: const Key('events'),
      child: EventsTabsWidget(),
    ),
    KeepAliveWidget(
      key: const Key('explore'),
      child: ExploreTabsWidget(),
    ),
  ];

  MainWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  MainController get controller => Get.put(
        MainController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Obx(
        () => PopScope(
          canPop: controller.currentPage.value == 0,
          onPopInvokedWithResult: (didPop, result) async {
            if (controller.currentPage.value == 0) return;

            controller.currentPage.value = 0;
          },
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: pages,
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () => controller.currentPage.value = 2,
              backgroundColor: Palette.primary,
              foregroundColor: Colors.white,
              shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: const Icon(Icons.home),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 0,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TabWidget(
                      onTap: () => controller.currentPage.value = 0,
                      icon: Icons.shop_outlined,
                      selectedIcon: Icons.shop,
                      title: 'Eco Shop',
                      selected: controller.currentPage.value == 0,
                    ),
                    TabWidget(
                      onTap: () => controller.currentPage.value = 1,
                      icon: Icons.list_alt_outlined,
                      selectedIcon: Icons.list_alt,
                      title: 'Blog',
                      selected: controller.currentPage.value == 1,
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                    TabWidget(
                      onTap: () => controller.currentPage.value = 3,
                      icon: Icons.event_outlined,
                      selectedIcon: Icons.event,
                      title: 'Events',
                      selected: controller.currentPage.value == 3,
                    ),
                    TabWidget(
                      onTap: () => controller.currentPage.value = 4,
                      icon: Icons.explore_outlined,
                      selectedIcon: Icons.explore,
                      title: 'Explore',
                      selected: controller.currentPage.value == 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class TabWidget extends StatelessWidget {
  final Function() onTap;
  final String title;
  final IconData icon, selectedIcon;
  final bool selected;

  const TabWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? selectedIcon : icon,
              size: 24,
              color: selected ? Palette.primary : Palette.textPrimary,
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? Palette.primary : Palette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      );
}
