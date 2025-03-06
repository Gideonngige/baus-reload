import 'dart:io';

import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/user_avatar_widget.dart';
import 'package:baustaka/ui/_/username_widget.dart';
import 'package:baustaka/ui/main/account/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image_picker/image_picker.dart';

class AccountWidget extends GetResponsiveView<AccountController> {
  AccountWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  AccountController get controller => Get.put(
        AccountController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.user.value?.displayName ?? '',
            ),
          ),
          actions: [
            Obx(
              () => Visibility(
                visible: controller.user.value != null,
                child: IconButton(
                  onPressed: () async {
                    await Get.toNamed(
                      Routes.kSettings,
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => await controller.fetch(
            refresh: true,
          ),
          child: Obx(
            () {
              var user = controller.user.value;

              if (user == null) {
                return ListView(
                  children: [
                    EmptyWidget(
                      isEmpty: true,
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
                  ],
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
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
                    const SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            UserAvatarWidget(
                              user: user,
                              size: 96,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kDefaultRadius),
                                ),
                                itemBuilder: (context) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child: const Text('Camera'),
                                    onTap: () async {
                                      try {
                                        var xfile =
                                            (await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                          maxWidth: 720,
                                          maxHeight: 720,
                                        ));

                                        if (xfile != null) {
                                          var croppedFile = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CropPage(
                                                file: File(xfile.path),
                                              ),
                                            ),
                                          );

                                          if (croppedFile != null) {
                                            controller.updateUser(
                                              data: {
                                                'file': croppedFile,
                                              },
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        Util.toast(e);
                                      }
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Gallery'),
                                    onTap: () async {
                                      try {
                                        var xfile =
                                            (await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                          maxWidth: 720,
                                          maxHeight: 720,
                                        ));

                                        if (xfile != null) {
                                          var croppedFile = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CropPage(
                                                file: File(xfile.path),
                                              ),
                                            ),
                                          );

                                          if (croppedFile != null) {
                                            controller.updateUser(
                                              data: {
                                                'file': croppedFile,
                                              },
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        Util.toast(e);
                                      }
                                    },
                                  ),
                                ],
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UsernameWidget(
                            user: user,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          if (user.description != null) ...[
                            Text(
                              user.description ?? '',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                          Text(
                            '${user.privacy?.name.capitalizeFirst ?? ''} · Joined ${Util.formatDate(
                              user.createdAt,
                              showDay: false,
                            )}',
                            style:
                                Theme.of(screen.context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.kProfile,
                              );
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

class CropPage extends StatelessWidget {
  final File file;

  CropPage({required this.file});

  @override
  Widget build(BuildContext context) {
    final _cropController = CropController();

    return FutureBuilder(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit'),
              actions: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    _cropController.crop();
                  },
                ),
              ],
            ),
            body: Crop(
              image: snapshot.data!,
              controller: _cropController,
              onCropped: (croppedData) async {
                final croppedFile = File('${file.path}_cropped.jpg');
                await croppedFile.writeAsBytes(croppedData as List<int>);
                Navigator.pop(context, croppedFile);
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}