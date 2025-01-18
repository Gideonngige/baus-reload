import 'package:flutter/material.dart';

Widget markedContainer(Color color) {
  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      border: Border.all(color: Colors.white),
    ),
    child: const Icon(Icons.check, color: Colors.white),
  );
}

Widget circularContainer(Color color) {
  return Container(
    width: 30,
    height: 30,
    padding: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      border: Border.all(color: color, width: 10.0),
    ),
  );
}

Widget borderContainer() {
  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      border: Border.all(color: Colors.grey.withOpacity(.4), width: 1.0),
    ),
  );
}

Widget dashedContainer(Color color) {
  return Container(
    width: 50,
    height: 2,
    decoration: BoxDecoration(
      color: color,
    ),
  );
}
