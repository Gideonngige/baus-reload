import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';

class BlogCommentItemWidget extends StatelessWidget {
  final Blog blog;
  final Function blogLike;

  const BlogCommentItemWidget(
      {super.key, required this.blog, required this.blogLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.grey.shade200,
            ),
            child: const SizedBox(
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      blog.user!.displayName!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        blogLike();
                      },
                      child: Text(
                        blog.blogLiked!
                            ? (blog.blogLikes! +
                                    (blog.blogLiked == true ? 0 : 1))
                                .toString()
                            : '(${blog.blogLikes})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        blogLike();
                      },
                      child: blog.blogLiked!
                          ? const Icon(
                              Icons.favorite,
                              color: Palette.primary,
                              size: 18,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 18,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (blog.files != null && blog.files!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: FileWidget(
                      files: blog.files,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
                Text(
                  blog.description!,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  Util.formatDate(
                    blog.createdAt,
                    withTime: true,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
