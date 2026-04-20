import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
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
import 'package:timesmed_project/modules/patient/patient_login_page/Binding/patient_login_binding.dart';
import 'package:timesmed_project/modules/patient/paient_home_page/binding/patient_home_page_binding.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,

    /// 🔥 GLOBAL REDIRECT (optional auth check later)
    redirect: (context, state) {
      return null;
    },

    routes: [
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
        builder: (context, state) => DoctorLoginPage(),
      ),

      /// ================================
      /// 🔹 ADMIN (add when ready)
      /// ================================

      /// ================================
      /// 🔹 PHARMACY (add when ready)
      /// ================================
    ],
  );
}
