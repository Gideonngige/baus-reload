import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/version/version_widget.dart';
import 'package:baustaka/ui/main/account/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsWidget extends GetResponsiveView<SettingsController> {
  SettingsWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  SettingsController get controller => Get.put(
        SettingsController(),
        tag: tag,
        permanent: true,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: RefreshIndicator(
          child: Obx(
            () {
              var user = controller.user.value;

              if (user == null) {
                return ListView(
                  children: [
                    EmptyWidget(
                      isEmpty: user == null,
                      emptyText: 'Account not found',
                      isProgressing: controller.isFetching.isTrue,
                      isFailed: user == null && controller.isFailed.isTrue,
                      onPressed: () async => await controller.fetch(),
                      onEmpty: () async => await controller.fetch(),
                      failedText: controller.failedText,
                    ),
                  ],
                );
              } else {
                return ListView(
                  children: [
                    EmptyWidget(
                      isEmpty: controller.isFailed.isTrue ||
                          controller.isFetching.isTrue,
                      isProgressing: controller.isFetching.isTrue,
                      isFailed: controller.isFailed.isTrue,
                      onPressed: () async => await controller.fetch(
                        refresh: true,
                      ),
                      onEmpty: () async => await controller.fetch(
                        refresh: true,
                      ),
                      failedText: controller.failedText,
                    ),
                    ListTile(
                      title: const Text(
                        'Your name',
                      ),
                      subtitle: Text(user.displayName ?? 'Unavailable'),
                      trailing: IconWidget(
                        Icons.edit,
                        onPressed: () async {
                          await Get.toNamed(
                            Routes.kProfile,
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Username',
                      ),
                      subtitle: Text(
                        '@${user.username ?? ''}',
                      ),
                      trailing: IconWidget(
                        Icons.edit,
                        onPressed: () async {
                          await Get.toNamed(
                            Routes.kProfile,
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: ListTile(
                        title: const Text(
                          'About',
                        ),
                        subtitle: Text(user.description ?? 'Unavailable'),
                        trailing: IconWidget(
                          Icons.edit,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.kProfile,
                            );
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Email',
                      ),
                      subtitle: Text(
                        user.email ?? 'Unavailable',
                      ),
                      trailing: IconWidget(
                        Icons.edit,
                        onPressed: () async {
                          await Get.toNamed(
                            Routes.kChangeEmail,
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Phone number',
                      ),
                      subtitle: Text(user.phoneNumber ?? 'Unavailable'),
                      trailing: IconWidget(
                        Icons.edit,
                        onPressed: () async {
                          await Get.toNamed(
                            Routes.kChangePhoneNumber,
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Divider(),
                    ),
                    ListTile(
                      title: const Text(
                        'Password',
                      ),
                      subtitle: const Text('Change your password'),
                      trailing: IconWidget(
                        Icons.edit,
                        onPressed: () async =>
                            await Get.toNamed(Routes.kChangePassword),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Divider(),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Divider(),
                          ),
                          ListTile(
                            title: const Text('Account privacy'),
                            trailing: controller.isUpdating.isTrue
                                ? const ProgressWidget(
                                    color: Palette.primary,
                                  )
                                : null,
                          ),
                          ...UserPrivacy.values.map(
                            (e) => RadioListTile(
                              title: Text(e.name.capitalizeFirst ?? ''),
                              subtitle: Text(e.description),
                              value: e.name,
                              groupValue: user.privacy?.name,
                              onChanged: (value) => controller.updateUser(
                                data: {
                                  'privacy': value,
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Divider(),
                    ),
                    ListTile(
                      title: const Text(
                        'You joined',
                      ),
                      subtitle: Text(Util.formatDate(
                        user.createdAt,
                        showDayText: false,
                        showDay: false,
                        withTime: true,
                      )),
                    ),
                    ListTile(
                      title: const Text(
                        'Log out',
                      ),
                      onTap: () async {
                        await Get.dialog(
                          DialogWidget(
                            title: 'Log out?',
                            content: 'You are about to log out',
                            onConfirm: () async => await Session.logout(),
                            confirmText: 'Log out',
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Delete account',
                        style: TextStyle(
                          color: Palette.primary,
                        ),
                      ),
                      trailing: controller.isDeleting.isTrue
                          ? const ProgressWidget(
                              color: Palette.primary,
                            )
                          : null,
                      onTap: () async {
                        await Get.dialog(
                          DialogWidget(
                            title: 'Delete account?',
                            content:
                                'We are sad to see you leave. \nDelete your account?',
                            onConfirm: () async => await controller.remove(),
                            confirmText: 'Yes, delete',
                          ),
                        );
                      },
                    ),
                    VersionWidget(),
                  ],
                );
              }
            },
          ),
          onRefresh: () async => await controller.fetch(
            refresh: true,
          ),
        ),
      );
}
