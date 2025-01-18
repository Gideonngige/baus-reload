import 'package:baustaka/model/file.dart';
import 'package:baustaka/ui/_/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FilePreviewWidget extends StatelessWidget {
  final List<File> files;
  final int initialPosition;

  const FilePreviewWidget({
    super.key,
    required this.files,
    this.initialPosition = 0,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: PageView(
          controller: PageController(
            initialPage: initialPosition,
          ),
          children: List.generate(
            files.length,
            (index) {
              var file = files[index];

              return Stack(
                children: [
                  Positioned.fill(
                    child: PhotoView.customChild(
                      child: Center(
                        child: ImageWidget(
                          file: file,
                        ),
                      ),
                    ),
                  ),
                  if ((files.length) > 1)
                    Positioned(
                      top: 124,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            child: Text(
                              '${index + 1}/${files.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );
}
