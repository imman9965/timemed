import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/ai_chat/view/ai_chat_page.dart';
import 'package:timesmed_project/modules/patient/paient_home/binding/patient_home_page_binding.dart';
import 'package:timesmed_project/modules/patient/paient_home/view/patient_home_page.dart';
import 'package:timesmed_project/modules/patient/patient_add/view/patient_add_page.dart';
import 'package:timesmed_project/modules/patient/patient_login/Binding/patient_login_binding.dart';
import 'package:timesmed_project/modules/patient/patient_login/view/patient_forgot_password_page.dart';
import 'package:timesmed_project/modules/patient/patient_login/view/patient_login_page.dart';
import 'package:timesmed_project/modules/patient/patient_login/view/patient_otp_page.dart';
import 'package:timesmed_project/modules/patient/patient_main/view/patient_main_page.dart';
import 'package:timesmed_project/modules/patient/patient_order/view/patient_order_page.dart';
import 'package:timesmed_project/modules/patient/patient_profile/view/patient_profile_page.dart';
import 'package:timesmed_project/modules/patient/patient_select/view/patient_selection_page.dart';
import 'package:timesmed_project/modules/patient/patient_signup/binding/patient_signup_binding.dart';
import 'package:timesmed_project/modules/patient/patient_signup/view/patient_signup_page.dart';

// Views
import 'package:timesmed_project/modules/splash/view/splash_view.dart';
import 'package:timesmed_project/modules/super/view/super_home_view.dart';

import 'package:timesmed_project/modules/doctor/login/view/Doctor_login_page.dart';

// Bindings
import 'package:timesmed_project/routes/app_routes.dart';

import '../modules/patient/patient_main/binding/patient_main_binding.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,

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

          GoRoute(
            path: AppRoutes.patientProfile,
            builder: (context, state) => PatientProfilePage(),
          ),

          GoRoute(
            path: AppRoutes.patientOrder,
            builder: (context, state) => PatientOrderPage(),
          ),
        ],
      ),

      // GoRoute(
      //   path: AppRoutes.patientHome,
      //   builder: (context, state) {
      //     PatientHomePageBinding().dependencies();
      //     return PatientHomePage();
      //   },
      // ),

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
