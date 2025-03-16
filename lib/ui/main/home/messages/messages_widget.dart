// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/item.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/user_avatar_widget.dart';
import 'package:baustaka/ui/_/username_widget.dart';
import 'package:baustaka/ui/files/local/file_preview_widget.dart';
import 'package:baustaka/ui/main/home/messages/message_widget.dart';
import 'package:baustaka/ui/main/home/messages/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class MessagesWidget extends GetResponsiveView<MessagesController> {
  final String? userId, action;

  MessagesWidget({
    super.key,
    this.userId,
    this.action,
  });

  @override
  String get tag => Util.tag(
        userId: userId,
      );

  @override
  MessagesController get controller => Get.put(
        MessagesController(
          userId: userId,
          action: action,
        ),
        tag: tag,
      );

  _goToPosition() async {
    var newPosition = LatLng(
      (controller.map['lngLat'] as List<double>?)?.last ??
          kInitialLatLng.latitude,
      (controller.map['lngLat'] as List<double>?)?.first ??
          kInitialLatLng.longitude,
    );

    if (controller.updateMap != null) {
      controller.updateMap!(
        newPosition,
        showCircles: true,
        showMarkers: false,
        radius: kDefaultRadius,
        withZoom: kZoomForMarker,
      );
    }
  }

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: Obx(
            () => controller.user.value == null
                ? const Text('Chat')
                : GestureDetector(
                    onTap: () async => {},
                    child: Row(
                      children: [
                        UserAvatarWidget(
                          user: controller.user.value,
                          size: 36,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: UsernameWidget(user: controller.user.value),
                        ),
                      ],
                    ),
                  ),
          ),
          actions: const [],
        ),
        body: Column(
          children: [
            Obx(
              () => EmptyWidget(
                isEmpty: controller.messages.isEmpty ||
                    controller.isRefreshing.isTrue,
                isProgressing: controller.isFetching.isTrue,
                isFailed: controller.isFailed.isTrue,
                onPressed: () => controller.fetch(
                  refresh: true,
                ),
                onEmpty: () => controller.fetch(
                  refresh: true,
                ),
                emptyText: 'No messages',
                failedText: controller.failedText,
              ),
            ),
            Expanded(
              child: Obx(
                () => NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent) {
                      controller.fetch();
                    } else if (scrollInfo.metrics.pixels <=
                        scrollInfo.metrics.minScrollExtent) {
                      controller.fetch(
                        refresh: true,
                      );
                    }

                    return false;
                  },
                  child: ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 48,
                    ),
                    itemBuilder: (context, index) => Column(
                      children: [
                        Obx(
                          () => Visibility(
                            visible: controller.isFetching.isTrue &&
                                controller.messages.isNotEmpty &&
                                index == controller.messages.length - 1 &&
                                controller.isRefreshing.isFalse,
                            child: Container(
                              margin: const EdgeInsets.all(32),
                              child: const ProgressWidget(
                                color: Palette.primary,
                              ),
                            ),
                          ),
                        ),
                        MessageWidget(
                          message: controller.messages[index],
                          showDate: index + 1 >= controller.messages.length
                              ? true
                              : !isSameDay(
                                  controller.messages[index].createdAt
                                      ?.toLocal(),
                                  controller.messages[index + 1].createdAt
                                      ?.toLocal()),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.transparent,
                    ),
                    itemCount: controller.messages.length,
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.user.value != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => Visibility(
                              visible: (controller.map['files'] as List<File>)
                                  .isNotEmpty,
                              child: SizedBox(
                                height: 96,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount:
                                      (controller.map['files'] as List).length,
                                  itemBuilder: (context, index) {
                                    var element = (controller.map['files']
                                        as List<File>)[index];

                                    return GestureDetector(
                                      onTap: () async => await Get.to(
                                        () => FilePreviewWidget(
                                          key: Key(tag),
                                          files: (controller.map['files']
                                              as List<File>),
                                          initialPosition: index,
                                          onUpdate: (updatedFiles) =>
                                              controller.map.update(
                                            'files',
                                            (value) => updatedFiles,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                kDefaultRadius),
                                            child: Image.file(
                                              element,
                                              fit: BoxFit.cover,
                                              height: 96,
                                              width: 96,
                                            ),
                                          ),
                                          const Positioned(
                                            top: 8,
                                            right: 8,
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.black45,
                                              child: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: (controller.map['files'] as List<File>)
                                  .isNotEmpty,
                              child: const SizedBox(
                                height: 16,
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.map['lngLat'] != null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: MapWidget(
                                  onMapCreated: (updateMap) async {
                                    controller.updateMap = updateMap;

                                    _goToPosition();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.map['lngLat'] != null,
                              child: const SizedBox(
                                height: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kDefaultRadius),
                                  ),
                                  itemBuilder: (context) => <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: const ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Camera'),
                                      ),
                                      onTap: () async {
                                        try {
                                          var file =
                                              await ImagePicker().pickImage(
                                            source: ImageSource.camera,
                                            maxWidth: 720,
                                            maxHeight: 720,
                                          );

                                          if (file != null) {
                                            controller.map.update(
                                              'files',
                                              (value) {
                                                var files = value as List<File>;

                                                files.add(
                                                  File(file.path),
                                                );

                                                controller.map.update(
                                                  'lngLat',
                                                  (_) => null,
                                                );

                                                return files;
                                              },
                                            );
                                          }
                                        } catch (e) {
                                          Util.toast(e);
                                        }
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Photos'),
                                      ),
                                      onTap: () async {
                                        try {
                                          var files = controller.map['files']
                                              as List<File>;

                                          var xfiles = await ImagePicker()
                                              .pickMultiImage(
                                            maxWidth: 720,
                                            maxHeight: 720,
                                            limit: kMaxPhotos - files.length,
                                          );

                                          controller.map.update(
                                            'files',
                                            (value) {
                                              var files = value as List<File>;

                                              for (var element in xfiles) {
                                                files.add(
                                                  File(element.path),
                                                );
                                              }

                                              files = files.sublist(
                                                  0,
                                                  min(kMaxPhotos,
                                                      files.length));

                                              controller.map.update(
                                                'lngLat',
                                                (_) => null,
                                              );

                                              return files;
                                            },
                                          );
                                        } catch (e) {
                                          Util.toast(e);
                                        }
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const ListTile(
                                        leading: Icon(Icons.location_on),
                                        title: Text('Location'),
                                      ),
                                      onTap: () async {
                                        try {
                                          Future.delayed(
                                            const Duration(
                                              milliseconds: 100,
                                            ),
                                            () async {
                                              var googlePlace = GooglePlace(kGoogleApiKey);
                                              var result = await googlePlace.autocomplete.get(
                                                '',
                                                components: [Component('country', 'ke')],
                                              );

                                              if (result != null && result.predictions!.isNotEmpty) {
                                                var prediction = result.predictions!.first;
                                                var details = await googlePlace.details.get(prediction.placeId!);

                                                if (details != null && details.result != null) {
                                                  controller.map.update(
                                                      'lngLat', (value) {
                                                    controller.map.update(
                                                        'files', (files) {
                                                      (files as List).clear();

                                                      return files;
                                                    });
                                                    return [
                                                      details.result!.geometry!.location!.lng,
                                                      details.result!.geometry!.location!.lat
                                                    ];
                                                  });

                                                  _goToPosition();
                                                }
                                              }
                                            },
                                          );
                                        } catch (e) {
                                          Util.toast(e);
                                        }
                                      },
                                    ),
                                  ],
                                  child: const IconWidget(
                                    Icons.add,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: kInputDecoration.copyWith(
                                      hintText: controller.hint ??
                                          'Type a message...',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) =>
                                        controller.map['description'] = value,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    maxLines: null,
                                    controller:
                                        controller.textEditingController,
                                    textAlignVertical: TextAlignVertical.center,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                IconWidget(
                                  Icons.send,
                                  onPressed: () async {
                                    await controller.add();
                                  },
                                  child: Obx(
                                    () => controller.isAdding.isTrue
                                        ? const ProgressWidget()
                                        : const Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}