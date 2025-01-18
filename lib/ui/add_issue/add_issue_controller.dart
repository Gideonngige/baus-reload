import 'dart:io';

import 'package:baustaka/api/issue_api.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

class AddIssueController extends GetxController {
  var isAdding = false.obs;

  final _issueApi = Get.put(IssueApi());

  Rx<String> message = Rx('');

  Rx<File?> file = Rx(null);

  final _imagePicker = ImagePicker();

  final String? issueId;

  AddIssueController({required this.issueId});

  pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
      );

      if (image != null) {
        file.value = File(image.path);
      } else {
        Get.back();
      }
    } catch (e) {
      Util.toast(e);
    }
  }

  void add() async {
    if (isAdding.isTrue) return;

    isAdding.value = true;

    if (check()) {
      try {
        var formData = dio.FormData.fromMap({
          'message': message.trim(),
        });

        formData.files.add(MapEntry(
            'file',
            await dio.MultipartFile.fromFile(file.value!.path,
                filename: file.value!.path
                    .substring(file.value!.path.lastIndexOf('/')))));

        if (issueId == null) {
          var issue = (await _issueApi.create(formData)).data!.issue;

          await Get.offAndToNamed('${Routes.kIssue}${issue!.id}');
        } else {
          await _issueApi.comment(issueId!, formData);

          Get.back();
        }
      } catch (e) {
        Util.toast(e);
      }
    }

    isAdding.value = false;
  }

  bool check() {
    try {
      if (message.value.isEmpty) throw 'Type message';

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }
}
