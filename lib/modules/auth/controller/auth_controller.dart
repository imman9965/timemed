import 'package:timesmed_project/core/config/app_config.dart';
import 'package:timesmed_project/core/storage/secure_storage.dart';
import 'package:timesmed_project/routes/app_pages.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class AuthController {
  Future<void> logout() async {
    final storage = SecureStorage();

    await storage.clearAll();
    await storage.logout();

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
  }
}
