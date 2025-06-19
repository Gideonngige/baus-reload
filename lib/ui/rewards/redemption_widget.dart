import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/rewards/rewards_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RedemptionWidget extends ResponsiveWidget<RewardsController> {
  RedemptionWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'points balance';

  @override
  RewardsController get controller => Get.put(RewardsController(), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.chevron_left,
                size: 30,
                color: kAppTheme.primaryColor,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              color: Colors.black,
            );
          }),
          title: TitleText(
            text: 'Redemption',
            color: kAppTheme.primaryColor,
            fontSize: 22,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Redemption Rules',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
              ),
              SizedBox(
                width: MediaQuery.of(screen.context).size.width * .8,
                child: Text(
                  'Create a discount coupon and use during checkout',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: kAppTheme.hintColor,
                  ),
                ),
              ),
              const Gap(60),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(screen.context).size.width * .8,
                  child: Text(
                    'Your point balance is ${controller.stateController.user?.points ?? 0} worth Ksh 240. How many to be redeemed?',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 90,
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${controller.stateController.user?.points ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Gap(20),
              Center(
                child: Text(
                  'Worth Ksh 160',
                  style: TextStyle(
                    fontSize: 20,
                    color: kAppTheme.hintColor.withOpacity(.7),
                  ),
                ),
              ),
              const Gap(30),
              Center(
                child: Container(
                  width: MediaQuery.of(screen.context).size.width * .5,
                  height: 80,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 58, 148, 61),
                          Color.fromARGB(255, 70, 197, 75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: kAppTheme.primaryColor),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: screen.context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                'You have successfully redeemed ${controller.stateController.user?.points ?? 0} points. You have received Ksh 160. Check balance for confirmation',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              actions: [
                                Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    child: ElevatedButtonWidget(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Ok',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Ink(
                      child: const Text(
                        'Redeem',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(30),
              const Text(
                'Your coupons',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
              ),
            ],
          ),
        ),
      );
}
