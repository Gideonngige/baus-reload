import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/availability.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailabilityItemWidget extends StatelessWidget {
  final Availability availability;
  final Widget? trailing;

  const AvailabilityItemWidget({
    super.key,
    required this.availability,
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
          children: [
            ListTile(
              title: Text(
                Util.formatDate(availability.from),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${availability.frequency!.capitalize} ${Util.formatDate(availability.from, timeOnly: true)} - ${Util.formatDate(availability.from, timeOnly: true)}',
              ),
              trailing: trailing,
            ),
          ],
        ),
      );
}
