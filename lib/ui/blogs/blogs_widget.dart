import 'package:baustaka/config/theme.dart';
import 'package:baustaka/ui/_/custom_searchbar.dart';
import 'package:baustaka/ui/_/item/blog_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/blogs/blogs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogsWidget extends ResponsiveWidget<BlogsController> {
  BlogsWidget({super.key});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'blogs_controller';

  @override
  BlogsController get controller => Get.put(BlogsController(), tag: tag);

  Future<void> openBottomSheet() async {
    return showModalBottomSheet(
        context: screen.context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 14),
                // drag handle bar
                Center(
                  child: Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Image.asset('assets/images/reward.png'),
                const TitleText(
                  text: 'Invite your friends',
                  color: Colors.black,
                  fontSize: 24,
                ),
                TitleText(
                  text: 'Get Rewarded',
                  color: kAppTheme.primaryColor,
                  fontSize: 20,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget? tablet() {
    return Scaffold(
      appBar: AppBar(
        title: const CustomSearchBar(
          hintText: 'Search...',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.whatshot,
              color: Colors.black,
            ),
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
                                child: Obx(
                                  () => TextField(
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      hintText: controller.tag.value != null
                                          ? 'Search in ${controller.tag.value}'
                                          : 'Search',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(fontSize: 14),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onChanged: (value) {
                                      controller.q = value;
                                      controller.fetch(true);
                                    },
                                  ),
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
                  child: controller.blogs.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(5.0),
                          itemCount: controller.blogs.length,
                          itemBuilder: (context, index) {
                            final blog = controller.blogs[index];

                            return BlogItemWidget(
                              blog: blog,
                              blogLike: () => controller.blogLikeBlog(blog.id!),
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
                                    : const Text('No blogs'),
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
