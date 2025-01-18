import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PhoneNumberWidget extends ResponsiveWidget<BookingController> {
  final String type;
  final String withProduct;

  RxInt characterCount = 0.obs;

  PhoneNumberWidget(this.type, this.withProduct, {super.key});

  @override
  String get tag => 'booking $type $withProduct';

  @override
  BookingController get controller => Get.put(
        BookingController(
          type: type,
          withProduct: withProduct,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                Get.back();
              },
            ),
            title: TitleText(
              color: controller.color,
              text: 'Payment',
              fontSize: 23,
            ),
            bottom: TabBar(
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(color: Colors.green),
              tabs: [
                Tab(
                  icon: Image.asset('assets/images/mpesa_logo.png', width: 70),
                ),
                const Tab(
                  icon: Row(
                    children: [
                      Icon(
                        Icons.wallet,
                      ),
                      Gap(5),
                      Text(
                        'Wallet',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const Tab(
                  icon: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                      ),
                      Gap(5),
                      Text(
                        'CARD',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _mpesaTabContainer(screen.context),
              _walletTabContainer(),
              _cardTabContainer(),
            ],
          ),
        ),
      );

  Widget _mpesaTabContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Phone Number',
              children: [
                TextSpan(text: '*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const Gap(10),
          Obx(
            () => TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) {
                characterCount.value = val.length;
                controller.phoneNumber.text = val;
              },
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: TextStyle(color: kAppTheme.hintColor),
                suffix: characterCount.value != 10
                    ? const Icon(Icons.error, color: Colors.red)
                    : const Icon(Icons.check, color: Colors.green),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kAppTheme.hintColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kAppTheme.hintColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: ElevatedButtonWidget(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Save & Exit'),
              ),
            ),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _walletTabContainer() {
    return const Column(
      children: [
        Text('wallet'),
      ],
    );
  }

  Widget _cardTabContainer() {
    return const Column(
      children: [
        Text('card'),
      ],
    );
  }
}
