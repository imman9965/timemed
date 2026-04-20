import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/modules/patient/patient_signup_page/controller/patient_signup_controller.dart';

class PatientSignupPage extends StatelessWidget {
  PatientSignupPage({super.key});
  final patientSignUPController = Get.find<PatientSignupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// TITLE
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SignUp",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Please sign up to continue."),
                    ],
                  ),
                ),
              ),

              /// INPUTS
              const SizedBox(height: 25),

              TitleTextFormField(
                title: "Name",
                hintText: 'Enter Your Name',
                controller: patientSignUPController.nameController,
                borderRadius: 25,
                prefixIcon: const Icon(Icons.person),
              ),

              const Space(height: 12),

              TitleTextFormField(
                title: "Email",
                hintText: 'Enter Your Email',
                controller: patientSignUPController.emailController,
                prefixIcon: const Icon(Icons.email),
                borderRadius: 25,
              ),

              const Space(height: 20),

              TitleTextFormField(
                title: "Mobile Number",
                hintText: 'Enter Your Mobile Number',
                controller: patientSignUPController.phoneNumberController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                prefixIcon: const Icon(Icons.phone),
                borderRadius: 25,
              ),
              const Space(height: 12),

              /// DOB
              TitleTextFormField(
                title: "Date of Birth",
                hintText: 'Enter Your Date of Birth',
                controller: patientSignUPController.dobController,
                prefixIcon: const Icon(Icons.calendar_today),
                borderRadius: 25,
              ),

              const Space(height: 12),

              TitleTextFormField(
                title: "Password",
                hintText: 'Enter Your Password',
                controller: patientSignUPController.passwordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock),
                borderRadius: 25,
              ),

              const Space(height: 12),

              TitleTextFormField(
                title: "Confirm Password",
                hintText: 'Confirm Your Password',
                controller: patientSignUPController.confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock),
                borderRadius: 25,
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0f674a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Register"),
                ),
              ),

              const SizedBox(height: 15),

              /// LOGIN TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have account? "),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xff0f674a),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
