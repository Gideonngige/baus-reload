import 'dart:io';
import 'dart:ui';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/db/settings.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/custom_searchbar.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/main/home/home_controller.dart';
import 'package:baustaka/ui/map/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeWidget extends ResponsiveWidget<HomeController> {
  HomeWidget({super.key});

  @override
  String get tag => 'home';

  @override
  HomeController get controller => Get.put(
        HomeController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Obx(
        () {
          var user = controller.user.value;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.vertical_distribute,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                    ),
                    color: Colors.black,
                  );
                },
              ),
              title: Image.asset(
                'assets/images/logo_outline.png',
                width: 80,
                height: AppBar().preferredSize.height,
              ),
              actions: [
                IconButton(
                  onPressed: () async =>
                      await Get.toNamed(Routes.kNotifications),
                  icon: Stack(
                    children: [
                      const Positioned(
                        child: Icon(
                          Icons.notifications_none,
                          size: 29,
                        ),
                      ),
                      if (controller.user.value != null &&
                          (controller.user.value!.notifications ?? 0) > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                        ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  color: Colors.black,
                ),
              ],
            ),
            drawer: Drawer(
              backgroundColor: kAppTheme.primaryColor,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Container(
                    height: 260,
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/top_banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: kAppTheme.primaryColor, width: 3),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/logo_outline.png',
                                    width: 150,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.of(screen.context).pop();
                                    var result = await Get.toNamed(
                                        '${Routes.kProfile}false');

                                    if (result == true) {
                                      await controller.fetch();
                                    }
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 58, 148, 61),
                                          Color.fromARGB(255, 70, 197, 75),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: kAppTheme.primaryColor,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            children: [
                              TitleText(
                                text: user?.displayName ?? 'Name unavailable',
                                color: Colors.black,
                                fontSize: 18,
                              ),

                              // TitleText(
                              //   text: user != null && user.phoneNumber != null && user.phoneNumber!.isNotEmpty
                              //       ? '+254${user.phoneNumber}'
                              //       : 'Number unavailable',
                              //   color: Colors.black,
                              //   fontSize: 15,
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  _drawerListTile(
                      icon: Icons.restore,
                      label: 'Pickups',
                      onTap: () async {
                        Navigator.of(screen.context).pop();
                        await Get.toNamed(Routes.kPosts);
                      }),
                  _drawerListTile(
                    icon: Icons.loyalty,
                    label: 'Subscriptions',
                    onTap: () async {
                      Navigator.of(screen.context).pop();
                      await Get.toNamed(
                        Routes.kPosts,
                        parameters: {'withProduct': 'yes'},
                      );
                    },
                  ),
                  _drawerListTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet',
                    onTap: () async {
                      Navigator.of(screen.context).pop();
                      await Get.toNamed(Routes.kTransactions);
                    },
                  ),
                  _drawerListTile(
                      icon: Icons.shopping_basket_outlined,
                      label: 'My Orders',
                      onTap: () async {
                        Navigator.of(screen.context).pop();
                        await Get.toNamed(Routes.kPromotion);
                      }),
                  _drawerListTile(
                      icon: Icons.restore,
                      label: 'Rewards',
                      onTap: () async {
                        Navigator.of(screen.context).pop();
                        await Get.toNamed(Routes.kRewards);
                      }),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(.2)),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text('Promotions',
                        style: TextStyle(color: Colors.white)),
                    trailing: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Text('0'),
                    ),
                    onTap: () async {
                      Navigator.of(screen.context).pop();
                      await Get.toNamed(Routes.kPromotions);
                    },
                  ),
                  _drawerListTile(
                    icon: Icons.people_outline,
                    label: 'My CBOs',
                    onTap: () async {
                      Navigator.of(screen.context).pop();
                      await Get.toNamed('${Routes.kCbos}?owner=me');
                    },
                  ),
                  _drawerListTile(
                    icon: Icons.emoji_events,
                    label: 'Become an Eco-Champion',
                    onTap: () async {
                      Navigator.of(screen.context).pop();
                      await Get.toNamed(Routes.kAddChamp);
                    },
                  ),
                  _drawerListTileWithTrailingIcon(
                    leadingIcon: Icons.card_giftcard,
                    label: 'Switch to Waste Manager',
                    onTap: () async {
                      Navigator.of(screen.context).pop();
                      try {
                        await SettingsDb.setInitialRoute(Routes.kHomePicker);
                      } catch (e) {
                        Util.toast(e);
                      }

                      await Session.login(splash: true);
                    },
                    trailingIcon: const Icon(Icons.open_in_new_outlined,
                        color: Colors.white),
                  ),
                  _drawerListTile(
                      icon: Icons.g_translate_outlined,
                      label: 'Switch Language',
                      onTap: () {
                        Navigator.of(screen.context).pop();
                      }),
                  _drawerListTile(
                    icon: Icons.share_outlined,
                    label: 'Refer a friend',
                    onTap: () async {
                      try {
                        await Share.share(
                            'Check out $kAppName App. ${Platform.isIOS ? "https://apps.apple.com/app/id1606629139" : "https://play.google.com/store/apps/details?id=$kAppId"} ${'\n'}Use my referral code ${user?.referralCode}');
                      } catch (e) {
                        Util.toast(e);
                      }
                    },
                  ),
                    _drawerListTile(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () async {
                      await Session.logout();
                      }),
                ],
              ),
            ),
            body: SlidingUpPanel(
              color: Colors.white10,
              maxHeight: MediaQuery.of(screen.context).size.height * .6,
              minHeight: MediaQuery.of(screen.context).size.height * .4,
              boxShadow: const [],
              body: Stack(
                children: [
                  Obx(
                    () => MapWidget(
                      markers: controller.pickers
                          .map(
                            (e) => Marker(
                              markerId: MarkerId(e.id!),
                              position: LatLng(
                                e.point!.coordinates![1],
                                e.point!.coordinates![0],
                              ),
                              infoWindow: InfoWindow(
                                title: e.user?.displayName,
                                snippet: '${e.mode?.capitalize} ${e.plate}',
                                onTap: () async =>
                                    await Get.toNamed('${Routes.kPost}${e.id}'),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Column(
                      children: [
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                border: const Border(
                                  bottom: BorderSide(
                                    width: 2.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: CustomSearchBar(
                                      hintText: 'Search',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.aspect_ratio,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              panelBuilder: (sController) => PanelWidget(
                scrollController: sController,
                controller: controller,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          );
        },
      );

  Widget _drawerListTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(.2)),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Widget _drawerListTileWithTrailingIcon({
    required IconData leadingIcon,
    required String label,
    required VoidCallback onTap,
    required Widget trailingIcon,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(.2)),
        child: Icon(
          leadingIcon,
          color: Colors.white,
        ),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: trailingIcon,
      onTap: onTap,
    );
  }
}

class PanelWidget extends StatelessWidget {
  final HomeController controller;
  final ScrollController scrollController;

  const PanelWidget({
    super.key,
    required this.scrollController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          color: Colors.white.withOpacity(.5),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 16,
              ),
              // drag handle bar
              Center(
                child: Container(
                  width: 64,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PanelItem(
                        color: Palette.primary,
                        title: 'Dispose\nWaste',
                        imagePath: 'assets/images/dispose_waste.png',
                        onTap: () async => await Get.toNamed(
                          Routes.kBooking,
                          parameters: {
                            'type': 'disposal',
                            'withProduct': 'no',
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: PanelItem(
                        color: Colors.blue,
                        title: 'Sell\nPlastic',
                        imagePath: 'assets/images/sell_plastic.png',
                        onTap: () async => await Get.toNamed(
                          Routes.kBooking,
                          parameters: {
                            'type': 'sale',
                            'withProduct': 'no',
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: PanelItem(
                        color: Colors.orange,
                        title: 'Donate\nPlastic',
                        imagePath: 'assets/images/donate_plastic.png',
                        onTap: () async => await Get.toNamed(
                          Routes.kBooking,
                          parameters: {
                            'type': 'donation',
                            'withProduct': 'no',
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Item(
                title: 'Upcoming Pickups',
                subtitle:
                    'You have ${controller.postPage.value != null ? controller.postPage.value!.total.toString() : 0} upcoming pickups',
                onTap: () async => await Get.toNamed(Routes.kPosts),
                asset: 'assets/images/upcoming_pickup.png',
                color: Palette.primary,
              ),
              const SizedBox(
                height: 16,
              ),
              Item(
                title: 'Report Illegal Dumping',
                subtitle: 'Keep your environment clean',
                onTap: () async => await Get.toNamed(Routes.kDumpings),
                asset: 'assets/images/report.png',
                color: Colors.red,
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PanelItem extends StatelessWidget {
  final Color color;
  final String title, imagePath;
  final Function() onTap;

  const PanelItem({
    super.key,
    required this.color,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 40.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultRadius * 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          color: color.withOpacity(0.6),
                        ),
                        padding: const EdgeInsets.all(
                          8,
                        ),
                        child: Image.asset(
                          imagePath,
                          width: 72,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      );
}

class Item extends StatelessWidget {
  final String asset, title, subtitle;
  final Function() onTap;
  final Color color;

  const Item({
    super.key,
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultRadius * 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 6,
              spreadRadius: 2.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          leading: Image.asset(
            asset,
            width: 48,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: CircleAvatar(
            backgroundColor: color,
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ),
      );
}
