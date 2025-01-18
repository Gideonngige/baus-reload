import 'package:baustaka/model/reward.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardItemWidget extends GetResponsiveView {
  final Reward reward;

  RewardItemWidget({super.key, required this.reward});

  @override
  Widget? tablet() => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: ListTile(
          title: Text(
            reward.points! > 0
                ? 'You have been awarded points'
                : 'You have redeemed your points',
            style: Theme.of(screen.context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            reward.type!.capitalize!,
          ),
          trailing: Text(
            reward.points.toString(),
            style: TextStyle(
              fontWeight:
                  reward.points! > 0 ? FontWeight.bold : FontWeight.normal,
              color: reward.points! > 0
                  ? Theme.of(screen.context).primaryColor
                  : Theme.of(screen.context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      );
}
