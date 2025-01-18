import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/champ.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChampWidget extends StatelessWidget {
  final Champ champ;
  final Function()? onUpdate;

  const ChampWidget({
    super.key,
    required this.champ,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async => await Get.toNamed('${Routes.kChamp}${champ.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(champ.title ?? ''),
              subtitle: Text(champ.description ?? ''),
            ),
            ListTile(
              title: const Text('Status'),
              subtitle: Text(champ.status?.capitalize ?? ''),
            ),
            ListTile(
              title: const Text(
                'Address',
              ),
              subtitle: Text(
                champ.area ?? '',
              ),
              trailing: const IconWidget(Icons.directions),
              onTap: () async => Util.directions(champ.lngLat),
            ),
            const SizedBox(
              height: 4,
            ),
            if ((champ.files ?? []).isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: FilesWidget(
                  files: champ.files ?? [],
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
                  var result = await Get.toNamed('${Routes.kChamp}${champ.id}');

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
