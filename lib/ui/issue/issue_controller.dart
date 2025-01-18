import 'dart:io';

import 'package:baustaka/api/issue_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/issue.dart';
import 'package:baustaka/model/issue_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class IssueController extends GetxController {
  var isFetching = false.obs;
  var isFetchingComment = false.obs;

  var isAdding = false.obs;

  final _issueApi = Get.put(IssueApi());

  Rx<Issue?> issue = Rx(null);

  RxList<Issue> responses = RxList.empty();

  Rx<File?> file = Rx(null);

  Rx<String> message = Rx('');

  final _imagePicker = ImagePicker();

  var textFieldController = TextEditingController();

  IssuePage? _responsePage;

  final String issueId;

  IssueController({required this.issueId});

  @override
  void onInit() async {
    super.onInit();

    await fetch();
  }

  pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
      );

      if (image != null) file.value = File(image.path);
    } catch (e) {
      Util.toast(e);
    }
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      issue.value =
          (await _issueApi.retrieve({'issueId': issueId})).data!.issue;

      await fetchResponses(true);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }

  fetchResponses(bool refresh) async {
    if (isFetchingComment.isTrue) return;

    isFetchingComment.value = true;

    if (refresh) {
      responses.clear();

      _responsePage = null;
    } else if ((_responsePage!.page! >= _responsePage!.pages! ||
        _responsePage!.docs!.isEmpty)) {
      isFetchingComment.value = false;
      return;
    }

    try {
      int page = _responsePage == null ? 1 : _responsePage!.page! + 1;

      _responsePage = (await _issueApi.retrieve({
        'page': page.toString(),
        'parent': issueId,
      }))
          .data!
          .issuePage;

      responses.addAll(_responsePage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetchingComment.value = false;
  }

  add() async {
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

        final issueToAdd = (await _issueApi.comment(issueId, formData)).data!.issue;

        responses.add(issueToAdd!);

        file.value = null;
        message.value = '';
        textFieldController.clear();
      } catch (e) {
        Util.toast(e);
      }
    }

    isAdding.value = false;
  }

  bool check() {
    try {
      if (message.value.isEmpty) throw 'Type comment';

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }
}
