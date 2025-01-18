import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/hash_tag.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/message.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/user_avatar_widget.dart';
import 'package:baustaka/ui/files/web/files_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool showDate;

  const MessageWidget({
    super.key,
    required this.message,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async => {},
        child: message.user?.isSelf == true ? _self(context) : _other(context),
      );

  _self(BuildContext context) => Column(
        children: [
          if (showDate) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                Util.formatDate(
                  message.createdAt,
                  withTime: false,
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
          if (message.files?.isNotEmpty == true) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 96,
                  ),
                  Flexible(
                    child: FilesWidget(
                      files: message.files ?? [],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
          if (message.location != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 96,
                  ),
                  Flexible(
                    child: MapWidget(
                      key: Key(message.id ?? ''),
                      onTap: (latLng) async =>
                          await Util.directions(message.location?.coordinates),
                      initialLatLng: message.location?.latLng,
                      onMapCreated: (updateMap) {
                        updateMap(
                          message.location?.latLng,
                          showCircles: true,
                          showMarkers: false,
                          radius: kDefaultRadius,
                          withZoom: kZoomForMarker,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 96,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      gradient: kLinearGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kDefaultRadius),
                        topRight: Radius.circular(kDefaultRadius),
                        bottomLeft: Radius.circular(kDefaultRadius),
                        bottomRight: Radius.circular(kDefaultRadius / 4),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: SelectableLinkify(
                              text: message.description ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              linkStyle: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                decoration: TextDecoration.none,
                              ),
                              options: const LinkifyOptions(
                                looseUrl: true,
                              ),
                              linkifiers: const [
                                UrlLinkifier(),
                                EmailLinkifier(),
                                PhoneNumberLinkifier(),
                                UserTagLinkifier(),
                                HashTagLinkifier(),
                              ],
                              onOpen: (link) async {
                                if (link is UrlElement) {
                                  Util.url(link.url);
                                }

                                if (link is EmailElement) {
                                  Util.url(link.url);
                                }

                                if (link is PhoneNumberElement) {
                                  Util.url(link.url);
                                }

/*
                                if (link is UserTagElement) {
                                  await Get.toNamed(
                                      '${Routes.kUser}${link.text.substring(1).toLowerCase()}');
                                }

                                if (link is HashTagElement) {
                                  await Get.toNamed(
                                      '${Routes.kSearch}?q=${link.text.substring(1)}');
                                }
                                */
                              },
                              contextMenuBuilder:
                                  (context, editableTextState) =>
                                      AdaptiveTextSelectionToolbar.editableText(
                                editableTextState: editableTextState,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '  ${Util.formatDate(
                              message.createdAt,
                              timeOnly: true,
                            )}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  _other(BuildContext context) => Column(
        children: [
          if (showDate) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                Util.formatDate(
                  message.createdAt,
                  withTime: false,
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
          if (message.files?.isNotEmpty == true) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Flexible(
                    child: FilesWidget(
                      files: message.files ?? [],
                    ),
                  ),
                  const SizedBox(
                    width: 64,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
          if (message.location != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Flexible(
                    child: MapWidget(
                      key: Key(message.id ?? ''),
                      onTap: (latLng) async =>
                          await Util.directions(message.location?.coordinates),
                      initialLatLng: message.location?.latLng,
                      onMapCreated: (updateMap) {
                        updateMap(
                          message.location?.latLng,
                          showCircles: true,
                          showMarkers: false,
                          radius: kDefaultRadius,
                          withZoom: kZoomForMarker,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 64,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async => {},
                  child: UserAvatarWidget(
                    user: message.user,
                    size: 32,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kDefaultRadius),
                        topRight: Radius.circular(kDefaultRadius),
                        bottomRight: Radius.circular(kDefaultRadius),
                        bottomLeft: Radius.circular(kDefaultRadius / 4),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: SelectableLinkify(
                              text: message.description ?? '',
                              linkStyle: const TextStyle(
                                color: Palette.primary,
                                decoration: TextDecoration.none,
                              ),
                              options: const LinkifyOptions(
                                looseUrl: true,
                              ),
                              linkifiers: const [
                                UrlLinkifier(),
                                EmailLinkifier(),
                                PhoneNumberLinkifier(),
                                UserTagLinkifier(),
                                HashTagLinkifier(),
                              ],
                              onOpen: (link) async {
                                if (link is UrlElement) {
                                  Util.url(link.url);
                                }

                                if (link is EmailElement) {
                                  Util.url(link.url);
                                }

                                if (link is PhoneNumberElement) {
                                  Util.url(link.url);
                                }
/*
                                if (link is UserTagElement) {
                                  await Get.toNamed(
                                      '${Routes.kUser}${link.text.substring(1).toLowerCase()}');
                                }

                                if (link is HashTagElement) {
                                  await Get.toNamed(
                                      '${Routes.kSearch}?q=${link.text.substring(1)}');
                                }
                                */
                              },
                              contextMenuBuilder:
                                  (context, editableTextState) =>
                                      AdaptiveTextSelectionToolbar.editableText(
                                editableTextState: editableTextState,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '  ${Util.formatDate(
                              message.createdAt,
                              timeOnly: true,
                            )}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 64,
                ),
              ],
            ),
          ),
        ],
      );
}
