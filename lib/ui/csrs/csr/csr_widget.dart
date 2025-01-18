import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/csrs/csr/csr_controller.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CsrWidget extends ResponsiveWidget<CsrController> {
  final String csrId;

  CsrWidget({
    super.key,
    required this.csrId,
  });

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => Util.tag(
        csrId: csrId,
      );

  @override
  CsrController get controller => Get.put(
        CsrController(
          csrId: csrId,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text(
            'CSR',
          ),
        ),
        body: RefreshIndicator(
          strokeWidth: 4,
          onRefresh: () async => await controller.fetch(
            refresh: true,
          ),
          child: Obx(
            () {
              var csr = controller.csr.value;

              if (csr == null) {
                return ListView(
                  children: [
                    EmptyWidget(
                      isEmpty: true,
                      isProgressing: controller.isFetching.isTrue,
                      isFailed: controller.isFailed.isTrue,
                      onPressed: () async => await controller.fetch(
                        refresh: true,
                      ),
                      onEmpty: () async => await controller.fetch(
                        refresh: true,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EmptyWidget(
                    isEmpty: controller.isFailed.isTrue ||
                        controller.isFetching.isTrue,
                    isProgressing: controller.isFetching.isTrue,
                    isFailed: controller.isFailed.isTrue,
                    onPressed: () async => await controller.fetch(
                      refresh: true,
                    ),
                    onEmpty: () async => await controller.fetch(
                      refresh: true,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if ((csr.files ?? []).isNotEmpty) ...[
                          FilesWidget(
                            files: csr.files ?? [],
                            radius: 0,
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
                        ListTile(
                          title: Text(csr.title ?? ''),
                          subtitle: Text(csr.description ?? ''),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
}
