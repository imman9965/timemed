import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/core/constants/sapce.dart';
import 'package:timesmed_project/core/constants/title_Text_form_field.dart';

class PatientSignupPage extends StatelessWidget {
  PatientSignupPage({super.key});

  final name = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      body: Column(
        children: [
          /// 🔥 UNIQUE APP BAR HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0f674a), Color(0xff179f77)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                /// BACK BUTTON
                InkWell(
                  onTap: () => Get.back(),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back, color: Color(0xff0f674a)),
                  ),
                ),

                const SizedBox(width: 15),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Join TimesMed as a Patient",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// FORM
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: ListView(
                  children: [
                    TitleTextFormField(
                      title: "Name",
                      hintText: 'Enter Your Name',
                      controller: name,
                      prefixIcon: const Icon(Icons.person),
                    ),

                    const Space(height: 20),

                    TitleTextFormField(
                      title: "Mobile Number",
                      hintText: 'Enter Your Mobile Number',
                      controller: mobile,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      prefixIcon: const Icon(Icons.phone),
                    ),

                    const Space(height: 12),

                    TitleTextFormField(
                      title: "Email",
                      hintText: 'Enter Your Email',
                      controller: email,
                      prefixIcon: const Icon(Icons.email),
                    ),

                    const Space(height: 12),

                    TitleTextFormField(
                      title: "Password",
                      hintText: 'Enter Your Password',
                      controller: password,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),

                    const Space(height: 12),

                    TitleTextFormField(
                      title: "Confirm Password",
                      hintText: 'Confirm Your Password',
                      controller: confirmPassword,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                    ),

                    const SizedBox(height: 30),

                    /// REGISTER BUTTON
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0f674a),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed("/patientOtp");
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// LOGIN OPTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have account? "),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xff0f674a),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
