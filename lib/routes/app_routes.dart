abstract class AppRoutes {
  static const splash = '/splash';

  /// ================================
  /// 🔹 SUPER ADMIN
  /// ================================
  /// aichat
  static const aiChat = '/aiChat';

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
  static const patientForgotPassword = '/patientForgotPassword';

  // Main Pages
  static const patientMain = '/patientMain';
  static const patientHome = '/home';
  static const patientProfile = '/profile';
  static const patientOrder = '/order';

  // ...........Appointments ............ //

  // 🔹 Clinical Visit
  static const clinicalFilter = '/clinical-filter';
  static const clinicalDoctorList = '/clinical-doctor-list';
  static const clinicalDoctorDetails = '/clinical-doctor-details';
  static const clinicalSchedule = '/clinical-schedule';
  static const clinicalPayment = '/clinical-payment';
  static const clinicalConfirmation = '/clinical-confirmation';

  // 🔹 Video Consultation
  static const videoFilter = '/video-filter';
  static const videoDoctorList = '/video-doctor-list';

  // Instant Flow
  static const videoInstant = '/video-instant';
  static const videoWaiting = '/video-waiting';

  // Schedule Flow
  static const videoSchedule = '/video-schedule';

  // Common
  static const videoPayment = '/video-payment';
  static const videoConfirmation = '/video-confirmation';
  static const videoQueue = '/video-queue';

  // .................................... //
  static const patientSelection = '/patientSelection';
  static const addPatient = '/addPatient';

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
