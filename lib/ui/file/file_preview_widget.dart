import 'package:baustaka/model/file.dart';
import 'package:baustaka/ui/_/image_widget.dart';
import 'package:flutter/material.dart';

class FilePreviewWidget extends StatelessWidget {
  final File file;

  const FilePreviewWidget({
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
            child: ImageWidget(
              file: file,
            ),
          ),
        ),
      );
}
