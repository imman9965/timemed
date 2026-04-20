import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';

class PatientForgotPasswordPage extends StatefulWidget {
  const PatientForgotPasswordPage({super.key});

  @override
  State<PatientForgotPasswordPage> createState() =>
      _PatientForgotPasswordPageState();
}

class _PatientForgotPasswordPageState extends State<PatientForgotPasswordPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  int currentStep = 0; // 0: Phone, 1: OTP, 2: New Password

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: "Forgot Password", showBack: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48, // Account for padding
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      /// Progress Indicator
                      _buildProgressIndicator(),

                      const SizedBox(height: 32),

                      /// Step Content
                      Expanded(child: _buildStepContent()),

                      const SizedBox(height: 24),

                      /// Action Button
                      _buildActionButton(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressStep(0, "Phone"),
        _buildProgressLine(0),
        _buildProgressStep(1, "OTP"),
        _buildProgressLine(1),
        _buildProgressStep(2, "Password"),
      ],
    );
  }

  Widget _buildProgressStep(int step, String label) {
    bool isActive = currentStep >= step;
    bool isCompleted = currentStep > step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isActive ? null : Colors.grey.shade300,
              shape: BoxShape.circle,
              border: isActive
                  ? null
                  : Border.all(color: Colors.grey.shade400, width: 2),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : step == 0
                  ? Icons.phone
                  : step == 1
                  ? Icons.lock_clock
                  : Icons.lock,
              color: isActive ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? const Color(0xff0673de) : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine(int step) {
    return Container(
      height: 2,
      width: 40,
      color: currentStep > step
          ? const Color(0xff0673de)
          : Colors.grey.shade300,
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildPhoneStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildPasswordStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPhoneStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff0673de).withOpacity(0.1),
                const Color(0xff2f6f7e).withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.phone_android,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter Your Phone Number",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We'll send an OTP to reset your password",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TitleTextFormField(
                title: "Phone Number",
                hintText: 'Enter your registered phone number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                prefixIcon: const Icon(Icons.phone, color: Color(0xff0673de)),
                borderRadius: 12,
                fillColor: Colors.white,
                filled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff0673de).withOpacity(0.1),
                const Color(0xff2f6f7e).withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lock_clock,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We sent a 6-digit code to ${phoneController.text}",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TitleTextFormField(
                title: "OTP Code",
                hintText: 'Enter 6-digit OTP',
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xff0673de),
                ),
                borderRadius: 12,
                fillColor: Colors.white,
                filled: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Resend OTP logic
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff0673de),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff0673de).withOpacity(0.1),
                const Color(0xff2f6f7e).withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your new password must be different from previous",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TitleTextFormField(
                title: "New Password",
                hintText: 'Enter new password',
                controller: newPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Color(0xff0673de)),
                borderRadius: 12,
                fillColor: Colors.white,
                filled: true,
              ),
              const SizedBox(height: 16),
              TitleTextFormField(
                title: "Confirm Password",
                hintText: 'Confirm new password',
                controller: confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xff0673de),
                ),
                borderRadius: 12,
                fillColor: Colors.white,
                filled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    String buttonText;
    VoidCallback onPressed;

    switch (currentStep) {
      case 0:
        buttonText = "Send OTP";
        onPressed = () {
          if (phoneController.text.isNotEmpty) {
            setState(() {
              currentStep = 1;
            });
          }
        };
        break;
      case 1:
        buttonText = "Verify OTP";
        onPressed = () {
          if (otpController.text.length == 6) {
            setState(() {
              currentStep = 2;
            });
          }
        };
        break;
      case 2:
        buttonText = "Reset Password";
        onPressed = () {
          if (newPasswordController.text.isNotEmpty &&
              confirmPasswordController.text.isNotEmpty &&
              newPasswordController.text == confirmPasswordController.text) {
            // Reset password logic
            context.pop();
            Get.snackbar(
              "Success",
              "Password reset successfully!",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        };
        break;
      default:
        buttonText = "Continue";
        onPressed = () {};
    }

    return CommonButton(
      title: buttonText,
      onPressed: onPressed,
      height: 50,
      color: AppColors.primary,
      borderRadius: 12,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
