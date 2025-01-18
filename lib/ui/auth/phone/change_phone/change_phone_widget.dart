import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/auth/phone/change_phone/change_phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ChangePhoneWidget extends GetResponsiveView<ChangePhoneController> {
  ChangePhoneWidget({
    super.key,
  });

  @override
  String get tag => Util.tag();

  @override
  ChangePhoneController get controller => Get.put(
        ChangePhoneController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Change your phone number'),
        ),
        body: KeyboardWidget(
          child: ListView(
            children: [
              const ListTile(
                title: Text('Hi there!'),
                subtitle: Text(
                  'Update your phone number',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: IntlPhoneField(
                  decoration: kInputDecoration.copyWith(
                    hintText: '707240021',
                  ),
                  onChanged: (value) =>
                      controller.map['phoneNumber'] = value.completeNumber,
                  keyboardType: TextInputType.number,
                  initialCountryCode:
                      controller.stateController.user?.countryIso2 ?? 'KE',
                  initialValue: controller.stateController.user?.phoneNumber
                      ?.substring(controller
                              .stateController.user?.countryCode?.length ??
                          1),
                  dropdownTextStyle:
                      Theme.of(screen.context).textTheme.titleMedium,
                  disableLengthCheck: true,
                  textAlignVertical: TextAlignVertical.center,
                  pickerDialogStyle: PickerDialogStyle(
                    searchFieldInputDecoration: kInputDecoration.copyWith(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search country...',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    listTileDivider: const SizedBox.shrink(),
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
                        : const Text('Next'),
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
