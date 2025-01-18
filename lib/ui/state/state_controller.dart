import 'package:async/async.dart';
// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/app_notification.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/ui/main/home/messages/messages_controller.dart';
import 'package:baustaka/ui/main/home/notifications/notifications_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class StateController extends SuperController {
  // firebase messaging token observer
  final Rx<String?> _messagingToken = Rx(null);

  // firebase user observer
  final Rx<firebase_auth.User?> _firebaseUser = Rx(null);

  // app user observer
  final Rx<User?> _user = Rx(null);

  // position
  final Rx<Position?> _position = Rx(null);

  Map<String, String>? headers;

  String? get messagingToken => _messagingToken.value;

  set messagingToken(String? newToken) => _messagingToken.value = newToken;

  Future<String?> get idToken async => await firebaseUser?.getIdToken();

  firebase_auth.User? get firebaseUser => _firebaseUser.value;

  set firebaseUser(firebase_auth.User? newUser) =>
      _firebaseUser.value = newUser;

  User? get user => _user.value;

  set user(User? newUser) => _user.value = newUser;

  Position? get position => _position.value;

  List<double> get lngLat {
    var p = position;

    return p == null
        ? user?.lngLat ?? [0, 0]
        : [
            p.longitude,
            p.latitude,
          ];
  }

  set position(Position? newPosition) => _position.value = newPosition;

  final _isFetchingUser = false.obs;

  // final _authApi = Get.put(AuthApi());

  CancelableOperation<dio.Response<BaseResponse>>? _userRequest;

  io.Socket? socket;

  @override
  void onInit() {
    Util.toast(
      'StateController onInit',
      show: false,
    );

    ever(_user, (newValue) {
      updateSocket();

      updatePosition();
    });

    FirebaseMessaging.instance.getToken().then((newToken) {
      messagingToken = newToken;

      Util.toast(
        'FirebaseMessaging initial $newToken',
        show: false,
      );
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      messagingToken = newToken;

      Util.toast(
        'FirebaseMessaging $newToken',
        show: false,
      );
    });

    firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((newFirebaseUser) async {
      firebaseUser = newFirebaseUser;

      Util.toast(
        'FirebaseAuth $newFirebaseUser',
        show: false,
      );

      if (newFirebaseUser != null) {
        updateUser(
          refresh: true,
        );
      } else {
        user = null;
      }
    });

    updatePosition();

    super.onInit();
  }

  updatePosition() async {
    Util.currentPosition().then((newPosition) {
      position = newPosition;

      Util.toast(
        'Util.locationUpdates $newPosition',
        show: false,
      );
    }).onError(
      (error, stackTrace) {
        Util.toast(
          error,
          show: false,
        );
      },
    );
  }

  Future<void> updateUser({
    bool refresh = false,
  }) async {
    if (_isFetchingUser.isTrue || firebaseUser == null) return;

    try {
      await _userRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    // _userRequest = CancelableOperation.fromFuture(
    //   _authApi.auth(query: {
    //     'throwError': false,
    //   }),
    // );

    _userRequest?.then(
      (value) {
        var newUser = value.data?.user;

        user = newUser;

        _isFetchingUser.value = false;

        Util.toast(
          'User $newUser',
          show: false,
        );
      },
      onError: (error, stackTrace) {
        Util.toast(error);

        _isFetchingUser.value = false;
      },
    );

    _isFetchingUser.value = true;
  }

  updateSocket() {
    Session.headers().then((headers) {
      var optionBuilder = io.OptionBuilder();

      optionBuilder.setExtraHeaders(headers);
      optionBuilder.setTransports(['websocket']);

      socket?.clearListeners();
      socket?.close();

      if (user == null) return;

      socket = io.io(
        '${kBaseSocketUrl}user',
        optionBuilder.build(),
      );

      socket?.onConnect((data) {
        Util.toast(
          'UserSocket onConnect $data',
          show: false,
        );
      });

      socket?.onReconnect((data) {
        Util.toast(
          'UserSocket onReconnect $data',
          show: false,
        );
      });

      socket?.onReconnectAttempt((data) {
        Util.toast(
          'UserSocket onReconnectAttempt $data',
          show: false,
        );
      });

      socket?.onPing((data) {
        Util.toast(
          'UserSocket onPing $data',
          show: false,
        );
      });

      socket?.onPong((data) {
        Util.toast(
          'UserSocket onPong $data',
          show: false,
        );
      });

      socket?.onDisconnect((data) {
        Util.toast(
          'UserSocket onDisconnect $data',
          show: false,
        );

        Future.delayed(
          const Duration(
            seconds: 5,
          ),
        ).then((value) async {
          if (socket?.connected != true) {
            updateSocket();
          }
        });
      });

      socket?.onConnectError((data) {
        Util.toast(
          'UserSocket onConnectError $data',
          show: false,
        );
      });

      socket?.onConnectError((data) {
        Util.toast(
          'UserSocket onConnectError $data',
          show: false,
        );
      });

      socket?.onError((data) {
        Util.toast(
          'UserSocket onError $data',
          show: false,
        );
      });

      socket?.on('data', (data) {
        Util.toast(
          'UserSocket onData $data',
          show: false,
        );

        try {
          final baseResponse = BaseResponse.fromJson(data);

          if (baseResponse.notification != null) {
            if (baseResponse.notification?.type ==
                    AppNotificationType.visible &&
                Get.currentRoute != baseResponse.notification?.route) {
              user = user?..notifications = (user?.notifications ?? 0) + 1;

              try {
                Get.find<NotificationsController>(
                  tag: Util.tag(),
                ).insert(
                  baseResponse.notification,
                );
              } catch (e) {
                Util.toast(
                  e,
                  show: false,
                );
              }

              Util.toast(
                baseResponse.notification?.body,
                title: baseResponse.notification?.title,
                show: true,
                button: baseResponse.notification?.route != null
                    ? TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async => await Get.toNamed(
                          baseResponse.notification?.route ?? Routes.kUnknown,
                        ),
                        child: Text(
                            baseResponse.message == null ? 'View' : 'Reply'),
                      )
                    : null,
              );
            }

            if (baseResponse.message != null) {
              try {
                Get.find<MessagesController>(
                  tag: Util.tag(),
                ).insert(
                  baseResponse.message,
                );
              } catch (e) {
                Util.toast(
                  e,
                  show: false,
                );
              }

              try {
                Get.find<MessagesController>(
                  tag: Util.tag(userId: baseResponse.message?.toUser?.id),
                ).insert(
                  baseResponse.message,
                );
              } catch (e) {
                Util.toast(
                  e,
                  show: false,
                );
              }
            }

            if (baseResponse.user?.isSelf == true) {
              user = baseResponse.user;
            }
          }
        } catch (e) {
          Util.toast(
            e,
            show: false,
          );
        }
      });
    }).onError(
      (error, stackTrace) {
        Util.toast(
          error,
          show: false,
        );
      },
    );
  }

  addUserListener(Function(User? newUser) onUpdate) {
    onUpdate(user);

    ever(
      _user,
      (callback) => onUpdate(user),
    );
  }

  addPositionListener(Function(Position? newPosition) onUpdate) {
    onUpdate(position);

    ever(
      _position,
      (callback) => onUpdate(position),
    );
  }

  @override
  void onDetached() {
    Util.toast(
      'StateController onDetached',
      show: false,
    );

    socket?.clearListeners();
    socket?.close();
  }

  @override
  void onInactive() {
    Util.toast(
      'StateController onInactive',
      show: false,
    );

    socket?.clearListeners();
    socket?.close();
  }

  @override
  void onPaused() {
    Util.toast(
      'StateController onPaused',
      show: false,
    );

    socket?.clearListeners();
    socket?.close();
  }

  @override
  void onResumed() {
    Util.toast(
      'StateController onResumed',
      show: false,
    );

    updateSocket();

    updatePosition();
  }

  @override
  void dispose() {
    Util.toast(
      'StateController dispose',
      show: false,
    );

    socket?.clearListeners();
    socket?.close();

    super.dispose();
  }

  @override
  void onHidden() {
    Util.toast(
      'StateController onHidden',
      show: false,
    );

    socket?.clearListeners();
    socket?.close();
  }
}
