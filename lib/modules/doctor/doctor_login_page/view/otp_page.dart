import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import '../controller/login_controller.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Verification"),

      backgroundColor: const Color(0xfff5f6f8),

      body: Obx(() {
        return AbsorbPointer(
          absorbing: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// 🔵 ICON (PREMIUM TOUCH)
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 TITLE
                const Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 8),

                /// 🔹 SUBTEXT
                Text(
                  "Enter the 6-digit code sent to your mobile number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),

                const SizedBox(height: 30),

                /// 🔵 OTP FIELD CARD
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 14,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Pinput(
                        controller: controller.otpController,
                        keyboardType: TextInputType.number,
                        length: 6,
                        onChanged: (_) => controller.otpError.value = '',

                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 56,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.black),
                          ),
                        ),

                        focusedPinTheme: PinTheme(
                          width: 50,
                          height: 56,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        submittedPinTheme: PinTheme(
                          width: 50,
                          height: 56,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      /// ❗ OTP ERROR (below the pin boxes)
                      Obx(() {
                        if (controller.otpError.value.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            controller.otpError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      /// 🔘 VERIFY BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          color: AppColors.primary,
                          title: "Verify OTP",
                          onPressed: controller.verifyOtp,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔁 RESEND TEXT
                TextButton(
                  onPressed: () {
                    // controller.resendOtp();
                  },
                  child: const Text(
                    "Didn't receive code? Resend",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔄 LOADING INDICATOR (INLINE, NO STACK)
                if (controller.isLoading.value)
                  Column(
                    children: const [
                      SizedBox(height: 10),
                      CircularProgressIndicator(strokeWidth: 2),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
