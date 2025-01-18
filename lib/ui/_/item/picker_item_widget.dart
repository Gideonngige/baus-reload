import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickerItemWidget extends StatelessWidget {
  final Picker picker;

  const PickerItemWidget({
    super.key,
    required this.picker,
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
            const SizedBox(
              height: 8,
            ),
            ListTile(
              title: Text(
                picker.user!.displayName!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(Util.formatPhoneNumber(picker.user!.phoneNumber)),
              onTap: () async => await Util.call(picker.user!.phoneNumber!),
              trailing: const Icon(Icons.call_outlined),
            ),
            ListTile(
              title: Text(
                picker.mode!.capitalize!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text('${picker.plate}'),
            ),
          ],
        ),
      );
}
