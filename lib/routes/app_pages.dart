import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/modules/doctor/calendar/calendar_page.dart';
import 'package:timesmed_project/modules/patient/patient_signup_page/binding/patient_signup_binding.dart';

// Views
import 'package:timesmed_project/modules/splash/view/splash_view.dart';
import 'package:timesmed_project/modules/super/view/super_home_view.dart';

import 'package:timesmed_project/modules/patient/patient_login_page/view/patient_login_page.dart';
import 'package:timesmed_project/modules/patient/patient_login_page/view/patient_otp_page.dart';
import 'package:timesmed_project/modules/patient/patient_signup_page/view/patient_signup_page.dart';
import 'package:timesmed_project/modules/patient/paient_home_page/view/patient_home_page.dart';

import 'package:timesmed_project/modules/doctor/login/view/Doctor_login_page.dart';

// Bindings
import 'package:timesmed_project/routes/app_routes.dart';

import '../modules/doctor/call_page/call_page.dart';
import '../modules/doctor/doctor_basic_details/doctor_basic_details.dart';
import '../modules/doctor/doctor_login_page/view/login_page.dart';
import '../modules/doctor/hospital_list_doctor/hospital_list_based_on_doctor.dart';
import '../modules/doctor/medical_records/medical_records.dart';
import '../modules/doctor/schedule_appointment/schedule_appointment.dart';
import '../modules/doctor/schedule_appointment_list/schedule_appointmnet_list.dart';

import '../modules/patient/patient_main/binding/patient_main_binding.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.patientHome,

    /// 🔥 GLOBAL REDIRECT (optional auth check later)
    redirect: (context, state) {
      return null;
    },

    routes: [
      /// 🔹 AI Chat
      GoRoute(
        path: AppRoutes.aiChat,
        builder: (context, state) {
          final userType = state.extra as String? ?? 'patient';

          return AIChatPage(userType: userType);
        },
      ),

      /// 🔹 Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashView(),
      ),

      /// 🔹 Super Admin
      GoRoute(
        path: AppRoutes.superAdminHome,
        builder: (context, state) => SuperHomeView(),
      ),

      /// ================================
      /// 🔹 PATIENT
      /// ================================
      GoRoute(
        path: AppRoutes.patientLogin,
        builder: (context, state) {
          PatientLoginBinding().dependencies();
          return PatientLoginPage();
        },
      ),

      GoRoute(
        path: AppRoutes.patientOtp,
        builder: (context, state) {
          PatientLoginBinding().dependencies();
          return PatientOtpPage();
        },
      ),

      GoRoute(
        path: AppRoutes.patientSignup,
        builder: (context, state) {
          PatientSignupBinding().dependencies();
          return PatientSignupPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patientForgotPassword,
        builder: (context, state) {
          return PatientForgotPasswordPage();
        },
      ),

      GoRoute(
        path: AppRoutes.patientSelection,
        builder: (context, state) {
          return PatientSelectionPage();
        },
      ),

      GoRoute(
        path: AppRoutes.addPatient,
        builder: (context, state) {
          return PatientAddPage();
        },
      ),

      /// 🔥 Bottom Navigation Wrapper
      ShellRoute(
        builder: (context, state, child) {
          PatientMainBinding().dependencies();
          return PatientMainPage(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.patientHome,
            builder: (context, state) {
              PatientHomePageBinding().dependencies();
              return PatientHomePage();
            },
          ),

      /// ================================
      /// 🔹 DOCTOR
      /// ================================
      GoRoute(
        path: AppRoutes.doctorLogin,
        builder: (context, state) => LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.doctorHome,
        builder: (context, state) => CalendarScreen(),
      ),

      GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => CalendarScreen(),
      ),

      GoRoute(
        path: AppRoutes.hospitalList,
        name: AppRoutes.hospitalList,
        builder: (context, state) => HospitalListScreen(),
      ),

      GoRoute(
        path: AppRoutes.basicDetails,
        name: AppRoutes.basicDetails,
        builder: (context, state) => DoctorBasicDetailsScreen(),
      ),

      GoRoute(
        path: AppRoutes.rescheduleAppointment,
        name: AppRoutes.rescheduleAppointment,
        builder: (context, state) => ScheduleAppointmentScreen(),
      ),

      GoRoute(
        path: AppRoutes.scheduleAppointment,
        name: AppRoutes.scheduleAppointment,
        builder: (context, state) => ScheduledAppointmentListScreen(),
      ),

      GoRoute(
        path: AppRoutes.medicalRecords,
        name: AppRoutes.medicalRecords,
        builder: (context, state) => MedicalRecordsScreen(),
      ),


      GoRoute(
        path: AppRoutes.videoPage,
        name: AppRoutes.videoPage,
        builder: (context, state) => VideoCallScreen(),
      ),








    ],
  );
}
