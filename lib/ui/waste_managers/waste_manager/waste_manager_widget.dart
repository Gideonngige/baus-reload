import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:baustaka/ui/waste_managers/waste_manager/waste_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteManagerWidget extends ResponsiveWidget<WasteManagerController> {
  final String wasteManagerId;

  WasteManagerWidget({
    super.key,
    required this.wasteManagerId,
  });

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => Util.tag(
        wasteManagerId: wasteManagerId,
      );

  @override
  WasteManagerController get controller => Get.put(
        WasteManagerController(
          wasteManagerId: wasteManagerId,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text(
            'waste manager',
          ),
        ),
        body: RefreshIndicator(
          strokeWidth: 4,
          onRefresh: () async => await controller.fetch(
            refresh: true,
          ),
          child: Obx(
            () {
              var wasteManager = controller.wasteManager.value;

              if (wasteManager == null) {
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
                        if ((wasteManager.files ?? []).isNotEmpty) ...[
                          FilesWidget(
                            files: wasteManager.files ?? [],
                            radius: 0,
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
                        ListTile(
                          title: Text(wasteManager.title ?? ''),
                          subtitle: Text(wasteManager.description ?? ''),
                        ),
                        ListTile(
                          title: const Text('Phone number'),
                          subtitle: Text(wasteManager.phoneNumber ?? ''),
                          trailing: const IconWidget(Icons.call),
                          onTap: () async =>
                              Util.call(wasteManager.phoneNumber),
                        ),
                        ListTile(
                          title: const Text(
                            'Address',
                          ),
                          subtitle: Text(
                            wasteManager.area ?? '',
                          ),
                          trailing: const IconWidget(Icons.directions),
                          onTap: () async =>
                              Util.directions(wasteManager.lngLat),
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
