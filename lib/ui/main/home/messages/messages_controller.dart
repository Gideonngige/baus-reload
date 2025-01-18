import 'dart:io';

import 'package:async/async.dart';
import 'package:baustaka/api/message_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/message.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessagesController extends GetxController {
  var isFetching = false.obs;
  var isRefreshing = false.obs;
  var isFailed = false.obs;
  var isAdding = false.obs;

  final TextEditingController textEditingController = TextEditingController();

  RxList<Message> messages = RxList.empty(
    growable: true,
  );

  RxMap map = RxMap({
    'files': List<File>.empty(
      growable: true,
    ),
    'lngLat': null,
  });

  final _messageApi = Get.put(MessageApi());

  final String? userId;

  Rx<Paged<Message>?> currentMessagePage = Rx(null);

  CancelableOperation<dio.Response<BaseResponse>>? _messagesRequest;

  CancelableOperation<dio.Response<BaseResponse>>? _messageRequest;

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  String? failedText;

  final Rx<User?> user = Rx(null), stateUser = Rx(null);

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  String? action;

  String? get hint {
    switch (action) {
      case 'part':
        return 'Type car part...';
      case 'service':
        return 'Type car model...';
      case 'garage':
        return 'Type car problem...';
      case 'emergency':
        return 'Type car emergency...';
    }
    return null;
  }

  MessagesController({
    required this.userId,
    this.action,
  });

  @override
  void onInit() {
    stateController.addUserListener((newUser) {
      stateUser.value = newUser;

      messages.refresh();
    });

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    await fetch(
      refresh: true,
    );
  }

  Future<void> fetch({
    bool refresh = false,
  }) async {
    if (isFetching.isTrue && !refresh) return;

    try {
      await _messagesRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    Map<String, dynamic> query = {
      'page': refresh ? 1 : currentMessagePage.value?.next ?? 1,
    };

    if (userId != null) query['userId'] = userId;

    _messagesRequest = CancelableOperation.fromFuture(
      _messageApi.retrieve(query),
    );

    _messagesRequest?.then(
      (value) {
        var messagePage = value.data?.messagePage;

        currentMessagePage.value = messagePage ?? currentMessagePage.value;

        user.value = value.data?.user ?? user.value;

        messages.updateAll(
          elements: currentMessagePage.value?.docs,
          refresh: refresh,
          test: (messageAt, message) => messageAt.id == message.id,
          upsert: true,
        );

        messages.refresh();

        isFetching.value = false;

        isRefreshing.value = false;
      },
      onError: (error, stackTrace) {
        failedText = Util.toast(error);

        isFetching.value = false;

        isRefreshing.value = false;

        isFailed.value = true;
      },
    );

    failedText = null;

    isFetching.value = true;

    isRefreshing.value = refresh;

    isFailed.value = false;
  }

  add() async {
    if (isAdding.isTrue) return;

    if ((map['description'] as String?)?.trim().isNotEmpty != true) {
      Util.toast('Type a message');

      return;
    }

    isAdding.value = true;

    try {
      await _messageRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    Map<String, dynamic> data = Map.from(map);

    data['toUserId'] = user.value?.id;

    if (data['lngLat'] == null) data.remove('lngLat');

    if ((data['files'] as List).isEmpty) data.remove('files');

    if (action != null) {
      data['description'] = '${action?.capitalize}: ${data['description']}';
    }

    _messageRequest = CancelableOperation.fromFuture(
      _messageApi.create(data),
    );

    _messageRequest?.then(
      (value) async {
        textEditingController.clear();

        map['description'] = null;

        map.update('files', (value) {
          (value as List).clear();

          return value;
        });

        map.update('lngLat', (value) => null);

        var message = value.data?.message;

        if (action != null) {
          action = null;
          user.refresh();
        }

        insert(message);

        isAdding.value = false;
      },
      onError: (error, stackTrace) {
        Util.toast(error);

        isAdding.value = false;
      },
    );

    isAdding.value = true;
  }

  insert(Message? message) {
    if (message != null) {
      messages.updateAll(
        elements: [message],
        refresh: false,
        test: (messageAt, message) => messageAt.id == message.id,
        upsert: true,
        fromStart: true,
      );

      messages.refresh();
    }
  }
}
