import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/waste_manager.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteManagerWidget extends StatelessWidget {
  final WasteManager wasteManager;
  final Function()? onUpdate;

  const WasteManagerWidget({
    super.key,
    required this.wasteManager,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async =>
            await Get.toNamed('${Routes.kWasteManager}${wasteManager.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(wasteManager.title ?? ''),
              subtitle: Text(wasteManager.description ?? ''),
            ),
            ListTile(
              title: const Text('Phone number'),
              subtitle: Text(wasteManager.phoneNumber ?? ''),
              trailing: const IconWidget(Icons.call),
              onTap: () async => Util.call(wasteManager.phoneNumber),
            ),
            ListTile(
              title: const Text(
                'Address',
              ),
              subtitle: Text(
                wasteManager.area ?? '',
              ),
              trailing: const IconWidget(Icons.directions),
              onTap: () async => Util.directions(wasteManager.lngLat),
            ),
            const SizedBox(
              height: 4,
            ),
            if ((wasteManager.files ?? []).isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: FilesWidget(
                  files: wasteManager.files ?? [],
                ),
              ),
            ],
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: OutlinedButton(
                onPressed: () async {
                  var result = await Get.toNamed(
                      '${Routes.kWasteManager}${wasteManager.id}');

                  if (result && onUpdate != null) onUpdate!();
                },
                child: const Text(
                  'View',
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
}
