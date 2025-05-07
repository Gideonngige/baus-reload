import 'package:baustaka/ui/auth/email/link_email/link_email_controller.dart';
import 'package:baustaka/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinkEmailScreen extends StatelessWidget {
  final controller = Get.put(LinkEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Email to Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Link Email to Your Account',
                style: Get.textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              Text(
                'Add an email to your account so you can sign in without SMS verification in the future.',
                style: Get.textTheme.bodyMedium,
              ),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.email = value,
              ),
              SizedBox(height: 16),
              Obx(() => TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        controller.obscureText.value = !controller.obscureText.value,
                    icon: Icon(
                      controller.obscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: controller.obscureText.value,
                onChanged: (value) => controller.password = value,
              )),
              SizedBox(height: 16),
              Obx(() => TextField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        controller.obscureText.value = !controller.obscureText.value,
                    icon: Icon(
                      controller.obscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: controller.obscureText.value,
                onChanged: (value) => controller.confirmPassword = value,
              )),
              SizedBox(height: 32),
              Obx(() => Button(
                onPressed: controller.linkEmail,
                text: 'Link Email to Account',
                isLoading: controller.isLinking.value,
              )),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}