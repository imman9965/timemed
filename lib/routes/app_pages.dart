import 'package:get/get.dart';
import 'package:timesmed_project/modules/doctor/login/view/Doctor_login_page.dart';
import 'package:timesmed_project/modules/patient/paient_home_page/view/patient_home_page.dart';
import 'package:timesmed_project/modules/patient/patient_login_page/view/patient_login_page.dart';
import 'package:timesmed_project/modules/patient/patient_login_page/view/patient_otp_page.dart';
import 'package:timesmed_project/modules/patient/patient_signup_page/view/patient_signup_page.dart';
import 'package:timesmed_project/modules/splash/view/splash_view.dart';
import 'package:timesmed_project/modules/super/view/super_home_view.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashView()),
    GetPage(name: AppRoutes.superHome, page: () => SuperHomeView()),

    /// ================================
    /// 🔹 PATIENT PAGES
    /// ================================
    GetPage(name: AppRoutes.patientLogin, page: () => PatientLoginPage()),
    GetPage(name: AppRoutes.patientOtpPage, page: () => PatientOtpPage()),
    GetPage(name: AppRoutes.patientSignup, page: () => PatientSignupPage()),
    GetPage(name: AppRoutes.patientHome, page: () => PatientHomePage()),

    /// ================================
    /// 🔹 Doctor PAGES
    /// ================================
    GetPage(name: AppRoutes.doctorLogin, page: () => DoctorLoginPage()),

    /// ================================
    /// 🔹 Pharmacy PAGES
    /// ================================
  ];
}

// GetPage(name: AppRoutes.homePage, page: () => const HomePage()),
// GetPage(
//   name: AppRoutes.screeningPage,
//   page: () {
//     final args = Get.arguments ?? {};
//     return ScreeningPage(
//       isFromPds: args['isFromPds'],
//       pdsNumber: args['pdsNumber'],
//       showAbhaDialog: args['showAbhaDialog'],
//     );
//   },
//   binding: ScreeningBinding(),
// ),
