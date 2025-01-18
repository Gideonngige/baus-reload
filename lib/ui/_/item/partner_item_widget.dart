import 'package:baustaka/model/partner.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';

class PartnerItemWidget extends StatelessWidget {
  final Partner partner;
  final Widget? trailing;

  const PartnerItemWidget({
    super.key,
    required this.partner,
    this.trailing,
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
        child: Column(
          children: [
            ListTile(
              leading: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  child: FileWidget(
                    files: partner.files,
                  ),
                ),
              ),
              title: Text(
                partner.title!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                '${partner.description}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: trailing,
            ),
          ],
        ),
      );
}
