import 'package:baustaka/api/post_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostController extends GetxController {
  var isFetching = false.obs;
  var isUpdating = false.obs;

  Rx<Post?> post = Rx(null);

  final _postApi = Get.put(PostApi());

  final String postId;

  TextEditingController phoneNumber = TextEditingController();

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  PostController({required this.postId});

  @override
  void onInit() async {
    super.onInit();

    await fetch();
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      post.value = (await _postApi.retrieve({'postId': postId})).data!.post;

      phoneNumber.text = Util.formatPhoneNumber(post.value!.phoneNumber);

      updateLocation();
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }

  pay() async {
    if (isUpdating.isTrue) return;

    isUpdating.value = true;

    try {
      if (!phoneNumber.text.toString().trim().startsWith('0') ||
          phoneNumber.text.toString().trim().length != 10) {
        throw 'Check your phone number';
      }

      post.value = (await _postApi.update(
        postId,
        {
          'phoneNumber': phoneNumber.text.trim(),
        },
      ))
          .data!
          .post;

      Util.toast('We are processing your request');
    } catch (e) {
      Util.toast(e);
    }

    isUpdating.value = false;
  }

  void updateLocation() {
    var newPosition = LatLng(
      post.value?.point?.coordinates?[1] ?? 0,
      post.value?.point?.coordinates?[0] ?? 0,
    );

    if (updateMap != null) {
      updateMap!(
        newPosition,
        showCircles: false,
        withZoom: kZoomForMarker,
      );
    }
  }
}
