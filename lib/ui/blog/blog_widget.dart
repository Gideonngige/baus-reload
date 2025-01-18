import 'package:baustaka/config/asset.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:baustaka/ui/_/item/blog_comment_item_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/blog/blog_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BlogWidget extends ResponsiveWidget<BlogController> {
  final String blogId;

  BlogWidget({super.key, required this.blogId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'blog $blogId';

  @override
  BlogController get controller =>
      Get.put(BlogController(blogId: blogId), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
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
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/vertical-dots.svg',
                width: 20,
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
            controller.fetch();
          },
          child: Obx(
            () {
              var blog = controller.blog.value;

              if (blog == null) {
                return ListView();
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.comments.length + 1,
                    itemBuilder: (context, index) => index == 0
                        ? SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (blog.files != null &&
                                    blog.files!.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(15.0),
                                      ),
                                    ),
                                    height: MediaQuery.of(screen.context)
                                            .size
                                            .height *
                                        .45,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(15.0),
                                      ),
                                      child: FileWidget(files: blog.files),
                                    ),
                                  ),
                                const Gap(20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kAppTheme.primaryColor),
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            Assets.imageLogo,
                                            width: 150,
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                      Column(
                                        children: [
                                          Text(
                                            blog.user?.displayName ?? '',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            '3 days ago',
                                            style: TextStyle(
                                                color: kAppTheme.hintColor),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    WidgetStateProperty.all(
                                                        Colors.black),
                                              ),
                                              onPressed: () {
                                                controller.blogLikeBlog(
                                                    controller.blog.value!);
                                              },
                                              icon: Icon(
                                                blog.blogLiked!
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 22,
                                              ),
                                              label: Text(
                                                blog.blogLiked!
                                                    ? (blog.blogLikes! +
                                                            (blog.blogLiked ==
                                                                    true
                                                                ? 0
                                                                : 1))
                                                        .toString()
                                                    : blog.blogLikes.toString(),
                                              ),
                                            ),
                                            TextButton.icon(
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    WidgetStateProperty.all(
                                                        Colors.black),
                                              ),
                                              onPressed: () async =>
                                                  await Get.toNamed(
                                                      '${Routes.kBlog}${blog.id}'),
                                              icon: const Icon(
                                                Icons.mode_comment_outlined,
                                                size: 22,
                                              ),
                                              label: Text(
                                                blog.blogs.toString(),
                                                style: const TextStyle(),
                                              ),
                                            ),
                                            TextButton.icon(
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    WidgetStateProperty.all(
                                                        Colors.black),
                                              ),
                                              onPressed: () async {
                                                try {
                                                  await Share.share(
                                                      'https://baustaka.co.ke/blog?blogId=${blog.id}');
                                                } catch (e) {
                                                  Util.toast(e);
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.share_outlined,
                                                size: 22,
                                              ),
                                              label: const Text(
                                                '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(.3),
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TitleText(
                                    text: blog.title!,
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                                const Gap(10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    blog.description!,
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10,
                                  ),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ...blog.tags!.map(
                                        (e) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            '#${e.capitalize}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(15),
                              ],
                            ),
                          )
                        : BlogCommentItemWidget(
                            blog: controller.comments[index - 1],
                            blogLike: () async => await controller
                                .blogLikeBlog(controller.comments[index - 1]),
                          ),
                  ),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          color: Colors.grey.withOpacity(.3),
          child: Row(
            children: [
              IconButton(
                onPressed: () => controller.pickImage(),
                icon: const Icon(Icons.attach_file_outlined),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: controller.textFieldController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Add Comment',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) => controller.message.value = value,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  FocusScope.of(screen.context).unfocus();
                  controller.add();
                },
                icon: controller.isAdding.isTrue
                    ? const SizedBox(
                        height: 16.0,
                        width: 16.0,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Palette.primary,
                      ),
              ),
            ],
          ),
        ),
      );
}


// SafeArea(
                    //   child: Container(
                    //     padding: const EdgeInsets.only(
                    //       // right: 16,
                    //       // top: 12.0,
                    //       bottom: 12.0,
                    //       // left: controller.file.value == null ? 6.0 : 12.0,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue.shade200,
                    //       borderRadius: const BorderRadius.vertical(
                    //         top: Radius.circular(8),
                    //       ),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         controller.file.value == null
                    //             ? IconButton(
                    //                 iconSize: 20.0,
                    //                 icon: const Icon(
                    //                   Icons.add_a_photo_outlined,
                    //                   color: Colors.black87,
                    //                 ),
                    //                 onPressed: () => controller.pickImage(),
                    //               )
                    //             : Stack(
                    //                 children: [
                    //                   Container(
                    //                     width: 60.0,
                    //                     height: 60.0,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                     ),
                    //                     child: ClipRRect(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       child: Image.file(
                    //                         controller.file.value!,
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     height: 60.0,
                    //                     width: 60.0,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(8),
                    //                       color: Colors.white,
                    //                       gradient: LinearGradient(
                    //                         begin: FractionalOffset.topCenter,
                    //                         end: FractionalOffset.bottomCenter,
                    //                         colors: [
                    //                           Colors.black.withOpacity(0.16),
                    //                           Colors.black.withOpacity(0.05),
                    //                           Colors.transparent,
                    //                         ],
                    //                         stops: const [0.0, 0.3, 1.0],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                     top: 6,
                    //                     right: 6,
                    //                     child: Material(
                    //                       color: Colors.purple,
                    //                       child: GestureDetector(
                    //                         onTap: () =>
                    //                             controller.file.value = null,
                    //                         child: CircleAvatar(
                    //                           // backgroundColor: Colors.white.withOpacity(0.16),
                    //                           backgroundColor: Colors.black
                    //                               .withOpacity(0.25),
                    //                           radius: 10.0,
                    //                           child: const Icon(
                    //                             Icons.close,
                    //                             color: Colors.white,
                    //                             size: 16.0,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //         Expanded(
                    //           child: ClipRRect(
                    //             child: TextField(
                    //               controller: controller.textFieldController,
                    //               keyboardType: TextInputType.multiline,
                    //               maxLines: null,
                    //               decoration: const InputDecoration(
                    //                 isCollapsed: true,
                    //                 hintText: 'Add comment',
                    //                 border: InputBorder.none,
                    //                 hintStyle: TextStyle(
                    //                   fontSize: 14.0,
                    //                 ),
                    //               ),
                    //               textCapitalization:
                    //                   TextCapitalization.sentences,
                    //               onChanged: (value) =>
                    //                   controller.message.value = value,
                    //             ),
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 16,
                    //         ),
                    //         IconButton(
                    //           iconSize: 20.0,
                    //           icon: controller.isAdding.isTrue
                    //               ? const SizedBox(
                    //                   height: 16.0,
                    //                   width: 16.0,
                    //                   child: CircularProgressIndicator(
                    //                     backgroundColor: Colors.white,
                    //                     strokeWidth: 2.0,
                    //                   ),
                    //                 )
                    //               : const Icon(
                    //                   Icons.send,
                    //                   color: Palette.primary,
                    //                 ),
                    //           onPressed: () {
                    //             FocusScope.of(screen.context).unfocus();
                    //             controller.add();
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),