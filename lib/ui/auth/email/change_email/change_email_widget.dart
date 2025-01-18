import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/email/change_email/change_email_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeEmailWidget extends GetResponsiveView<ChangeEmailController> {
  ChangeEmailWidget({
    super.key,
  });

  @override
  String get tag => Util.tag();

  @override
  ChangeEmailController get controller => Get.put(
        ChangeEmailController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Change your email',
          ),
        ),
        body: KeyboardWidget(
          child: ListView(
            children: [
              const ListTile(
                title: Text('Hi there!'),
                subtitle: Text('Update your email'),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  decoration: kInputDecoration.copyWith(
                    hintText: 'john.doe@gmail.com',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  onChanged: (value) => controller.map['email'] = value,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  controller: TextEditingController(
                    text: controller.map['email'],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.add();
                  },
                  child: Obx(
                    () => controller.isAdding.isTrue
                        ? const ProgressWidget()
                        : const Text('Update'),
                  ),
                ),
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      );
}
