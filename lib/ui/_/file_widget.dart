import 'package:cached_network_image/cached_network_image.dart';
import 'package:baustaka/model/file.dart';
import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  final List<File>? files;
  final bool countVisible;

  const FileWidget({
    super.key,
    required this.files,
    this.countVisible = true,
  });

  @override
  Widget build(BuildContext context) => files == null || files!.isEmpty
      ? Container()
      : Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: files!.first.aspectRatio,
                child: CachedNetworkImage(
                  imageUrl: files!.first.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade50,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade50,
                  ),
                ),
              ),
            ),
            if (files!.first.type == 'video')
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white.withOpacity(0.8),
                  size: 48,
                ),
              ),
            if (files!.length > 1 && countVisible)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async => {},
                    icon: Text(
                      files!.length > 9 ? '9+' : '${files!.length}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
}
