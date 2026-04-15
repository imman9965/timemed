part of 'app_pages.dart';

abstract class AppRoutes {
  static const splash = '/splash';

  /// ================================
  /// 🔹 SUPER ADMIN
  /// ================================
  static const superAdminHome = '/superAdminHome';

  /// ================================
  /// 🔹 ADMIN
  /// ================================
  static const adminLogin = '/adminLogin';
  static const adminHome = '/adminHome';
  static const adminProfile = '/adminProfile';
  static const adminDashboard = '/adminDashboard';

  /// ================================
  /// 🔹 PATIENT
  /// ================================
  static const patientLogin = '/patientLogin';
  static const patientOtp = '/patientOtp';
  static const patientSignup = '/patientSignup';
  static const patientHome = '/patientHome';

  /// ================================
  /// 🔹 DOCTOR
  /// ================================
  static const doctorLogin = '/doctorLogin';
  static const doctorHome = '/doctorHome';

  /// ================================
  /// 🔹 PHARMACY
  /// ================================
  static const pharmacyLogin = '/pharmacyLogin';
  static const pharmacyHome = '/pharmacyHome';
}
