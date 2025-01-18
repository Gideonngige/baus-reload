import 'package:baustaka/api/post_api.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/model/post_page.dart';
import 'package:baustaka/model/price.dart';
import 'package:baustaka/model/product.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/socket/user.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/main/home/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum BookingState {
  kDetails,
  kWaste,
  kPayment,
  kSummary,
}

class BookingController extends GetxController {
  RxBool isRequesting = RxBool(false);
  RxBool isRequestingMyLocation = RxBool(false);
  RxBool isPricing = RxBool(false);
  Color get color => data.value['type'] == 'disposal'
      ? Palette.primary
      : data.value['type'] == 'donation'
          ? Colors.orange
          : Colors.lightBlue;

  Rx<firebase_auth.User?> firebaseUser = Rx(null);

  Rx<BookingState> bookingState = Rx(BookingState.kDetails);
  Rx<Map<String, dynamic>> data = Rx({
    'date': DateTime.now(),
    'frequency': 'one-time',
    'total': 1,
    'categories': List<String>.empty(
      growable: true,
    ),
    'groups': List<String>.empty(
      growable: true,
    ),
  });

  Rx<Post?> post = Rx(null);

  final _postApi = Get.put(PostApi());

  Rx<PostPage?> postPage = Rx(null);

  Rx<Station?> station = Rx(null);

  RxList<Price> prices = RxList.empty(growable: true);

  Rx<String?> message = Rx<String?>(null);
  Rx<String?> area = Rx(null);
  double? latitude;
  double? longitude;

  final String type;
  final String withProduct;

  final userSocket = Get.put(
    UserSocket(),
    permanent: true,
  );

  RxList<Picker> pickers = RxList.empty(growable: true);

  TextEditingController phoneNumber = TextEditingController(text: '');

  TextEditingController total = TextEditingController(text: '1');

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  BookingController({
    required this.type,
    required this.withProduct,
  });

  @override
  void onInit() async {
    super.onInit();

    data.value['type'] = type;

    data.value['groups'] = [
      type == 'sale' || type == 'donation' ? 'segregated' : 'mixed'
    ];

    if (withProduct == 'yes' && type == 'disposal') {
      data.value['frequency'] = 'monthly';
    }

    ever(userSocket.picker, (value) {
      var picker = userSocket.picker.value;

      if (picker != null) {
        pickers.removeWhere((element) => element.id == picker.id);

        pickers.insert(0, picker);

        if (kDebugMode) {
          print('Picker ${pickers.length}');
        }
      }
    });

    await updateCurrentLocation();
  }

  updateCurrentLocation() async {
    if (isRequestingMyLocation.isTrue) return;

    isRequestingMyLocation.value = true;

    try {
      var position = await Util.currentPosition();

      data.update((val) {
        val!['area'] = 'My current location';
        val['latitude'] = position.latitude;
        val['longitude'] = position.longitude;
      });
    } catch (e) {
      Util.toast(e);
    }

    isRequestingMyLocation.value = false;
  }

  request() async {
    if (isRequesting.isTrue) return;

    isRequesting.value = true;

    try {
      var dataToSend = Map<String, dynamic>.from(data.value);

      dataToSend.remove('product');

      if (data.value['product'] != null) {
        dataToSend['product'] = (data.value['product'] as Product).id;
      }

      post.value = (await _postApi.create(dataToSend)).data!.post;

      Util.toast('We are processing your request');

      await Get.offAndToNamed('${Routes.kPost}${post.value!.id}');

      await Get.put(HomeController(), tag: 'home').fetch();
    } catch (e) {
      Util.toast(e);
    }

    isRequesting.value = false;
  }

  price() async {
    if (isPricing.isTrue) return;

    isPricing.value = true;

    data.value.remove('station');

    data.value.remove('mode');

    station.value = null;

    prices.clear();

    try {
      var dataToSend = Map<String, dynamic>.from(data.value);

      dataToSend.remove('product');

      if (data.value['product'] != null) {
        dataToSend['product'] = (data.value['product'] as Product).id;
      }

      var result = (await _postApi.price(dataToSend)).data;

      station.value = result!.station;

      data.value['station'] = station.value!.id;

      prices.addAll(result.prices!);

      if (result.prices!.length == 1) {
        data.value['mode'] = result.prices!.first.mode;
        data.value['price'] = result.prices!.first.cost;
      }

      bookingState.value = BookingState.kPayment;
    } catch (e) {
      Util.toast(e);
    }

    isPricing.value = false;
  }

  void updateLocation() {
    var newPosition = LatLng(
      data.value['latitude'] ?? 0,
      data.value['longitude'] ?? 0,
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
