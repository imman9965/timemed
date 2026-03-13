import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controller/patient_login_controller.dart';

class PatientOtpPage extends StatelessWidget {
  PatientOtpPage({super.key});

  final PatientLoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f674a),
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "OTP Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Pinput(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff0f674a)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff0f674a)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff0f674a)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0f674a),
                      ),
                      onPressed: controller.verifyOtp,
                      child: const Text("Verify OTP"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// LOADING OVERLAY
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox();
            }

            return Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
