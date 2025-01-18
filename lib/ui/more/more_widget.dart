import 'dart:io';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/db/settings.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/version/version_widget.dart';
import 'package:baustaka/ui/more/more_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class MoreWidget extends ResponsiveWidget<MoreController> {
  MoreWidget({super.key});

  @override
  String get tag => 'more';

  @override
  MoreController get controller => Get.put(MoreController(), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          elevation: 0,
        ),
        body: RefreshIndicator(
          child: Obx(
            () {
              var user = controller.user.value;

              if (user == null) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    EmptyWidget(
                      isEmpty: user == null,
                      emptyText: 'Account not found',
                      isProgressing: controller.isFetching.value,
                      isFailed: user == null && controller.isIndicating.isFalse,
                      onPressed: () async => await controller.fetch(),
                      onEmpty: () async => await controller.fetch(),
                    ),
                  ],
                );
              } else {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                        ),
                        color: Palette.primary,
                        child: ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.white,
                            ),
                            child: const SizedBox(
                              width: 48,
                              height: 48,
                            ),
                          ),
                          title: Text(
                            user.displayName ?? 'Name unavailable',
                            style: Theme.of(screen.context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            user.phoneNumber ??
                                user.email ??
                                'Phone number unavailable',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () async {
                            var result =
                                await Get.toNamed('${Routes.kProfile}false');

                            if (result == true) await controller.fetch();
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: Palette.primary,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: const SizedBox(
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.history_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Pickups'),
                      onTap: () async {
                        await Get.toNamed(Routes.kPosts);
                      },
                    ),
                    ListTile(
                      onTap: () async => await Get.toNamed(
                        Routes.kPosts,
                        parameters: {'withProduct': 'yes'},
                      ),
                      title: const Text(
                        'Subscriptions',
                      ),
                      leading: const Icon(
                        Icons.subscriptions_outlined,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.credit_card,
                        color: Colors.black,
                      ),
                      title: const Text('Wallet'),
                      onTap: () async {
                        await Get.toNamed(Routes.kTransactions);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.stars_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Rewards'),
                      onTap: () async {
                        await Get.toNamed(Routes.kRewards);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black,
                      ),
                      title: const Text('My CBOs'),
                      onTap: () async {
                        await Get.toNamed('${Routes.kCbos}?owner=me');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.card_giftcard_sharp,
                        color: Colors.black,
                      ),
                      title: const Text('Promotions'),
                      onTap: () async {
                        await Get.toNamed(Routes.kPromotions);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.help_center_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Support'),
                      onTap: () async {
                        await Get.toNamed(Routes.kIssues);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.emoji_events_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Become an eco-champion'),
                      onTap: () async {
                        await Get.toNamed(Routes.kAddChamp);
                      },
                    ),
                    const Divider(),
                    Builder(builder: (context) {
                      return ListTile(
                        onTap: () async {
                          try {
                            await Share.share(
                                'Check out $kAppName App. ${Platform.isIOS ? "https://apps.apple.com/app/id1606629139" : "https://play.google.com/store/apps/details?id=$kAppId"} ${'\n'}Use my referral code ${user.referralCode}');
                          } catch (e) {
                            Util.toast(e);
                          }
                        },
                        leading: const Icon(
                          Icons.share_outlined,
                          color: Colors.black,
                        ),
                        title: const Text(
                          'Refer a friend',
                        ),
                      );
                    }),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.switch_account_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Switch to Waste Manager'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () async {
                        try {
                          await SettingsDb.setInitialRoute(Routes.kHomePicker);
                        } catch (e) {
                          Util.toast(e);
                        }

                        await Session.login(splash: true);
                      },
                      tileColor: Colors.grey.shade100,
                    ),
                    const Divider(),
                    ListTile(
                        title: const Text('Log out'),
                        onTap: () async {
                          await Get.dialog(
                            DialogWidget(
                              title: 'Log out?',
                              content:
                                  'You are about to log out. Please confirm.',
                              onConfirm: () async => await Session.logout(),
                              confirmText: 'Log out',
                            ),
                          );
                        }),
                    VersionWidget(),
                  ],
                );
              }
            },
          ),
          onRefresh: () async => await controller.fetch(
            indicator: true,
          ),
        ),
      );
}
