import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/item/post_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/posts/posts_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostsWidget extends ResponsiveWidget<PostsController> {
  final String? withProduct;

  PostsWidget({super.key, required this.withProduct});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'posts_controller $withProduct';

  @override
  PostsController get controller =>
      Get.put(PostsController(withProduct: withProduct), tag: tag);

  @override
  Widget? tablet() {
    return Scaffold(
      appBar: AppBar(
        title: Text(withProduct == 'yes' ? 'My subscriptions' : 'Pickups'),
        actions: [
          // if (withProduct == 'yes')
          //   IconButton(
          //     icon: const Icon(Icons.add),
          //     onPressed: () async {
          //       await Get.toNamed(
          //         Routes.kBooking,
          //         parameters: {
          //           'type': 'disposal',
          //           'withProduct': 'yes',
          //         },
          //       );
          //     },
          //   ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              controller.q = '';
              controller.fetch(true);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.q = '';
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
          child: Column(
            children: [
              Obx(() => controller.showSearch.isTrue
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) {
                                    controller.q = value;
                                    controller.fetch(true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()),
              Obx(
                () => Expanded(
                  child: controller.posts.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.posts.length,
                          itemBuilder: (context, index) {
                            final post = controller.posts[index];

                            return PostItemWidget(
                              post: post,
                            );
                          },
                        )
                      : ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48),
                                child: controller.isFetching.isTrue
                                    ? const CircularProgressIndicator()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/upcoming_pickup.png',
                                            fit: BoxFit.cover,
                                            width: 250,
                                          ),
                                          const Gap(30),
                                          Text(
                                            'No ${withProduct == 'yes' ? 'subscriptions' : 'pick ups'}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              color:
                                                  Colors.grey.withOpacity(.5),
                                            ),
                                          ),
                                          const Gap(10),
                                          SizedBox(
                                            width: MediaQuery.of(screen.context)
                                                    .size
                                                    .width *
                                                .4,
                                            child: OutlinedButton.icon(
                                              icon: Icon(
                                                Icons.add,
                                                color: kAppTheme.primaryColor,
                                              ),
                                              onPressed: () async {
                                                if (withProduct == 'yes') {
                                                  await Get.toNamed(
                                                    Routes.kBooking,
                                                    parameters: {
                                                      'type': 'disposal',
                                                      'withProduct': 'yes',
                                                    },
                                                  );
                                                } else {
                                                  await Get.toNamed(
                                                    Routes.kBooking,
                                                    parameters: {
                                                      'type': 'disposal',
                                                      'withProduct': 'no',
                                                    },
                                                  );
                                                }
                                              },
                                              label: Text(
                                                withProduct == 'yes'
                                                    ? 'subscribe'
                                                    : 'book pickup',
                                                style: TextStyle(
                                                  color: kAppTheme.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
