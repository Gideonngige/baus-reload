import 'package:baustaka/api/event_api.dart';
import 'package:baustaka/api/rsvp_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/event.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  var isFetching = false.obs;

  Rx<Event?> event = Rx(null);

  final _eventApi = Get.put(EventApi());

  final _rsvpApi = Get.put(RsvpApi());

  final String eventId;

  EventController({required this.eventId});

  @override
  void onInit() async {
    super.onInit();

    fetch();
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      event.value =
          (await _eventApi.retrieve({'eventId': eventId})).data!.event;
      if (kDebugMode) {
        print(event.value);
      }
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }

  rsvpEvent() async {
    try {
      int toggle = (await _rsvpApi.toggle({'eventId': eventId})).data!.toggle!;

      event.value!.rsvpd = toggle == 1;

      event.value!.rsvps = event.value!.rsvps! + toggle;

      event.refresh();
    } catch (e) {
      Util.toast(e);
    }
  }
}
