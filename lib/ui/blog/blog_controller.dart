import 'dart:io';

import 'package:baustaka/api/blog_api.dart';
import 'package:baustaka/api/blog_like_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/model/blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';

class BlogController extends GetxController {
  var isFetching = false.obs;
  var isFetchingComment = false.obs;
  var isAdding = false.obs;

  Rx<Blog?> blog = Rx(null);

  final _blogApi = Get.put(BlogApi());

  final _blogLikeApi = Get.put(BlogLikeApi());

  RxList<Blog> comments = RxList.empty();

  Rx<File?> file = Rx(null);

  Rx<String?> message = Rx(null);

  final _imagePicker = ImagePicker();

  var textFieldController = TextEditingController();

  BlogPage? _commentPage;

  final String blogId;

  BlogController({required this.blogId});

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
    await _fetchBlog();

    await _fetchComments(true);
  }

  _fetchBlog() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      blog.value = (await _blogApi.retrieve({'blogId': blogId})).data!.blog;
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }

  blogLikeBlog(Blog blogToLike) async {
    try {
      int toggle =
          (await _blogLikeApi.toggle({'blogId': blogToLike.id})).data!.toggle!;

      if (blog.value!.id == blogToLike.id) {
        blog.value!.blogLiked = toggle == 1;

        blog.value!.blogLikes = blog.value!.blogLikes! + toggle;

        blog.refresh();
      } else {
        for (var b in comments) {
          if (b.id == blogToLike.id) {
            b.blogLiked = toggle == 1;

            b.blogLikes = b.blogLikes! + toggle;
          }
        }

        comments.refresh();
      }
    } catch (e) {
      Util.toast(e);
    }
  }

  _fetchComments(bool refresh) async {
    if (isFetchingComment.isTrue) return;

    isFetchingComment.value = true;

    if (refresh) {
      comments.clear();

      _commentPage = null;
    } else if ((_commentPage!.page! >= _commentPage!.pages! ||
        _commentPage!.docs!.isEmpty)) {
      isFetchingComment.value = false;
      return;
    }

    try {
      int page = _commentPage == null ? 1 : _commentPage!.page! + 1;

      _commentPage = (await _blogApi.retrieve({
        'page': page.toString(),
        'parent': blogId,
      }))
          .data!
          .blogPage;

      comments.addAll(_commentPage!.docs!);
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
          'description': message.trim(),
        });

        if (file.value != null) {
          formData.files.add(MapEntry(
              'files',
              await dio.MultipartFile.fromFile(file.value!.path,
                  filename: file.value!.path
                      .substring(file.value!.path.lastIndexOf('/')))));
        }

        final b = (await _blogApi.comment(blogId, formData)).data!.blog;

        comments.insert(0, b!);

        file.value = null;
        message.value = null;
        textFieldController.clear();

        await _fetchBlog();
      } catch (e) {
        Util.toast(e);
      } finally {
        isAdding.value = false;
      }
    }
  }

  bool check() {
    try {
      if (message.value == null || message.value!.isEmpty) throw 'Type comment';

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }
}
