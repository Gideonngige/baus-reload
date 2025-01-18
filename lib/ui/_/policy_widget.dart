import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';

class PolicyWidget extends StatelessWidget {
  final TextSpan? leading;
  final TextAlign? textAlign;

  const PolicyWidget({
    super.key,
    this.leading,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => Text.rich(
      TextSpan(
        children: [
          if (leading != null) leading!,
          TextSpan(
            text: 'Terms of Service',
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await Util.url(kTermsUrl),
          ),
          const TextSpan(
            text: ' and ',
            style: TextStyle(
              color: Palette.textSecondary,
            ),
          ),
          TextSpan(
            text: 'Privacy Policy',
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await Util.url(kPolicyUrl),
          ),
        ],
      ),
      textAlign: textAlign ?? TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).primaryColor));
}
