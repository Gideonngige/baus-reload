import 'package:flutter/material.dart';

class KeyboardWidget extends StatelessWidget {
  final Widget child;

  const KeyboardWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: child,
      );
}
