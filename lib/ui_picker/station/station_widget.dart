import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/item/availability_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/station/station_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StationWidget extends ResponsiveWidget<StationController> {
  final String stationId;

  StationWidget({super.key, required this.stationId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'station $stationId';

  @override
  StationController get controller =>
      Get.put(StationController(stationId: stationId), tag: tag);

  @override
  Widget? desktop() => Scaffold(
        appBar: AppBar(
          title: const Text('Transfer station'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: Obx(
            () {
              var station = controller.station.value;

              if (station == null) {
                return ListView();
              } else {
                return ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        color: station.status == 'blocked'
                            ? Colors.grey.shade50
                            : Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                '${station.status?.capitalize}',
                                style: const TextStyle(
                                  color: Palette.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListTile(
                            title: Text(
                              station.title ?? 'Unknown',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Text('${station.description}'),
                            onTap: () async => await Get.toNamed(
                                '${Routes.kStation}${station.id}'),
                          ),
                          ListTile(
                            title: Text(
                              'Area of operation',
                              style:
                                  Theme.of(screen.context).textTheme.bodySmall,
                            ),
                            subtitle: Text(
                              station.area ?? 'Unknown',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            onTap: () async =>
                                Util.directions(station.point!.coordinates!),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                            child: ListTile(
                              title: Text(
                                'Registered on',
                                style: Theme.of(screen.context)
                                    .textTheme
                                    .bodySmall,
                              ),
                              subtitle: Text(
                                Util.formatDate(
                                  station.createdAt,
                                  withTime: true,
                                ),
                                style: Theme.of(screen.context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Opening hours',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                    ),
                    Column(
                      children: station.availabilitys
                              ?.map(
                                (e) => AvailabilityItemWidget(
                                  availability: e,
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
}
