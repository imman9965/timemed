import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/doctor/schedule_appointment/schedule_appointment.dart' hide CurvedHeader;
import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../widgets/doctor_stamp.dart';
import '../../../routes/app_routes.dart';

class PatientScreenBlue extends StatelessWidget {
  const PatientScreenBlue({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          const CurvedHeader(title: "PATIENT LIST SCREEN", showBackButton: false,
            leading: DoctorBadge(doctor: "Dr.Mariappan"),
            titleStyle: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
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
            color: DoctorColors.primary.withOpacity(0.1),
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
                backgroundColor: DoctorColors.blue100,
                child: Icon(Icons.person, color: DoctorColors.primary),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: DoctorColors.primary, size: 20,)
            ],
          ),
          SizedBox(height: 10),
          Text("Age: $age, Male",
              style: TextStyle(color: DoctorColors.textMuted,fontSize: 12)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, color: DoctorColors.primary),
              SizedBox(width: 8),
              Text(email,
                style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              ),
            ],
          ),
          SizedBox(height: 6),

          Row(
            children: [
              Icon(Icons.phone, color: DoctorColors.primary),
              SizedBox(width: 8),
              Text(phone,style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
          Divider(height: 20),

          Text(
            "Target INR: $inr",
            style: TextStyle(
              fontSize: 12,
              color: DoctorColors.success,
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
          backgroundColor: DoctorColors.success,
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
          style: TextStyle(fontSize: 16,color: Colors.white),
        ),
      ),
    );
  }
}