import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget extends GetResponsiveView<ProfileController> {
  final String? action;

  ProfileWidget({
    super.key,
    this.action,
  });

  @override
  String get tag => Util.tag();

  @override
  ProfileController get controller => Get.put(
        ProfileController(
          action: action,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update your profile',
          ),
        ),
        body: KeyboardWidget(
          child: ListView(
            children: [
              const ListTile(
                title: Text('Hi there!'),
                subtitle: Text(
                  'Set your display name and username',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  'Your display name',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  decoration: kInputDecoration.copyWith(
                    hintText: 'John Doe',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  onChanged: (value) => controller.map['displayName'] = value,
                  keyboardType: TextInputType.name,
                  controller: TextEditingController(
                    text: controller.map['displayName'],
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  'Username',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  decoration: kInputDecoration.copyWith(
                    hintText: 'john.doe',
                    prefixText: '@',
                  ),
                  onChanged: (value) => controller.map['username'] = value,
                  keyboardType: TextInputType.text,
                  controller: TextEditingController(
                    text: controller.map['username'],
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  maxLength: 64,
                ),
              ),
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        'About',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: TextField(
                        decoration: kInputDecoration.copyWith(
                          hintText: 'Just something about you or your work...',
                        ),
                        onChanged: (value) =>
                            controller.map['description'] = value,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        maxLength: 360,
                        controller: TextEditingController(
                          text: controller.map['description'],
                        ),
                      ),
                    ),
                  ],
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
              if (action == 'register') ...[
                const SizedBox(
                  height: 32,
                ),
                TextButton(
                  onPressed: () async {
                    await Session.logout();
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Palette.textPrimary),
                  ),
                )
              ],
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      );
}
