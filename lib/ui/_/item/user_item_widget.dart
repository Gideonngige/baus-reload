import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/user.dart';
import 'package:flutter/material.dart';

class UserItemWidget extends StatelessWidget {
  final User user;
  final bool showRegistered;

  const UserItemWidget({
    super.key,
    required this.user,
    this.showRegistered = true,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: ListTile(
          title: Text(
            user.displayName!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: showRegistered
              ? Text(Util.formatPhoneNumber(user.phoneNumber))
              : null,
        ),
      );
}
