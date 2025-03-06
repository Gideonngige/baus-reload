import 'package:baustaka/api/event_api.dart';
import 'package:baustaka/api/rsvp_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/event.dart';
import 'package:baustaka/model/event_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:google_api_headers/google_api_headers.dart';

class EventsController extends GetxController {
  var isFetching = false.obs;
  var showSearch = false.obs;

  EventApi eventApi = Get.put(EventApi());

  final _rsvpApi = Get.put(RsvpApi());

  RxList<Event> events = RxList.empty();

  EventPage? _eventPage;

  String? q;

  Rx<String?> tag = Rx(null);
  Rx<String?> area = Rx(null);
  RxInt distance = RxInt(5);
  double? latitude;
  double? longitude;

  final String tags;

  EventsController({required this.tags});

  @override
  void onInit() async {
    super.onInit();

    await fetch(true);
  }

  fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      events.clear();

      _eventPage = null;
    } else if (_eventPage != null &&
        (_eventPage!.page! >= _eventPage!.pages! ||
            _eventPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      int page = _eventPage == null ? 1 : _eventPage!.page! + 1;

      Map<String, dynamic> query = {'page': page.toString(), 'tags': tags};

      if (q != null && q!.trim().isNotEmpty) query.addAll({'q': q!.trim()});

      if (latitude != null) query.addAll({'latitude': latitude.toString()});

      if (longitude != null) query.addAll({'longitude': longitude.toString()});

      query.addAll({'distance': distance.value.toString()});

      if (tag.value != null && tag.value != 'All') {
        query.addAll({'tag': tag.value.toString()});
      }

      _eventPage = (await eventApi.retrieve(query)).data!.eventPage;

      events.addAll(_eventPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }

  rsvpEvent(String eventId) async {
    try {
      int toggle = (await _rsvpApi.toggle({'eventId': eventId})).data!.toggle!;

      for (var event in events) {
        if (eventId == event.id) {
          event.rsvpd = toggle == 1;

          event.rsvps = event.rsvps! + toggle;
        }
      }

      events.refresh();
    } catch (e) {
      Util.toast(e);
    }
  }

  fetchPlace(BuildContext context) async {
    try {
      var googlePlace = GooglePlace(kGoogleApiKey);
      var result = await googlePlace.autocomplete.get(
        '',
        components: [Component('country', 'ke')],
      );

      if (result != null && result.predictions!.isNotEmpty) {
        var prediction = result.predictions!.first;
        var details = await googlePlace.details.get(prediction.placeId!);

        if (details != null && details.result != null) {
          area.value = details.result!.name;
          latitude = details.result!.geometry!.location!.lat;
          longitude = details.result!.geometry!.location!.lng;

          await fetch(true);
        }
      }
    } catch (e) {
      Util.toast(e);
    }
  }
}