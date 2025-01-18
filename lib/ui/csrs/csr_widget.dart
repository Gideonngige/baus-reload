import 'package:baustaka/config/routes.dart';
import 'package:baustaka/model/csr.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CsrWidget extends StatelessWidget {
  final Csr csr;
  final Function()? onUpdate;

  const CsrWidget({
    super.key,
    required this.csr,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async => await Get.toNamed('${Routes.kCsr}${csr.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(csr.title ?? ''),
              subtitle: Text(csr.description ?? ''),
            ),
            const SizedBox(
              height: 4,
            ),
            if ((csr.files ?? []).isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: FilesWidget(
                  files: csr.files ?? [],
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
                  var result = await Get.toNamed('${Routes.kCsr}${csr.id}');

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
