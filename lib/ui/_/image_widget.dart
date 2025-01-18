import 'package:baustaka/helper/session.dart';
import 'package:baustaka/model/file.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

class ImageWidget extends StatelessWidget {
  final File? file;
  final BoxFit fit;
  final Widget? placeholder;

  const ImageWidget({
    super.key,
    required this.file,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) => OctoImage(
        image: CachedNetworkImageProvider(
          file?.urlThumbnail ?? '',
          headers: Session.cachedHeaders(),
        ),
        placeholderBuilder: (context) => file?.hash != null
            ? SizedBox.expand(
                child: Image(
                  image: BlurHashImage(file?.hash ?? ''),
                  fit: fit,
                ),
              )
            : Container(
                color: Colors.grey.shade100,
                child: placeholder,
              ),
        errorBuilder: (context, error, stackTrace) => file?.hash != null
            ? SizedBox.expand(
                child: Image(
                  image: BlurHashImage(file?.hash ?? ''),
                  fit: fit,
                ),
              )
            : Container(
                color: Colors.grey.shade100,
                child: placeholder,
              ),
        fit: fit,
      );
}
