import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:baustaka/helper/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

extension ExtOnNum on num {
  String withCommas() {
    final numberFormat = NumberFormat.decimalPattern(
      Platform.localeName,
    );

    var value = this;

    if (value == toInt()) value = value.toInt();

    final parts = value.toString().split('.');

    if (parts.length == 1) {
      return numberFormat.format(num.tryParse(parts[0]) ?? 0);
    }

    return '${numberFormat.format(num.tryParse(parts[0]) ?? 0)}.${parts[1]}';
  }
}

extension ListMixinExtension<E> on ListMixin<E> {
  void updateAll({
    required List<E>? elements,
    required bool Function(E, E) test,
    bool refresh = false,
    bool upsert = false,
    bool fromStart = false,
  }) {
    if (elements == null) {
      return;
    }

    if (refresh) {
      clear();

      addAll(elements);
    } else {
      for (var element in elements) {
        var index = indexWhere((elementAt) => test(elementAt, element));

        if (index >= 0) {
          this[index] = element;
        } else if (upsert) {
          if (fromStart) {
            insert(0, element);
          } else {
            add(element);
          }
        }
      }
    }
  }
}

extension DateTimeExtension on DateTime {
  String get ago {
    var durationPast = DateTime.now().difference(this);

    if (durationPast.inDays >= 360) {
      var value = durationPast.inDays ~/ 360;

      return '$value y';
    }

    if (durationPast.inDays >= 30) {
      var value = durationPast.inDays ~/ 30;
      return '$value mo';
    }

    if (durationPast.inHours >= 24) {
      var value = durationPast.inHours ~/ 24;
      return '$value d';
    }

    if (durationPast.inMinutes >= 60) {
      var value = durationPast.inMinutes ~/ 60;
      return '$value h';
    }

    if (durationPast.inSeconds >= 60) {
      var value = durationPast.inSeconds ~/ 60;
      return '$value m';
    }

    if (durationPast.inSeconds < 60) {
      var value = durationPast.inSeconds;
      return '$value s';
    }

    return minimal;
  }

  String get minimal {
    if (isSameDay(toLocal(), DateTime.now())) {
      return Util.formatDate(
        this,
        timeOnly: true,
      );
    }

    if (isSameDay(
        toLocal(), DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }

    return Util.formatDate(
      this,
      showDay: false,
    );
  }

  DateTime startOfDay() {
    DateTime dateTime = DateTime(year, month, day);

    return dateTime;
  }

  DateTime endOfDay() {
    DateTime dateTime = DateTime(year, month, day, 23, 59, 59, 999);

    return dateTime;
  }
}

extension DurationExtension on Duration {
  String get span {
    int days = inDays;

    int hours = inHours;

    if (hours >= 24) {
      hours = hours % 24;
    }

    int minutes = inMinutes;

    if (minutes >= 60) {
      minutes = minutes % 60;
    }

    return '${days > 0 ? '${days}d${hours > 0 ? ' ' : ''}' : ''}${hours > 0 ? '${hours}h${minutes > 0 ? ' ' : ''}' : ''}${minutes > 0 ? '${minutes}m' : ''}';
  }
}

extension StringExtension on String {
  Color toColor() {
    var hex = replaceAll('#', '');

    Color converted = Colors.black;

    if (hex.length == 6) {
      converted = Color(int.parse('0xFF$hex'));
    } else if (hex.length == 8) {
      converted = Color(int.parse('0x$hex'));
    }

    return converted;
  }
}

extension IntExtension on int {
  String wrap() {
    if (this < 10000) return '$this';

    const suffixes = ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'];

    var i = (log(this) / log(1000)).floor();

    return '${(this / pow(1000, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

extension MapExtension on Map<String, dynamic> {
  dynamic toRequestBody() {
    Map<String, dynamic> map = {};
    FormData? formData;

    forEach((key, value) {
      if (value is File) {
        formData ??= FormData.fromMap({});

        formData!.files.add(
          MapEntry(
            key,
            MultipartFile.fromFileSync(
              value.path,
              filename: value.path.substring(
                value.path.lastIndexOf('/'),
              ),
            ),
          ),
        );
      } else if (value is Uint8List) {
        formData ??= FormData.fromMap({});

        formData!.files.add(
          MapEntry(
            key,
            MultipartFile.fromBytes(
              value,
              filename: 'file.jpg',
            ),
          ),
        );
      } else if (value is DateTime) {
        map.addAll({key: value.toUtc().toIso8601String()});
      } else if (value.runtimeType == Util.typeOf<List<File>>()) {
        formData ??= FormData.fromMap({});

        for (var element in (value as List<File>)) {
          formData!.files.add(
            MapEntry(
              key,
              MultipartFile.fromFileSync(
                element.path,
                filename: element.path.substring(
                  element.path.lastIndexOf('/'),
                ),
              ),
            ),
          );
        }
      } else if (value.runtimeType == Util.typeOf<List<Uint8List>>()) {
        formData ??= FormData.fromMap({});

        for (var element in (value as List<Uint8List>)) {
          formData!.files.add(
            MapEntry(
              key,
              MultipartFile.fromBytes(
                element,
                filename: 'file.jpg',
              ),
            ),
          );
        }
      } else if (value is List) {
        map.addAll({key: value});
      } else if (value is String) {
        if (value.trim().isNotEmpty) {
          map.addAll({
            key: value.trim(),
          });
        }
      } else if (value is Map) {
        map.addAll({key: jsonEncode(value)});
      } else if (value != null) {
        map.addAll({key: value.toString()});
      }
    });

    if (formData != null) {
      map.forEach((key, value) {
        formData!.fields
            .add(MapEntry(key, value is List ? jsonEncode(value) : value));
      });
    }

    return formData ?? map;
  }
}
