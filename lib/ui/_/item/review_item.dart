import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/model/review.dart';
import 'package:baustaka/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewItemWidget extends StatelessWidget {
  final Review review;
  final User user;
  final Post post;

  const ReviewItemWidget(
      {super.key,
      required this.review,
      required this.user,
      required this.post});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0x33C4C4C4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  foregroundColor: Palette.primary,
                  radius: 12,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  user.displayName!,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: review.rating!,
                  minRating: 0,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 16,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  Util.formatDate(review.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(review.comment!),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${post.type}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}
