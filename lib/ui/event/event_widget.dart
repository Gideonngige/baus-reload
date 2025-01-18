import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:baustaka/ui/_/item/partner_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/event/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class EventWidget extends ResponsiveWidget<EventController> {
  final String eventId;

  EventWidget({super.key, required this.eventId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'event $eventId';

  @override
  EventController get controller =>
      Get.put(EventController(eventId: eventId), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            color: Colors.black,
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.diversity_1_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                    const Gap(4),
                    Obx(() {
                      if (controller.event.value != null) {
                        return Text(
                          controller.event.value!.rsvpd!
                              ? (controller.event.value!.rsvps! +
                                      (controller.event.value!.rsvpd == true
                                          ? 0
                                          : 1))
                                  .toString()
                              : controller.event.value!.rsvps.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        );
                      } else {
                        return Container();
                      }
                    })
                  ],
                ),
              ),
            ),
            const Gap(10),
            GestureDetector(
              onTap: () async {
                try {
                  await Share.share(
                      'https://baustaka.co.ke/event?eventId=$eventId');
                } catch (e) {
                  Util.toast(e);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: Obx(
            () {
              var event = controller.event.value;

              if (event == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.files != null && event.files!.isNotEmpty)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          child: FileWidget(
                            files: event.files,
                          ),
                        ),
                      ),
                    const Gap(30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleText(
                            text: event.area!,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          const Icon(Icons.directions_outlined,
                              color: Colors.white),
                        ],
                      ),
                    ),
                    const Gap(30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleText(
                            text: Util.formatDate(event.date, withTime: true),
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          const Icon(Icons.calendar_month_outlined,
                              color: Colors.white),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      color: kAppTheme.hintColor.withOpacity(.1),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TitleText(
                        text: event.title!,
                        color: Colors.black,
                        fontSize: 26,
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        event.description!,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    const Gap(20),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...event.tags!.map(
                            (e) => Container(
                              margin: const EdgeInsets.only(right: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '#${e.capitalize}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (event.partners!.isNotEmpty) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'Partners',
                          style: Theme.of(screen.context).textTheme.bodySmall,
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: event.partners!
                            .map(
                              (e) => PartnerItemWidget(
                                partner: e,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: event.rsvpd!
                          ? OutlinedButton.icon(
                              onPressed: () {
                                controller.rsvpEvent();
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                size: 18,
                              ),
                              label: const Text(
                                'Remove event',
                              ),
                            )
                          : ElevatedButtonWidget(
                              onPressed: () {
                                controller.rsvpEvent();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle, color: Colors.white),
                                  Gap(5),
                                  Text(
                                    'Join Event',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ));
              }
            },
          ),
        ),
      );
}
