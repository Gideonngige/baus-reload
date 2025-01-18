import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/icon_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/champs/champ/champ_controller.dart';
import 'package:baustaka/ui/file/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChampWidget extends ResponsiveWidget<ChampController> {
  final String champId;

  ChampWidget({
    super.key,
    required this.champId,
  });

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => Util.tag(
        champId: champId,
      );

  @override
  ChampController get controller => Get.put(
        ChampController(
          champId: champId,
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
              var champ = controller.champ.value;

              if (champ == null) {
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
                        if ((champ.files ?? []).isNotEmpty) ...[
                          FilesWidget(
                            files: champ.files ?? [],
                            radius: 0,
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
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
