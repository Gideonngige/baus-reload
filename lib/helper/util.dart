import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static String tag({
    Key? key,
    String? userId,
    String? owner,
    String? cboId,
    String? champId,
    String? csrId,
    String? wasteManagerId,
  }) =>
      'userId:$userId key:$key champId:$champId owner:$owner cboId:$cboId csrId:$csrId wasteManagerId:$wasteManagerId '
          .replaceAll(RegExp(r'\w*:(null) '), '')
          .trim();

  static Future<void> locationUpdates(
      Function(Position? position) onUpdatedPosition) async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(
          seconds: 10,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (kDebugMode) {
        print(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');
      }

      onUpdatedPosition(position);
    });

    try {
      var now = await Geolocator.getCurrentPosition();

      onUpdatedPosition(now);
    } catch (e) {
      Util.toast(e);
    }
  }

  static Future<Position> currentPosition() async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static directions(List<double>? coordinates) async {
    try {
      if (coordinates == null) throw 'Check coordinates';

      var url =
          'https://www.google.com/maps/search/?api=1&query=${coordinates[1]},${coordinates[0]}';

      await Util.url(url);
    } catch (e) {
      Util.toast(e);
    }
  }

  static url(String url) async {
    try {
      await canLaunchUrl(Uri.parse(url))
          ? await launchUrl(Uri.parse(url))
          : throw 'Something went wrong. Retry';
    } catch (e) {
      toast(e);
    }
  }

  static call(String? phoneNumber) async {
    Util.url('tel:$phoneNumber');
  }

  static sms(String phoneNumber, String message) async {
    try {
      var compressedMessage = message.replaceAll('"', '\'');

      await Util.url('sms:$phoneNumber?body=$compressedMessage');
    } catch (e) {
      try {
        await Clipboard.setData(ClipboardData(text: message));

        toast('Message copied. Open SMS app and send to $phoneNumber');
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  static String toast(
    e, {
    show = true,
    String? title,
    TextButton? button,
  }) {
    String message = 'Oops! Retry';

    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.sendTimeout:
          message = 'Request took too long. Retry';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Response took too long. Retry';
          break;
        case DioExceptionType.cancel:
          message = 'Request cancelled. Retry';

          show = false;

          break;
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout. Retry';
          break;
        case DioExceptionType.badCertificate:
          message = 'Bad certificate. Retry';
          break;
        case DioExceptionType.badResponse:
          if (e.response?.data is BaseResponse) {
            try {
              message =
                  '${(e.response?.data as BaseResponse?)?.error?.message}';
            } catch (e) {
              message = 'Bad response. Retry';
            }
          } else {
            message = 'Bad response. Retry';
          }
          break;
        case DioExceptionType.connectionError:
          message = 'Connection error. Retry';
          break;
        case DioExceptionType.unknown:
          message = 'Unknown error. Retry';
          break;
      }
    } else if (e is firebase_auth.FirebaseAuthException) {
      message = e.message ?? e.toString();
    } else if (e is PlatformException) {
      message = e.message ?? e.toString();
    } else {
      message = e.toString();
    }

    if (kDebugMode) {
      print('Toast: $e');
    }

    if (show) {
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();

      if (title == null && button == null) {
        Get.rawSnackbar(
          message: message,
          snackPosition: SnackPosition.TOP,
          mainButton: button,
          backgroundColor: Colors.white,
          backgroundGradient: kLinearGradient,
        );
      } else {
        Get.snackbar(
          title ?? 'Notification',
          message,
          snackPosition: SnackPosition.TOP,
          mainButton: button,
          colorText: Colors.white,
          backgroundColor: Colors.white,
          backgroundGradient: kLinearGradient,
          margin: EdgeInsets.zero,
          borderRadius: 0,
        );
      }
    }

    return message;
  }

  static String formatPhoneNumber(String? phoneNumber) => phoneNumber == null
      ? ''
      : phoneNumber.startsWith('+254')
          ? '0${phoneNumber.substring(4)}'
          : phoneNumber;

  static String formatDate(DateTime? dateTime,
          {bool withTime = false,
          bool timeOnly = false,
          bool showDayText = false,
          bool showDay = true,
          String? emptyText}) =>
      dateTime == null
          ? emptyText ?? ''
          : timeOnly
              ? DateFormat('HH:mm').format(dateTime.toLocal())
              : '${showDayText && dayText(dateTime) != null ? '${dayText(dateTime)} · ' : ''}${DateFormat('${showDay ? 'EEEE ' : ''}d, MMMM${DateTime.now().year == dateTime.year ? '' : ' yy'}${withTime ? ' · HH:mm' : ''}').format(dateTime.toLocal())}';

  static String? dayText(DateTime dateTime) {
    var today = DateTime.now();

    if (isSameDay(today, dateTime.toLocal())) {
      return 'Today';
    } else if (isSameDay(
        today.subtract(const Duration(days: 1)), dateTime.toLocal())) {
      return 'Yesterday';
    } else if (isSameDay(
        today.add(const Duration(days: 1)), dateTime.toLocal())) {
      return 'Tomorrow';
    }

    return null;
  }

  static String toTime(int? hour) => hour == null
      ? ''
      : '${hour == 0 ? 12 : hour - 11 < 1 ? hour : hour - 12 == 0 ? 12 : hour - 12}:00 ${hour < 11 ? 'AM' : 'PM'}';

  static Type typeOf<X>() => X;
}
