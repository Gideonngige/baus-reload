import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/cbos/cbo/cbo_controller.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CboWidget extends ResponsiveWidget<CboController> {
  final String cboId;

  CboWidget({
    super.key,
    required this.cboId,
  });

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => Util.tag(
        cboId: cboId,
      );

  @override
  CboController get controller => Get.put(
        CboController(
          cboId: cboId,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text(
            'CBO',
          ),
        ),
        body: RefreshIndicator(
          strokeWidth: 4,
          onRefresh: () async => await controller.fetch(
            refresh: true,
          ),
          child: Obx(
            () {
              var cbo = controller.cbo.value;

              if (cbo == null) {
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
                        if ((cbo.files ?? []).isNotEmpty) ...[
                          FilesWidget(
                            files: cbo.files ?? [],
                            radius: 0,
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
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
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: MapWidget(
                            onMapCreated: (updateMap) async {
                              controller.updateMap = updateMap;

                              controller.updateLocation();
                            },
                          ),
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
