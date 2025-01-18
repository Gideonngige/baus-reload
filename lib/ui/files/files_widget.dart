import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/ui/_/item/file_item_widget.dart';
import 'package:baustaka/ui/files/files_controller.dart';

class FilesWidget extends GetResponsiveView<FilesController> {
  final List<File> files;

  FilesWidget({
    super.key,
    required this.files,
  });

  @override
  String get tag => Util.tag();

  @override
  FilesController get controller => Get.put(
        FilesController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Files'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            File file = files[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (index == 0)
                  Divider(
                    thickness: 8,
                    color: Colors.grey.shade100,
                    height: 8,
                  ),
                FileItemWidget(
                  file: file,
                ),
                Divider(
                  thickness: 8,
                  color: Colors.grey.shade100,
                  height: 8,
                ),
              ],
            );
          },
          itemCount: files.length,
        ),
      );
}
