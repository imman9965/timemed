import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../../../routes/app_routes.dart';

class PatientScreenBlue extends StatelessWidget {
  const PatientScreenBlue({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF5F9FF),
        body: Column(
          children: [
            const CurvedHeader(title: "Patient Register"),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildPatientCard(
                    name: "Vijay G",
                    age: "36",
                    phone: "8056567194",
                    email: "vijayguru173@gmail.com",
                    inr: "5.0 - 2.0",
                  ),
                  _buildPatientCard(
                    name: "Aravind A",
                    age: "25",
                    phone: "9551917102",
                    email: "aravind@gmail.com",
                    inr: "2 - 3",
                  ),
                  _buildPatientCard(
                    name: "Aravind A",
                    age: "25",
                    phone: "9551917102",
                    email: "aravind@gmail.com",
                    inr: "2 - 3",
                  ),
                  _buildButton(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPatientCard({
    required String name,
    required String age,
    required String phone,
    required String email,
    required String inr,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, color: Colors.blue),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.blue)
            ],
          ),
          SizedBox(height: 10),
          Text("Age: $age, Male",
              style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, color: Colors.blue),
              SizedBox(width: 8),
              Text(email),
            ],
          ),
          SizedBox(height: 6),

          Row(
            children: [
              Icon(Icons.phone, color: Colors.blue),
              SizedBox(width: 8),
              Text(phone),
            ],
          ),
          Divider(height: 20),

          Text(
            "Target INR: $inr",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade200,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.push(AppRoutes.addPatientScreen);
        },
        child: Text(
          "Add Patient Registration",
          style: TextStyle(fontSize: 16,color: Colors.black),
        ),
      ),
    );
  }
}