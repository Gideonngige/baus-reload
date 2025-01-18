import 'package:flutter/material.dart';

class PlaceTypeWidget extends StatelessWidget {
  final String title, subtitle;
  final IconData iconData;
  final Function() onTap;
  final Color color;

  const PlaceTypeWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onTap,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Icon(
                iconData,
                color: color,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      );
}
