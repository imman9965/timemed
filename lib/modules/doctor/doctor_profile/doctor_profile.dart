import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../theme/doctor_theme.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.inputBgSoft,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 30, left: 16, right: 16, bottom: 24),
              decoration: const BoxDecoration(
                color: DoctorColors.primaryBrand,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            "DOCTOR PROFILE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 14),

                  /// Doctor Info Row
                  // Row(
                  //   children: [
                  //     const CircleAvatar(
                  //       radius: 28,
                  //       backgroundColor: Colors.white,
                  //       child: Icon(Icons.person, size: 30),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     const Expanded(
                  //       child: Text(
                  //         "Dr Mariappan",
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //         ),
                  //       ),
                  //     ),
                  //     // Container(
                  //     //   decoration: BoxDecoration(
                  //     //     border: Border.all(color: Colors.white),
                  //     //     shape: BoxShape.circle,
                  //     //   ),
                  //     //   child: IconButton(
                  //     //     onPressed: () {},
                  //     //     icon: const Icon(Icons.logout, color: Colors.white),
                  //     //   ),
                  //     // )
                  //   ],
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PROFILE CARD
            _profileCard(context),

            const SizedBox(height: 12),

            /// CONTACT ROW
            _doubleCard(Icons.call, "8870182838",
                Icons.message, "WhatsApp"),

            const SizedBox(height: 12),

            _doubleCard(Icons.email, "mariappan@gmail.com",
                Icons.key, "123456"),

            const SizedBox(height: 16),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DoctorColors.warningOrange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _showChangePasswordDialog(context);
                },
                child: const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// HOSPITAL CARD
            _doubleCard(Icons.local_hospital, "Sangamithra Hospital",
                Icons.call, "8870182838"),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔵 BLUE HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: DoctorColors.blue800,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /// ⚪ WHITE CONTENT
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    /// New Password
                    TextField(
                      controller: newController,
                      obscureText: true,
                      decoration: InputDecoration(

                        labelText: "New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    //
                    // const SizedBox(height: 12),
                    //
                    // /// Confirm Password
                    // TextField(
                    //   controller: confirmController,
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     labelText: "Confirm Password",
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 16),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DoctorColors.blue800,
                            ),
                            onPressed: () {
                              if (newController.text != confirmController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Passwords do not match")),
                                );
                                return;
                              }

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Password changed successfully")),
                              );
                            },
                            child:  Text("Update",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  /// 🔹 PROFILE CARD
  Widget _profileCard(BuildContext context) {
    return Container(
      height: 170,
      width: context.width/1.1,
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      // padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          SizedBox(height: 10),
          Text(
            "Dr Mariappan",
            style: TextStyle(
              fontSize: 18,
              color: DoctorColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("MBBS"),
        ],
      ),
    );
  }

  /// 🔹 DOUBLE CARD
  Widget _doubleCard(
      IconData icon1, String text1,
      IconData icon2, String text2) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon1, color: DoctorColors.warningOrange),
          const SizedBox(width: 8),
          Expanded(child: Text(text1)),
          Container(width: 1, height: 30, color: DoctorColors.dividerNeutral),
          const SizedBox(width: 8),
          Icon(icon2, color: DoctorColors.success),
          const SizedBox(width: 8),
          Expanded(child: Text(text2)),
        ],
      ),
    );
  }
}