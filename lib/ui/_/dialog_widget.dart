import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWidget extends ResponsiveWidget {
  @override
  bool get shouldAdjust => true;

  @override
  Color get background => Colors.transparent;

  final String title;
  final String content;
  final Function onConfirm;
  final String? hintText;
  final String? confirmText;
  final Function? onResend;
  final Function? onCancel;
  final Color? color;

  final TextEditingController? inputController;

  DialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.hintText,
    this.confirmText,
    this.onResend,
    this.onCancel,
    this.color,
    this.inputController,
  });

  @override
  Widget? tablet() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(screen.context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            ),
            const Divider(),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Text(
                  content,
                  style: Theme.of(screen.context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            inputController != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 16,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: hintText,
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          inputController!.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(
                          offset: value.length,
                        ),
                      ),
                      controller: inputController,
                    ),
                  )
                : Container(),
            if (onResend != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 16,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (Get.isDialogOpen!) Get.back();

                        onResend!();
                      },
                      child: const Text(
                        'Resend',
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () {
                        if (Get.isDialogOpen!) Get.back();

                        if (onCancel != null) {
                          onCancel!();
                        }
                      },
                      child: Text(
                        'Cancel',
                        style: color != null
                            ? TextStyle(color: color)
                            : const TextStyle(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (Get.isDialogOpen!) Get.back();

                        onConfirm();
                      },
                      style: color != null
                          ? ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(color),
                            )
                          : const ButtonStyle(),
                      child: Text(
                        confirmText ?? 'Confirm',
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
