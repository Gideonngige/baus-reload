import 'package:baustaka/config/theme.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData iconData;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final double? size;
  final double? radius;
  //final Color color;
  final Widget? child;

  const IconWidget(
    this.iconData, {
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.size,
    this.radius,
    this.child,
    //this.color = Palette.primary,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width ?? 48,
          height: height ?? 48,
          decoration: BoxDecoration(
            gradient: kLinearGradient,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(radius ?? kDefaultRadius),
          ),
          child: Center(
            child: child ??
                Icon(
                  iconData,
                  color: Colors.white,
                  size: size,
                ),
          ),
        ),
      );
}
