import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/custom_keyboard.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/rewards/rewards_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RedeemWidget extends ResponsiveWidget<RewardsController> {
  RedeemWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'redeem';

  @override
  RewardsController get controller => Get.put(RewardsController(), tag: tag);

  final pointsTextController = TextEditingController();

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Get.back();
              },
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
            text: 'Rewards',
            color: kAppTheme.primaryColor,
            fontSize: 22,
          ),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(Routes.kBadgeGuide),
              icon: SvgPicture.asset(
                'assets/icons/information-bubble.svg',
                colorFilter:
                    const ColorFilter.mode(Palette.primary, BlendMode.srcIn),
                width: 30,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              color: Colors.black,
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: kAppTheme.primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(
                          text: 'Green Guru',
                          color: Colors.white,
                          fontSize: 35,
                        ),
                        const Gap(15),
                        Text.rich(
                          TextSpan(
                            text: '${controller.stateController.user?.points ?? 0} points',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            children: const [
                              TextSpan(
                                text: '(level 1)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 15,
                              decoration: BoxDecoration(
                                color: kAppTheme.primaryColor,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Image.asset('assets/images/medal.png'),
                ],
              ),
            ),
            const Gap(30),
            const Text(
              'Points to redeem',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(screen.context).size.width * .6,
              child: TextField(
                controller: pointsTextController,
                onChanged: (value) => controller.points = value,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.none,
                style: const TextStyle(fontSize: 40),
                decoration: InputDecoration(
                  hintText: '100',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(.5), fontSize: 40),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            Text(
              'Worth Ksh 160',
              style: TextStyle(
                fontSize: 20,
                color: kAppTheme.hintColor.withOpacity(.7),
              ),
            ),
            const Gap(20),
            SizedBox(
              width: MediaQuery.of(screen.context).size.width * .6,
              child: ElevatedButtonWidget(
                onPressed: () {},
                child: const Text('Redeem'),
              ),
            ),
            const Gap(100),
            CustomKeyboard(tController: pointsTextController)
          ],
        ),
      );
}
