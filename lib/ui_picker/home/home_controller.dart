import 'dart:async';

import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/picker_api.dart';
import 'package:baustaka/api/post_api.dart';
import 'package:baustaka/db/settings.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/model/post_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/socket/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum BookingState {
  kNotStarted,
  kDetails,
  kPayment,
}

class HomeWasteManagerController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey(
    debugLabel: 'home-picker',
  );

  RxBool isUpdating = RxBool(false);
  RxBool isFetching = RxBool(false);
  RxBool isFetchingPost = RxBool(false);
  RxBool isRequesting = RxBool(false);
  RxBool isPricing = RxBool(false);

  Rx<firebase_auth.User?> firebaseUser = Rx(null);

  Rx<BookingState> bookingState = Rx(BookingState.kNotStarted);

  Rx<Map<String, dynamic>> data = Rx({
    'limit': 1,
  });

  Rx<Post?> post = Rx(null);

  final _postApi = Get.put(PostApi());

  Rx<User?> user = Rx(null);

  Rx<PostPage?> postPage = Rx(null);

  final _authApi = Get.put(AuthApi());

  final _pickerApi = Get.put(PickerApi());

  Rx<Picker?> picker = Rx(null);

  RxBool isRegistered = RxBool(true);

  RxBool isOnline = RxBool(false);
  RxBool isRequestingMyLocation = RxBool(false);
  Rx<Position?> currentPosition = Rx(null);
  GoogleMapController? googleMapController;

  final userSocket = Get.put(
    UserSocket(),
    permanent: true,
  );

  @override
  void onInit() async {
    Timer.periodic(
      const Duration(
        seconds: 5,
      ),
      (_) => startLocationUpdates(),
    );

    try {
      isOnline.value = await SettingsDb.isOnline();
    } catch (e) {
      Util.toast(e);
    }

    await fetch();

    await startLocationUpdates();

    super.onInit();
  }

  startLocationUpdates() async {
    try {
      await Util.locationUpdates((position) async {
        currentPosition.value = position;

        if (isOnline.isTrue) {
          userSocket.updateLocation(
            {
              'latitude': position?.latitude,
              'longitude': position?.longitude,
            },
          );
        }

        await googleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: position != null
              ? LatLng(position.latitude, position.longitude)
              : const LatLng(-4.0435, 39.6682),
          zoom: 12.8,
        )));
      });
    } catch (e) {
      Util.toast(e);

      isOnline.value = false;
    }
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    isRegistered.value = true;

    picker.value = null;

    try {
      if (Session.user == null) throw 'Please log in';
      firebaseUser.value = Session.user;

      user.value = (await _authApi.auth()).data?.user;

      picker.value =
          (await _pickerApi.retrieve({'userId': user.value?.id})).data?.picker;

      Map<String, dynamic> query = {
        'pickerId': picker.value?.id,
        'status': 'started',
      };

      postPage.value = (await _postApi.retrieve(query)).data?.postPage;

      if (postPage.value!.docs!.isNotEmpty) {
        post.value = postPage.value?.docs?.first;
        bookingState.value = BookingState.kPayment;
      }
    } catch (e) {
      Util.toast(e);

      if (e is String && e.toLowerCase().contains('picker not found')) {
        isRegistered.value = false;
      }
    }

    isFetching.value = false;
  }

  fetchPost() async {
    if (isFetchingPost.isTrue) return;

    isFetchingPost.value = true;

    try {
      post.value = null;

      var query = data.value;

      query['stationId'] = picker.value?.station?.id;

      query['status'] = 'accepted';

      var postPage =
          (await _postApi.retrieve(query.toRequestBody())).data?.postPage;

      if (postPage!.docs!.isEmpty) {
        throw 'We could not find any job for you. Try later';
      }

      post.value = postPage.docs?.first;

      bookingState.value = BookingState.kPayment;
    } catch (e) {
      Util.toast(e);
    }

    isFetchingPost.value = false;
  }

  updatePicker(dynamic data) async {
    if (isUpdating.isTrue) return;

    isUpdating.value = true;

    try {
      picker.value =
          (await _pickerApi.update(picker.value!.id!, data)).data?.picker;

      Util.toast('Updated');
    } catch (e) {
      Util.toast(e);
    }

    isUpdating.value = false;
  }

  request(String status) async {
    if (isRequesting.isTrue) return;

    isRequesting.value = true;

    try {
      post.value = (await _postApi.update(post.value!.id!, {'status': status}))
          .data
          ?.post;

      Util.toast('We are processing your request');

      if (post.value?.status != 'started' &&
          post.value?.status != 'collected') {
        bookingState.value = BookingState.kNotStarted;
      }

      await fetch();
    } catch (e) {
      Util.toast(e);
    }

    isRequesting.value = false;
  }

  cancel() async {
    if (post.value != null &&
        (post.value?.status == 'started' ||
            post.value?.status == 'collected')) {
      await request('accepted');
    } else {
      bookingState.value = BookingState.kNotStarted;
    }
  }
}
