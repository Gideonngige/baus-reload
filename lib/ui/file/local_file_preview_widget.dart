import 'dart:typed_data';

import 'package:flutter/material.dart';

class LocalFilePreviewWidget extends StatelessWidget {
  final Uint8List file;

  const LocalFilePreviewWidget({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.black12,
        ),
        body: SafeArea(
          child: Center(
            child: Image.memory(
              file,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
