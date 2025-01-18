import 'package:baustaka/api/event_api.dart';
import 'package:baustaka/api/rsvp_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/event.dart';
import 'package:baustaka/model/event_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

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
      var prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay,
        overlayBorderRadius: BorderRadius.circular(8),
        components: [Component(Component.country, 'ke')],
        strictbounds: false,
        types: [],
        proxyBaseUrl: kIsWeb ? kProxyBaseUrl : null,
      );

      if (prediction != null && prediction.placeId != null) {
        final place = await GoogleMapsPlaces(
          apiKey: kGoogleApiKey,
          apiHeaders: await const GoogleApiHeaders().getHeaders(),
        ).getDetailsByPlaceId(prediction.placeId!);

        if (place.hasNoResults) throw 'Something went wrong. Try again';

        area.value = place.result.name;
        latitude = place.result.geometry!.location.lat;
        longitude = place.result.geometry!.location.lng;

        await fetch(true);
      }
    } catch (e) {
      Util.toast(e);
    }
  }
}
