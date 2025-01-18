import 'package:baustaka/config/mode.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_picker_controller.dart';

class AddPickerWidget extends ResponsiveWidget<AddPickerController> {
  AddPickerWidget({super.key});

  @override
  String get tag => 'add_picker';

  @override
  bool get shouldAdjust => true;

  @override
  AddPickerController get controller =>
      Get.put(AddPickerController(), tag: tag);

  @override
  Widget? desktop() => Scaffold(
        appBar: AppBar(
          title: const Text('Complete your registration'),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: const Text(
                'What vehicle are you using?',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...kModes.map(
                      (e) => GestureDetector(
                        onTap: () => controller.map.update((val) {
                          val?['mode'] = e;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: e == controller.map.value['mode']
                                ? Theme.of(screen.context).primaryColor
                                : Colors.grey.shade200,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            e.capitalize ?? '',
                            style: TextStyle(
                              color: e == controller.map.value['mode']
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'What is the plate number of the vehicle?',
                        border: InputBorder.none,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) =>
                          controller.map.value['plate'] = value,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Which is your transfer station of operation?',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  var station = await Get.toNamed(Routes.kStations);

                  if (station != null) controller.station.value = station;
                } catch (e) {
                  Util.toast(e);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Obx(
                        () => Text(controller.station.value?.title ??
                            'Search transfer station'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  right: 16, left: 16, top: 16, bottom: 32),
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.check()) {
                    await Get.dialog(
                      DialogWidget(
                        title: 'Complete Registration?',
                        content:
                            'You are about to register as a waste collector. Please confirm.',
                        onConfirm: () async {
                          await controller.add();
                        },
                        confirmText: 'Register',
                      ),
                    );
                  }
                },
                child: Obx(
                  () => controller.isAdding.isTrue
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text('Register'),
                ),
              ),
            ),
          ],
        ),
      );
}
