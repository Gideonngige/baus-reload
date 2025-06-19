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
  String get tag => 'redemption';

  @override
  RewardsController get controller => Get.put(RewardsController(), tag: tag);

  // Reactive variable for redemption amount
  final RxInt redemptionAmount = 0.obs;

  // Points to Ksh conversion rate (you can adjust this based on your business logic)
  static const double pointsToKshRate = 0.1; // 1 point = 0.1 Ksh

  // Helper method to calculate Ksh value
  double calculateKshValue(int points) {
    return points * pointsToKshRate;
  }

  // Helper method to increase redemption amount
  void increaseAmount() {
    final userPoints = controller.stateController.user?.points ?? 0;
    if (redemptionAmount.value < userPoints) {
      redemptionAmount.value++;
    }
  }

  // Helper method to decrease redemption amount
  void decreaseAmount() {
    if (redemptionAmount.value > 0) {
      redemptionAmount.value--;
    }
  }

  @override
  Widget? tablet() => Obx(
        () => Scaffold(
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
                      'Your point balance is ${controller.stateController.user?.points ?? 0} worth Ksh ${calculateKshValue(controller.stateController.user?.points ?? 0).toStringAsFixed(2)}. How many to be redeemed?',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: increaseAmount,
                      child: Container(
                        width: 40,
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          '${redemptionAmount.value}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: decreaseAmount,
                      child: Container(
                        width: 40,
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: const Center(
                          child: Text(
                            '-',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                    'Worth Ksh ${calculateKshValue(redemptionAmount.value).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: kAppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(30),
                Center(
                  child: Container(
                    width: MediaQuery.of(screen.context).size.width * .5,
                    height: 80,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: redemptionAmount.value > 0
                              ? [
                                  const Color.fromARGB(255, 58, 148, 61),
                                  const Color.fromARGB(255, 70, 197, 75),
                                ]
                              : [
                                  Colors.grey.shade400,
                                  Colors.grey.shade500,
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: kAppTheme.primaryColor),
                    child: ElevatedButton(
                      onPressed: redemptionAmount.value > 0
                          ? () {
                              showDialog(
                                  context: screen.context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Confirm Redemption',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'You are about to redeem ${redemptionAmount.value} points worth Ksh ${calculateKshValue(redemptionAmount.value).toStringAsFixed(2)}. This will create a discount coupon for your next purchase.\n\nDo you want to proceed?',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            ElevatedButtonWidget(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                _processRedemption();
                                              },
                                              child: const Text(
                                                'Redeem',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        redemptionAmount.value > 0 ? 'Redeem' : 'Select Amount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                const Gap(20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Text(
                        'No coupons available yet.\nRedeem points to create discount coupons.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  // Process the actual redemption (placeholder for future implementation)
  void _processRedemption() {
    // TODO: Implement actual redemption logic with API call
    // For now, show a success message
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Redemption Successful!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: Text(
            'You have successfully redeemed ${redemptionAmount.value} points worth Ksh ${calculateKshValue(redemptionAmount.value).toStringAsFixed(2)}.\n\nA discount coupon has been created for your account.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Center(
              child: ElevatedButtonWidget(
                onPressed: () {
                  Navigator.of(context).pop();
                  redemptionAmount.value = 0; // Reset redemption amount
                  Get.back(); // Go back to previous screen
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
