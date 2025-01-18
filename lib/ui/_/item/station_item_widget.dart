import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/station.dart';
import 'package:flutter/material.dart';

class StationItemWidget extends StatelessWidget {
  final Station station;
  final Widget? trailing;

  const StationItemWidget({
    super.key,
    required this.station,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                station.title!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text('${station.description}'),
              trailing: trailing,
            ),
            ListTile(
              title: Text(
                'Area of operation',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                station.area!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () async => Util.directions(station.point!.coordinates!),
            ),
          ],
        ),
      );
}
