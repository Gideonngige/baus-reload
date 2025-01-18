import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class UserSocket extends GetxController {
  io.Socket? socket;

  Rx<Picker?> picker = Rx(null);

  RxBool isConnected = RxBool(false);

  @override
  void onInit() {
    _createSocket();

    super.onInit();
  }

  _createSocket() async {
    var opts = await options();

    socket?.clearListeners();
    socket?.close();

    socket = io.io(
      kBaseSocketUrl,
      opts,
    );

    socket?.onConnect((data) {
      if (kDebugMode) {
        print('UserSocket onConnect $data');
      }

      isConnected.value = true;
    });

    socket?.onReconnect((data) {
      if (kDebugMode) {
        print('UserSocket onReconnect $data');
      }

      isConnected.value = true;
    });

    socket?.onReconnectAttempt((data) {
      if (kDebugMode) {
        print('UserSocket onReconnectAttempt $data');
      }

      isConnected.value = false;
    });

    socket?.onPing((data) {
      if (kDebugMode) {
        print('UserSocket onPing $data');
      }
    });

    socket?.onPong((data) {
      if (kDebugMode) {
        print('UserSocket onPong $data');
      }
    });

    socket?.onDisconnect((data) {
      if (kDebugMode) {
        print('UserSocket onDisconnect $data');
      }

      isConnected.value = false;

      Future.delayed(
        const Duration(
          seconds: 15,
        ),
      ).then((value) async {
        if (socket?.connected != true) {
          _createSocket();
        }
      });
    });

    socket?.onConnectError((data) {
      if (kDebugMode) {
        print('UserSocket onConnectError $data');
      }

      isConnected.value = false;
    });


    socket?.onError((data) {
      if (kDebugMode) {
        print('UserSocket onError $data');
      }
    });

    socket?.on('update-map', (data) {
      if (kDebugMode) {
        print('UserSocket update-map $data');
      }

      try {
        picker.value = BaseResponse.fromJson(data).picker;
        if (kDebugMode) {
          print('UserSocket update-map  picker ${picker.value?.id}');
        }
      } catch (e) {
        Util.toast(e);
      }
    });
  }

  Future<Map<String, dynamic>> options() async {
    var optionBuilder = io.OptionBuilder();

    try {
      final headers = await Session.headers();

      optionBuilder.setExtraHeaders(headers);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    optionBuilder.setTransports(['websocket']);

    return optionBuilder.build();
  }

  void updateLocation(dynamic data) {
    if (kDebugMode) {
      print('UserSocket updateLocation $data');
    }

    socket?.emit('update-location', data);
  }

  @override
  void dispose() {
    socket?.clearListeners();
    socket?.close();

    super.dispose();
  }
}
