import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/rewards/rewards_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RewardsWidget extends ResponsiveWidget<RewardsController> {
  RewardsWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'rewards';

  @override
  RewardsController get controller => Get.put(RewardsController(), tag: tag);

  final List<Map<String, dynamic>> _rewardsList = [
    {
      'title': 'Account Creation',
      'date': 'August 7 2021',
      'time': '7:03pm',
      'points': '10'
    },
    {
      'title': 'Waste Disposal',
      'date': 'August 7 2021',
      'time': '7:03pm',
      'points': '5'
    },
    {
      'title': 'Referrals',
      'date': 'August 7 2021',
      'time': '7:03pm',
      'points': '20'
    },
    {
      'title': 'Referrals',
      'date': 'August 7 2021',
      'time': '7:03pm',
      'points': '10'
    },
    {
      'title': 'Promotion',
      'date': 'August 7 2021',
      'time': '7:03pm',
      'points': '25'
    }
  ];

  @override
  Widget? tablet() => Obx(
        () => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
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
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  color: Colors.black,
                );
              },
            ),
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
          body: RefreshIndicator(
            onRefresh: () async {
              controller.fetch(true);
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  controller.fetch(false);
                }
                return false;
              },
              child: controller.rewards.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.rewards.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => Get.toNamed(Routes.kPointsBalance),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  height: 180,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: kAppTheme.primaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const TitleText(
                                                text: 'Green Guru',
                                                color: Colors.white,
                                                fontSize: 35,
                                              ),
                                              const Gap(15),
                                              Text.rich(
                                                TextSpan(
                                                  text:
                                                      '${controller.stateController.user?.points ?? 0} points ',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                  children: const [
                                                    TextSpan(
                                                      text: '(level 1)',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
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
                                                      color: kAppTheme
                                                          .primaryColor,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                ),
                              ),
                              ...List.generate(
                                _rewardsList.length,
                                (index) => ListTile(
                                  title: TitleText(
                                    text: _rewardsList[index]['title'],
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  subtitle: Text.rich(
                                    TextSpan(
                                      text: "${_rewardsList[index]['date']},  ",
                                      style: const TextStyle(
                                          color: Colors.black54),
                                      children: [
                                        TextSpan(
                                          text: _rewardsList[index]['time'],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 140,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "+${_rewardsList[index]['points']} points",
                                          style: TextStyle(
                                            color: kAppTheme.primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Image.asset('assets/images/medal.png'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(80),
                              Container(
                                width: MediaQuery.of(context).size.width * .9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Get.toNamed(Routes.kRedeemReward);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
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
                            ],
                          );
                        } else {
                          return null;
                        }
                      }
                      // : RewardItemWidget(
                      //     reward: controller.rewards[index - 1],
                      //   ),
                      )
                  : ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: controller.isFetching.isTrue
                                ? const CircularProgressIndicator()
                                : const Text('No rewards'),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
}


 // Container(
                                //   padding: const EdgeInsets.all(16),
                                //   margin: const EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey.shade200,
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(8)),
                                //   ),
                                //   child: const Text(
                                //     'Summary',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // Container(
                                //   padding: const EdgeInsets.all(16),
                                //   margin: const EdgeInsets.symmetric(
                                //     horizontal: 16,
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       const Expanded(
                                //         child: Text(
                                //           'Points',
                                //           style: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //           ),
                                //         ),
                                //       ),
                                //       Container(
                                //         margin: const EdgeInsets.symmetric(
                                //             horizontal: 16),
                                //         child: Text(
                                //           controller.user.value!.points
                                //               .toString(),
                                //           style: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //             color: Theme.of(screen.context)
                                //                 .primaryColor,
                                //           ),
                                //         ),
                                //       ),
                                //       ElevatedButton(
                                //         onPressed: () async {
                                //           await Get.toNamed(Routes.kPromotions);
                                //         },
                                //         child: const Text('Redeem'),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Container(
                                //   padding: const EdgeInsets.all(16),
                                //   margin: const EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey.shade200,
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(8)),
                                //   ),
                                //   child: const Text(
                                //     'Rewards',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                // ),