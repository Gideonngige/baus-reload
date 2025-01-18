import 'package:baustaka/config/images.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/ui/_/image_widget.dart';
import 'package:baustaka/ui/files/web/file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAvatarWidget extends StatelessWidget {
  final User? user;
  final double size;

  double get radius => size / 2;
  double get radiusDepth1 => radius - (user?.hasStorys == true ? 3 : 0);

  double get radiusDepth2 => radius - (user?.hasStorys == true ? 5 : 0);

  const UserAvatarWidget({
    super.key,
    required this.user,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: user?.avatar != null
            ? () async => await Get.to(
                  () => FilePreviewWidget(
                    files: [user!.avatar!],
                  ),
                )
            : null,
        child: CircleAvatar(
          radius: radius,
          backgroundColor:
              user?.hasStorys == true ? Colors.grey.shade300 : Colors.white,
          backgroundImage: user?.hasNotViewedStorys == true
              ? const AssetImage(
                  Images.kIcLauncherBackground,
                )
              : null,
          child: CircleAvatar(
            radius: radiusDepth1,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: radiusDepth2,
              child: SizedBox.square(
                dimension: radiusDepth2 * 2,
                child: ClipOval(
                  child: ImageWidget(
                    file: user?.avatar,
                    placeholder: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: radiusDepth2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
