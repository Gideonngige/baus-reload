import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/cbo.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CboWidget extends StatelessWidget {
  final Cbo cbo;
  final Function()? onUpdate;

  const CboWidget({
    super.key,
    required this.cbo,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async => await Get.toNamed('${Routes.kCbo}${cbo.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(cbo.title ?? ''),
              subtitle: Text(cbo.description ?? ''),
            ),
            ListTile(
              title: const Text('Status'),
              subtitle: Text(cbo.status?.capitalize ?? ''),
            ),
            ListTile(
              title: const Text(
                'Address',
              ),
              subtitle: Text(
                cbo.area ?? '',
              ),
              trailing: const IconWidget(Icons.directions),
              onTap: () async => Util.directions(cbo.lngLat),
            ),
            const SizedBox(
              height: 4,
            ),
            if ((cbo.files ?? []).isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: FilesWidget(
                  files: cbo.files ?? [],
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
                  var result = await Get.toNamed('${Routes.kCbo}${cbo.id}');

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
