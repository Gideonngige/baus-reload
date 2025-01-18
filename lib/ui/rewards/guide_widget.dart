import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/rewards/rewards_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BadgeGuideWidget extends ResponsiveWidget<RewardsController> {
  BadgeGuideWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'reward guide';

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
            text: 'Badge Guide',
            color: kAppTheme.primaryColor,
            fontSize: 22,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                _guideItem(
                  screen.context,
                  'Your Path to Eco Achievement',
                  "Welcome to our Badge Guide! This is your journey towards becoming an eco-savvy champion. Here's what you need to know:",
                ),
                const Gap(20),
                _guideItemWithImage(
                  screen.context,
                  'Green Guru Badge: ',
                  'Start your green journey here. Earn this badge by completing the first set of eco-friendly actions. Remember, each step brings you closer to making a real difference.',
                  'assets/images/medal.png',
                ),
                const Gap(20),
                _guideItemWithImage(
                  screen.context,
                  'Eco Explore Badge: ',
                  "You're stepping up your game! To earn the Green Guru badge, build on your eco exploration. Complete more tasks and embrace sustainable living with enthusiasm.",
                  'assets/images/silver_medal.png',
                ),
                const Gap(20),
                _guideItemWithImage(
                  screen.context,
                  'Planet Protector Badge',
                  "Congratulations, you're a true eco-hero! The Planet Protector badge is the pinnacle of achievement. Only those who've truly embraced a green lifestyle can unlock this badge.",
                  'assets/images/trophy_cup.png',
                ),
                const Gap(20),
                _guideItem(
                  screen.context,
                  'Redeeming Points: ',
                  "As you complete badges, you'll earn points. Points can be redeemed exclusively into your app wallet. Use them for discounts on app services and Ecoshop purchases.",
                ),
              ],
            ),
          ),
        ),
      );

  Widget _guideItem(BuildContext context, String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
        ),
        const Gap(5),
        Text(
          info,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: kAppTheme.hintColor,
          ),
        ),
      ],
    );
  }

  Widget _guideItemWithImage(
      BuildContext context, String title, String info, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
            ),
            Image.asset(imagePath, width: 40),
          ],
        ),
        Text(
          info,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: kAppTheme.hintColor,
          ),
        ),
      ],
    );
  }
}
