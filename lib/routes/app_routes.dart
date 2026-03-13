part of 'app_pages.dart';

abstract class AppRoutes {
  static const splash = '/splash';

  static const superHome = '/superHome';

  static const adminDashboard = '/adminDashboard';

  /// ================================
  /// 🔹 PATIENT PAGES
  /// ================================
  static const patientLogin = '/patientLogin';
  static const patientOtpPage = '/patientOtp';
  static const patientSignup = '/patientSignup';
  static const patientHome = '/patientHome';

  /// ================================
  /// 🔹 Doctor PAGES
  /// ================================

  static const doctorLogin = '/doctorLogin';
  static const doctorHome = '/doctorDashboard';

  /// ================================
  /// 🔹 Pharmacy PAGES
  /// ================================
  static const pharmacyLogin = '/pharmacyLogin';
  static const pharmacyHome = '/pharmacyHome';

  /// ================================
  /// 🔹 Admin PAGES
  /// ================================

  static const adminLogin = '/adminLogin';
  static const adminHome = '/adminHome';
  static const adminProfile = '/adminProfile';

  /// ================================
  /// 🔹 Super Admin PAGES
  /// ================================
  static const superAdminHome = '/superAdminHome';
}
