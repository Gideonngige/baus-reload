import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnknownWidget extends GetResponsiveView {
  UnknownWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Center(
                  child: Text(
                    'Oops!',
                    style: Theme.of(screen.context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(
                          color: Palette.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Center(
                  child: Text(
                    'Wrong turn. Route not found',
                    style: Theme.of(screen.context).appBarTheme.titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
                ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  ),
                  child: Text('Go home'),
                ),
                ),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
      );
}
