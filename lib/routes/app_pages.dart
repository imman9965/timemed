import 'package:get/get.dart';
import 'package:timesmed_project/app.dart';
import 'package:timesmed_project/modules/doctor/login/view/Doctor_login_page.dart';
import 'package:timesmed_project/modules/patient/login_page/view/patient_login_page.dart';
import 'package:timesmed_project/modules/splash/view/splash_view.dart';
import 'package:timesmed_project/modules/super/view/super_home_view.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashView()),
    GetPage(name: AppRoutes.superHome, page: () => SuperHomeView()),
    GetPage(name: AppRoutes.patientLogin, page: () => PatientLoginPage()),
    GetPage(name: AppRoutes.doctorLogin, page: () => DoctorLoginPage()),
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
