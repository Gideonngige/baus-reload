import 'package:baustaka/ui/_/item/station_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/stations/stations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StationsWidget extends ResponsiveWidget<StationsController> {
  StationsWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'stations_controller';

  @override
  StationsController get controller => Get.put(StationsController(), tag: tag);

  @override
  Widget? desktop() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search station'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => controller.showSearch.toggle(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.q = '';
          controller.fetch(true);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.fetch(false);
            }
            return false;
          },
          child: Column(
            children: [
              Obx(() => controller.showSearch.isTrue
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) {
                                    controller.q = value;
                                    controller.fetch(true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    itemCount: controller.stations.length,
                    itemBuilder: (context, index) {
                      final station = controller.stations[index];

                      return StationItemWidget(
                        station: station,
                        trailing: ElevatedButton(
                          onPressed: () => Get.back(result: station),
                          child: const Text('Select'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
