import 'package:baustaka/config/fonts.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UsernameWidget extends StatelessWidget {
  final User? user;
  final Color? colorPrimary, colorSecondary;

  const UsernameWidget({
    super.key,
    required this.user,
    this.colorPrimary,
    this.colorSecondary,
  });

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: user?.displayName ?? '',
              style: TextStyle(
                fontFamily: Fonts.kBold,
                color: colorPrimary,
              ),
              recognizer: TapGestureRecognizer()..onTap = () async => {},
            ),
            if (user?.verified == true)
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 2,
                  ),
                  child: Icon(
                    Icons.verified,
                    color: colorPrimary ?? Palette.primary,
                    size: 18,
                  ),
                ),
                alignment: PlaceholderAlignment.middle,
              ),
            TextSpan(
              text: ' @${user?.username ?? ''}',
              style: TextStyle(
                color: colorSecondary ?? Palette.textSecondary,
              ),
              recognizer: TapGestureRecognizer()..onTap = () async => {},
            ),
          ],
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
}
