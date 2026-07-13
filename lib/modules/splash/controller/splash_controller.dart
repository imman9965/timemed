import 'package:get/get.dart';
import 'package:timesmed_project/core/config/app_config.dart';
import 'package:timesmed_project/core/storage/secure_storage.dart';
import 'package:timesmed_project/routes/app_pages.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class SplashController extends GetxController {
  final SecureStorage _storage = SecureStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await _storage.getToken();
    final role = await _storage.getRole();

    if (token == null || token.isEmpty) {
      switch (AppConfig.instance.flavor) {
        case AppFlavor.patient:
          AppRouter.router.go(AppRoutes.patientLogin);
          break;

        case AppFlavor.doctor:
          AppRouter.router.go(AppRoutes.doctorLogin);
          break;

        case AppFlavor.pharmacy:
          AppRouter.router.go(AppRoutes.pharmacyLogin);
          break;

        case AppFlavor.admin:
          AppRouter.router.go(AppRoutes.adminLogin);
          break;

        case AppFlavor.superApp:
          AppRouter.router.go(AppRoutes.superAdminHome);
          break;
      }
      return;
    }

    /// 🔵 If Token Exists → Navigate Based On Role
    switch (role) {
      case 'patient':
        // Get.offAllNamed(AppRoutes.patientHome);
        AppRouter.router.go(AppRoutes.patientHome);
        break;

      case 'doctor':
        // Get.offAllNamed(AppRoutes.doctorHome);
        AppRouter.router.go(AppRoutes.doctorWaitingList);
        break;

      case 'pharmacy':
        // Get.offAllNamed(AppRoutes.pharmacyHome);
        AppRouter.router.go(AppRoutes.pharmacyHome);
        break;

      case 'admin':
        // Get.offAllNamed(AppRoutes.adminDashboard);
        AppRouter.router.go(AppRoutes.adminDashboard);
        break;

      default:
        AppRouter.router.go(AppRoutes.superAdminHome);
      // Get.offAllNamed(AppRoutes.splash);
    }
  }
}
