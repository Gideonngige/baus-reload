import 'package:baustaka/ui/_/item/event_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/events/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsWidget extends ResponsiveWidget<EventsController> {
  final String tags;

  EventsWidget({super.key, required this.tags});

  @override
  String get tag => 'events $tags';

  @override
  EventsController get controller =>
      Get.put(EventsController(tags: tags), tag: tag);

  @override
  Widget? tablet() => RefreshIndicator(
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
                            color: Colors.grey.shade200,
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
                                child: Obx(
                                  () => TextField(
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      hintText: controller.tag.value != null
                                          ? 'Search in ${controller.tag.value}'
                                          : 'Search',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(fontSize: 14),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onChanged: (value) {
                                      controller.q = value;
                                      controller.fetch(true);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () async =>
                                await controller.fetchPlace(screen.context),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical:
                                    controller.area.value == null ? 16 : 4,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      controller.area.value == null
                                          ? 'All places'
                                          : '${controller.area.value}',
                                    ),
                                  ),
                                  if (controller.area.value != null)
                                    const SizedBox(
                                      width: 16,
                                    ),
                                  if (controller.area.value != null)
                                    const Text(
                                      '~',
                                    ),
                                  if (controller.area.value != null)
                                    DropdownButton(
                                      value: controller.distance.value,
                                      onChanged: (value) async {
                                        controller.distance.value =
                                            value as int;

                                        await controller.fetch(true);
                                      },
                                      items: [
                                        5,
                                        10,
                                        20,
                                        50,
                                      ].map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text('$e km'),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )
                  : Container()),
              const SizedBox(height: 14),
              Obx(
                () => Expanded(
                  child: controller.events.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.events.length,
                          itemBuilder: (context, index) {
                            final event = controller.events[index];

                            return EventItemWidget(
                              event: event,
                            );
                          },
                        )
                      : ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48),
                                child: controller.isFetching.isTrue
                                    ? const CircularProgressIndicator()
                                    : Text('No $tags events'),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      );
}
