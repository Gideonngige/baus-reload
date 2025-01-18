import 'package:baustaka/config/asset.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/db/settings.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/version/version_widget.dart';
import 'package:baustaka/ui_picker/booking/booking_details_widget.dart';
import 'package:baustaka/ui_picker/booking/booking_payment_widget.dart';
import 'package:baustaka/ui_picker/booking/booking_select_place_type_widget.dart';
import 'package:baustaka/ui_picker/booking/booking_state_widget.dart';
import 'package:baustaka/ui_picker/home/home_controller.dart';
import 'package:baustaka/ui_picker/map/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeWidget extends ResponsiveWidget<HomeWasteManagerController> {
  HomeWidget({super.key});

  @override
  String get tag => 'home';

  @override
  bool get shouldAdjust => true;

  @override
  HomeWasteManagerController get controller => Get.put(
        HomeWasteManagerController(),
        tag: tag,
      );

  @override
  init() {
    controller.fetch();
  }

  @override
  Widget? desktop() => Obx(
        () => PopScope(
          onPopInvokedWithResult: (popped, result) async {
            if (controller.post.value != null &&
                (controller.post.value?.status == 'started' ||
                    controller.post.value?.status == 'collected')) return;

            switch (controller.bookingState.value) {
              case BookingState.kDetails:
                controller.bookingState.value = BookingState.kNotStarted;
                break;
              case BookingState.kPayment:
                controller.bookingState.value = BookingState.kDetails;
                break;
              default:
                return;
            }

            return;
          },
          child: Scaffold(
            key: controller.scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Palette.primary,
                ),
                onPressed: () async =>
                    controller.scaffoldKey.currentState?.openDrawer(),
              ),
              title: controller.bookingState.value == BookingState.kNotStarted
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      height: AppBar().preferredSize.height,
                      child: Image.asset(
                        Assets.imageLogo,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Text(
                      'Pick up waste',
                      style: TextStyle(color: Palette.primary),
                    ),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                Switch(
                  value: controller.isOnline.value,
                  onChanged: (value) async {
                    controller.isOnline.value = value;

                    Util.toast(
                        value ? 'You are now online' : 'You are offline');

                    try {
                      await SettingsDb.setOnline(value);
                    } catch (e) {
                      Util.toast(e);
                    }

                    await controller.startLocationUpdates();
                  },
                ),
                if (controller.bookingState.value != BookingState.kNotStarted)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Palette.primary,
                    ),
                    onPressed: () async => await Get.dialog(
                      DialogWidget(
                        title: 'Cancel Request',
                        content: 'Do you want to cancel request?',
                        onConfirm: () async => await controller.cancel(),
                        confirmText: 'Yes',
                      ),
                    ),
                    color: Colors.white,
                  ),
              ],
            ),
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 64,
                        bottom: 16,
                      ),
                      color: Theme.of(screen.context).primaryColor,
                      child: ListTile(
                        leading: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                          ),
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                          ),
                        ),
                        title: Obx(
                          () => controller.user.value == null
                              ? const Text('')
                              : Text(
                                  controller.user.value?.displayName ??
                                      'No name',
                                  style: Theme.of(screen.context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                        subtitle: Obx(
                          () => controller.user.value == null
                              ? const Text('')
                              : Text(
                                  controller.user.value?.phoneNumber ??
                                      '${controller.user.value?.email}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        onTap: () async {
                          Get.back();

                          await Get.toNamed('${Routes.kProfile}false');
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.history_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Pick ups'),
                      onTap: () async {
                        Get.back();

                        await Get.toNamed(Routes.kPosts);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Notifications'),
                      onTap: () async {
                        Get.back();

                        await Get.toNamed(Routes.kNotifications);
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
                        Icons.switch_account_outlined,
                        color: Colors.black,
                      ),
                      title: const Text('Switch to Client'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () async {
                        try {
                          await SettingsDb.setInitialRoute(Routes.kMain);
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
                          Get.back();

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
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.bookingState.value == BookingState.kNotStarted)
                  Expanded(
                    child: Visibility(
                      visible: true,
                      child: Obx(
                        () => MapWidget(
                          onMapCreated: (googleMapController) {
                            controller.googleMapController =
                                googleMapController;
                          },
                          position: controller.currentPosition.value,
                          markers: controller.postPage.value == null
                              ? []
                              : controller.postPage.value?.docs
                                  ?.map(
                                    (e) => Marker(
                                      markerId: MarkerId(e.id!),
                                      position: LatLng(
                                        e.point!.coordinates![1],
                                        e.point!.coordinates![0],
                                      ),
                                      infoWindow: InfoWindow(
                                        title: e.area,
                                        snippet: 'Pick up on ${Util.formatDate(
                                          e.date,
                                          withTime: true,
                                        )}',
                                        onTap: () async => await Get.toNamed(
                                            '${Routes.kPost}${e.id}'),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                if (controller.bookingState.value == BookingState.kNotStarted)
                  BookingSelectPlaceTypeWidget(),
                if (controller.bookingState.value !=
                    BookingState.kNotStarted) ...[
                  BookingStateWidget(),
                  if (controller.bookingState.value == BookingState.kDetails)
                    Expanded(
                      child: BookingDetailsWidget(),
                    ),
                  if (controller.bookingState.value == BookingState.kPayment)
                    Expanded(
                      child: BookingPaymentWidget(),
                    ),
                ]
              ],
            ),
          ),
        ),
      );
}
