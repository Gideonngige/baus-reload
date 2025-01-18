import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/rewards/rewards_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PointsBalanceWidget extends ResponsiveWidget<RewardsController> {
  PointsBalanceWidget({super.key});

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
            text: 'Rewards',
            color: kAppTheme.primaryColor,
            fontSize: 22,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch(true);
          },
          child: Column(
            children: [
              Container(
                color: kAppTheme.primaryColor,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const TitleText(
                          text: 'My Balance',
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        const Gap(30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/dollar_coin.png'),
                            Column(
                              children: [
                                const Text(
                                  'Points',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 231, 11)),
                                ),
                                const Gap(10),
                                Text(
                                  '${controller.user.value?.points}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 231, 11)),
                                ),
                              ],
                            ),
                            const Gap(10),
                            const Text(
                              '=',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 231, 11)),
                            ),
                            const Gap(10),
                            Image.asset('assets/images/debit_card.png'),
                            const Gap(10),
                            const Column(
                              children: [
                                Text(
                                  'Ksh',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 231, 11)),
                                ),
                                Gap(10),
                                Text(
                                  '240',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 231, 11)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset('assets/images/trophy_cup_large.png')
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.black,
                        indicator: BoxDecoration(),
                        tabs: [
                          Tab(
                            child: Text(
                              'History',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Badges',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _historyContainer(),
                            _badgeContainer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(screen.context).size.width * .5,
                child: ElevatedButtonWidget(
                  onPressed: () => Get.toNamed(Routes.kRedemption),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Redeem',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Gap(30),
                      Icon(
                        Icons.east,
                        size: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              const Gap(60),
            ],
          ),
        ),
      );

  Widget _historyContainer() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 19),
          ),
          ...List.generate(
            5,
            (index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: kAppTheme.primaryColor,
                child:
                    const Icon(Icons.autorenew, color: Colors.white, size: 30),
              ),
              title: const Text(
                'Converted to Ksh',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
              ),
              subtitle: const Text(
                'August 7 2021, 7:03pm',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              ),
              trailing: SizedBox(
                width: 100,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '+1248',
                      style: TextStyle(
                        color: kAppTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Gap(10),
                    Image.asset('assets/images/dollar_coin.png'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _badgeContainer() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(.3),
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      offset: Offset(1, 4),
                    ),
                  ]),
              child: ListTile(
                leading: Image.asset('assets/images/bronze.png'),
                title: const Text.rich(
                  TextSpan(
                    text: 'Bronze ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: '(level 1)',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    Stack(
                      children: [
                        Container(
                          width: 180,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: kAppTheme.hintColor.withOpacity(.4),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 10,
                          decoration: BoxDecoration(
                            color: kAppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'completed',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: kAppTheme.hintColor,
                      ),
                    ),
                  ],
                ),
                trailing: Image.asset('assets/images/medal.png', width: 50),
              ),
            ),
          )
        ],
      ),
    );
  }
}
