import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/ai_chat/view/ai_chat_page.dart';
import 'package:timesmed_project/modules/patient/paient_home/binding/patient_home_page_binding.dart';
import 'package:timesmed_project/modules/patient/paient_home/view/patient_home_page.dart';
import 'package:timesmed_project/modules/patient/patient_add/view/patient_add_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/doctor_details/view/clinical_doctor_details_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/doctor_list/view/clinical_doctor_list_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/filter/view/clinical_filter_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/schedule/view/clinical_schedule_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/doctor_list/binding/video_doctor_list_binding.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/doctor_list/view/video_doctor_list_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/binding/Vvdeo_filter_binding.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/view/video_consultation_filter_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/payment/view/video_payment_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/queue/view/video_queue_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/schedule/view/video_schedule_page.dart';
import 'package:timesmed_project/modules/patient/patient_login/Binding/patient_login_binding.dart';
import 'package:timesmed_project/modules/patient/patient_login/view/patient_forgot_password_page.dart';
import 'package:timesmed_project/modules/patient/patient_login/view/patient_login_page.dart';
import 'package:timesmed_project/modules/patient/patient_login/view/patient_otp_page.dart';
import 'package:timesmed_project/modules/patient/patient_main/view/patient_main_page.dart';
import 'package:timesmed_project/modules/patient/patient_order/binding/patient_order_binding.dart';
import 'package:timesmed_project/modules/patient/patient_order/view/patient_order_page.dart';
import 'package:timesmed_project/modules/patient/patient_previous_appointment/view/patient_previous_appointment%20_page.dart';
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

          GoRoute(
            path: AppRoutes.patientProfile,
            builder: (context, state) {
              PatientHomePageBinding().dependencies();
              return PatientProfilePage();
            },
          ),

          GoRoute(
            path: AppRoutes.patientPreviousAppointments,
            builder: (context, state) {
              // PatientOrderBinding().dependencies();
              return PatientPreviousAppointmentPage();
            },
          ),

          GoRoute(
            path: AppRoutes.patientOrder,
            builder: (context, state) {
              PatientOrderBinding().dependencies();
              return PatientOrderPage();
            },
          ),
        ],
      ),

      // ...........Appointments ............ //

      // 🔹 Clinical Visit
      GoRoute(
        path: AppRoutes.clinicalFilter,
        builder: (context, state) => ClinicalFilterPage(),
      ),
      GoRoute(
        path: AppRoutes.clinicalDoctorList,
        builder: (context, state) => ClinicalDoctorListPage(),
      ),
      GoRoute(
        path: AppRoutes.clinicalDoctorDetails,
        builder: (context, state) => ClinicalDoctorDetailsPage(),
      ),
      GoRoute(
        path: AppRoutes.clinicalSchedule,
        builder: (context, state) => ClinicalSchedulePage(),
      ),
      /*





      GoRoute(
        path: AppRoutes.clinicalPayment,
        builder: (context, state) => ClinicalPaymentPage(),
      ),

      GoRoute(
        path: AppRoutes.clinicalConfirmation,
        builder: (context, state) => ClinicalConfirmationPage(),
      ),*/

      // 🔹 Video Consultation
      GoRoute(
        path: AppRoutes.videoFilter,
        builder: (context, state) {
          VideoFilterBinding().dependencies();
          return VideoConsultationFilterPage();
        },
      ),

      GoRoute(
        path: AppRoutes.videoDoctorList,
        builder: (context, state) {
          VideoDoctorListBinding().dependencies();
          return VideoDoctorListPage();
        },
      ),
      // 🔹 Common
      GoRoute(
        path: AppRoutes.videoPayment,
        builder: (context, state) => VideoPaymentPage(),
      ),

      GoRoute(
        path: AppRoutes.videoQueue,
        builder: (context, state) => VideoQueuePage(),
      ),

      // 🔹 Schedule Flow
      GoRoute(
        path: AppRoutes.videoSchedule,
        builder: (context, state) => VideoSchedulePage(),
      ),

      /*
      // 🔹 Instant Flow
      GoRoute(
        path: AppRoutes.videoInstant,
        builder: (context, state) => VideoInstantPage(),
      ),

      GoRoute(
        path: AppRoutes.videoWaiting,
        builder: (context, state) => VideoWaitingPage(),
      ),

      // 🔹 Schedule Flow
      GoRoute(
        path: AppRoutes.videoSchedule,
        builder: (context, state) => VideoSchedulePage(),
      ),

      // 🔹 Common
      GoRoute(
        path: AppRoutes.videoPayment,
        builder: (context, state) => VideoPaymentPage(),
      ),

      GoRoute(
        path: AppRoutes.videoConfirmation,
        builder: (context, state) => VideoConfirmationPage(),
      ),*/

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
