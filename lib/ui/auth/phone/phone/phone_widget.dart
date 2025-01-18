import 'package:baustaka/config/images.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/keyboard_widget.dart';
import 'package:baustaka/ui/auth/phone/phone/phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneWidget extends GetResponsiveView<PhoneController> {
  PhoneWidget({super.key});

  @override
  String get tag => 'phone';

  @override
  PhoneController get controller => Get.put(
        PhoneController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: KeyboardWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 360 / 320,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Images.kImgTopBanner),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      heightFactor: 2,
                      child: SizedBox(
                        width: 176,
                        child: Image.asset(Images.kImgBannerLogo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    'Enter your phone number',
                    style: Theme.of(screen.context).appBarTheme.titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    'We will send you a verification code',
                    textAlign: TextAlign.center,
                    style: Theme.of(screen.context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(
                  height: 32,
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
                        controller.phoneNumber = value.completeNumber,
                    keyboardType: TextInputType.number,
                    initialCountryCode: 'KE',
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
                      await controller.signIn();
                    },
                    child: const Text(
                      'Send code',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      );
}
