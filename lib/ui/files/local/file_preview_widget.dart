import 'dart:io';

import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/files/local/file_preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_view/photo_view.dart';

class FilePreviewWidget extends GetResponsiveView<FilePreviewController> {
  final List<File> files;
  final int initialPosition;
  final Function(List<File> updatedFiles) onUpdate;

  FilePreviewWidget({
    super.key,
    required this.files,
    required this.initialPosition,
    required this.onUpdate,
  });

  @override
  String? get tag => Util.tag(
        key: key,
      );

  @override
  FilePreviewController get controller => Get.put(
        FilePreviewController(
          files: RxList.from(
            files,
            growable: true,
          ),
          initialPosition: initialPosition,
        ),
        tag: tag,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            Obx(
              () => Visibility(
                visible: controller.files.isNotEmpty,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      var index = controller.page.value;

                      controller.files.removeAt(index);

                      if (controller.page.value >= controller.files.length) {
                        controller.page.value = controller.files.length - 1;
                      }

                      onUpdate(controller.files.toList());

                      if (controller.files.isEmpty) Get.back();
                    } catch (e) {
                      Util.toast(e);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Obx(
              () => Visibility(
                visible: controller.files.isNotEmpty,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      var index = controller.page.value;

                      var croppedFile = await ImageCropper().cropImage(
                        sourcePath: controller.files[index].path,
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Edit',
                            toolbarColor: Colors.black,
                            toolbarWidgetColor: Colors.white,
                            statusBarColor: Colors.black,
                            activeControlsWidgetColor: Palette.primary,
                            backgroundColor: Colors.black,
                          ),
                        ],
                      );

                      if (croppedFile != null) {
                        controller.files[index] = File(croppedFile.path);

                        controller.files.refresh();

                        onUpdate(controller.files.toList());
                      }
                    } catch (e) {
                      Util.toast(e);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                    ),
                    child: const Icon(
                      Icons.crop,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: Obx(
          () => controller.files.isEmpty
              ? Container()
              : PageView(
                  controller: PageController(
                    initialPage: controller.page.value < controller.files.length
                        ? controller.page.value
                        : 0,
                  ),
                  onPageChanged: (value) => controller.page.value = value,
                  children: List.generate(
                    controller.files.length,
                    (index) {
                      var file = controller.files[index];

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: PhotoView.customChild(
                              child: Center(
                                child: Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          if ((controller.files.length) > 1)
                            Positioned(
                              top: 124,
                              right: 16,
                              child: CircleAvatar(
                                backgroundColor: Colors.black38,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: FittedBox(
                                    child: Text(
                                      '${index + 1} / ${controller.files.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
        ),
      );
}
