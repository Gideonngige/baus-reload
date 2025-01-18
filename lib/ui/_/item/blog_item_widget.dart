import 'dart:ui';

import 'package:baustaka/config/asset.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BlogItemWidget extends StatelessWidget {
  final Blog blog;
  final Function blogLike;

  const BlogItemWidget({
    super.key,
    required this.blog,
    required this.blogLike,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Get.toNamed('${Routes.kBlog}${blog.id}'),
      child: Container(
        height: 350,
        margin: const EdgeInsets.only(bottom: 25.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            if (blog.files != null && blog.files!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FileWidget(
                  files: blog.files,
                ),
              ),
            Column(
              children: [
                Expanded(child: Container()),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(kDefaultRadius),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      color: Colors.black.withOpacity(.3),
                      padding: const EdgeInsets.all(kDefaultRadius),
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: const BoxDecoration(
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
                          const SizedBox(width: 4),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog.title ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => blogLike(),
                                      icon: Icon(
                                        blog.blogLiked!
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      label: Text(
                                        blog.blogLiked!
                                            ? (blog.blogLikes! +
                                                    (blog.blogLiked == true
                                                        ? 0
                                                        : 1))
                                                .toString()
                                            : blog.blogLikes.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async => await Get.toNamed(
                                          '${Routes.kBlog}${blog.id}'),
                                      icon: const Icon(
                                        Icons.mode_comment_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      label: Text(
                                        blog.blogs.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
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
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      blog.user!.firstName.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color:
                                                  Colors.white.withOpacity(.9)),
                                    ),
                                    const Gap(3),
                                    Text(
                                      '|',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white.withOpacity(.9),
                                          ),
                                    ),
                                    const Gap(3),
                                    Text(
                                      Util.formatDate(blog.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color:
                                                  Colors.white.withOpacity(.9)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
