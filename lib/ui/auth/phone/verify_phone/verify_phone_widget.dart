import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/auth/phone/verify_phone/verify_phone_controller.dart';
import 'package:baustaka/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneWidget extends StatelessWidget {
  final String phoneNumber;
  final String? action;
  
  VerifyPhoneWidget({
    required this.phoneNumber,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with parameters
    final controller = Get.put(
      VerifyPhoneController(
        phoneNumber: phoneNumber,
        token: Get.arguments?['token'] ?? '',
        hasEmail: Get.arguments?['hasEmail'] ?? false,
      ),
    );
    
    return Scaffold(
      appBar: AppBar(title: Text('Verify Phone')),
      body: Obx(() {
        if (controller.showEmailLinkForm.isTrue) {
          return _buildEmailLinkForm(controller);
        }
        return _buildVerificationForm(controller);
      }),
    );
  }

  Widget _buildVerificationForm(VerifyPhoneController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify your phone',
            style: Get.textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'We sent a verification code to ${controller.phoneNumber}',
            style: Get.textTheme.bodyMedium,
          ),
          SizedBox(height: 32),
          PinCodeTextField(
            appContext: Get.context!,
            length: 6,
            onChanged: (value) => controller.smsCode = value,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
              activeColor: Get.theme.primaryColor,
              inactiveColor: Colors.grey,
              selectedColor: Get.theme.primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Obx(() => controller.seconds.value > 0
              ? Text(
                  'Resend code in ${controller.seconds.value} seconds',
                  style: Get.textTheme.bodySmall,
                )
              : GestureDetector(
                  onTap: controller.resendOtp,
                  child: Text(
                    'Resend code',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          SizedBox(height: 32),
          Button(
            onPressed: controller.signIn,
            text: 'Verify',
            isLoading: controller.isSigningIn.value,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailLinkForm(VerifyPhoneController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Link Email to Your Account',
            style: Get.textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
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
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: (value) => controller.password = value,
          ),
          SizedBox(height: 32),
          Button(
            onPressed: controller.linkEmail,
            text: 'Link Email & Continue',
            isLoading: controller.emailLinkingInProgress.value,
          ),
          SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: controller.skipEmailLinking,
              child: Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }
}