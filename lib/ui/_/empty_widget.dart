import 'package:baustaka/config/messages.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final bool isProgressing;
  final bool isFailed;
  final bool isEmpty;
  final String? emptyText, failedText;
  final Function()? onPressed;
  final Function()? onEmpty;
  final Color? color;
  final TextStyle? textStyle;

  const EmptyWidget({
    super.key,
    required this.isEmpty,
    this.emptyText,
    this.failedText,
    required this.isProgressing,
    required this.isFailed,
    required this.onPressed,
    required this.onEmpty,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (isEmpty) ...[
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: TextButton(
                onPressed: !isProgressing && !isFailed ? onEmpty : onPressed,
                child: isProgressing
                    ? ProgressWidget(
                        color: color ?? Palette.primary,
                      )
                    : Text(
                        isFailed
                            ? failedText ?? 'Oops! Retry'
                            : isEmpty
                                ? emptyText ?? 'Nothing found'
                                : 'Retry',
                        textAlign: TextAlign.center,
                        style:
                            textStyle ?? Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (isFailed) ...[
              OutlinedButton(
                onPressed: onPressed,
                child: Text(failedText == Messages.kLogin
                    ? 'Log in or register'
                    : failedText == Messages.kRegister
                        ? 'Complete now'
                        : failedText == Messages.kVerifyAccount
                            ? 'Verify account'
                            : 'Retry'),
              ),
              const SizedBox(
                height: 16,
              ),
            ]
          ],
        ],
      );
}
