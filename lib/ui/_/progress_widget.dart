import 'package:baustaka/config/palette.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final Color color;
  final EdgeInsets margin;
  final double size;
  final double? value;
  final bool showValue;
  final bool visible;
  final bool circular;

  const ProgressWidget({
    super.key,
    this.color = Colors.white,
    this.margin = EdgeInsets.zero,
    this.size = 18,
    this.value,
    this.showValue = true,
    this.visible = true,
    this.circular = true,
  });

  @override
  Widget build(BuildContext context) => visible
      ? Container(
          height: size,
          width: size,
          margin: margin,
          child: circular
              ? stack(context)
              : ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: stack(context),
                ),
        )
      : Container();

  Widget stack(BuildContext context) => Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: circular
                ? CircularProgressIndicator(
                    color: value != null
                        ? Palette.primary.withOpacity(0.5)
                        : color,
                    value: value == null ? value : value! / 100,
                  )
                : LinearProgressIndicator(
                    color: color,
                    value: value == null ? value : value! / 100,
                  ),
          ),
          if (showValue && value != null && value! > 0) ...[
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundColor: Palette.primary.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${value!.toInt()}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Palette.primary,
                                  ),
                        ),
                        TextSpan(
                          text: '%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Palette.primary,
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ]
        ],
      );
}
