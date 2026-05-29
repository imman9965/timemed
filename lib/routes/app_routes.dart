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
  static const patientPreviousAppointments = '/appointments';
  static const patientDashboard = '/patientDashboard';
  static const patientServices = '/services';

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
  static const specialityDoctorList = '/speciality-doctors';
  static const videoPayment = '/video-payment';
  static const videoConfirmation = '/video-confirmation';
  static const videoQueue = '/video-queue';
  static const videoCall = '/video-call';
  static const rating = "/rating";
  // .................................... //

  static const patientSelection = '/patientSelection';
  static const addPatient = '/addPatient';
  // ─────────────────────────────────────────────────────────────────────────────
  // ADD THESE ROUTE CONSTANTS to your existing AppRoutes class
  // ─────────────────────────────────────────────────────────────────────────────
  static const String patientMedicalRecords = '/medical-records';
  static const String patientMedicalRecordDetail = '/medical-records-detail';

  static const String patientMedicineCart = '/medicine-cart';

  /// 🔹 NEW (required)
  static const String patientAddressSelection = '/address-selection';
  static const String patientPrescriptionPayment = '/payment';

  /// 🔹 Success + Tracking
  static const String patientPrescriptionOrderSuccess = '/order-success';
  static const String patientPrescriptionOrderTracking = '/order-tracking';

  /// 🔹 Optional (future)
  static const String patientPrescriptionOrderStatus = '/order-status';
  static const String patientPrescriptionOrderDetails = '/order-details';

  // 🔹 Lab Test
  static const String patientLabTestDetails = '/patient-lab-test-details';

  /// Visit Lab
  static const String patientNearbyLabsPage = '/patient-lab-nearby-lab';
  static const String patientLabSlotSelection =
      '/patient-lab-slot-selection';
  static const String patientLabTestCheckout =
      '/patient-lab-test-checkout';
  static const String patientLabTestBookingSuccess =
      '/patient-lab-test-booking-success';

  /// 🔹 Home Collection Flow
  static const String patientHomeCollectionSlot =
      '/patient-home-collection-slot';

  static const String patientHomeCollectionAddress =
      '/patient-home-collection-address';

  static const String patientHomeCollectionCheckout =
      '/patient-home-collection-checkout';

  static const String patientHomeCollectionSuccess =
      '/patient-home-collection-success';

  static const String patientLabTracking =
      '/patient-lab-tracking';


  /// ================================
  /// 🔹 DOCTOR
  /// ================================

  static const doctorLogin = '/doctorLogin';

  // Shell tab routes (bottom nav)
  static const doctorCalendar = '/doctor/calendar';
  static const doctorWaitingList = '/doctor/waiting-list';
  static const doctorCallLogs = '/doctor/call-logs';
  static const doctorMissedCalls = '/doctor/missed-calls';
  static const doctorDashboard = '/doctor/dashboard';

  // Sub-pages (pushed on top of shell)
  static const hospitalList = '/hospitalList';
  static const basicDetails = '/basicDetails';
  static const rescheduleAppointment = '/rescheduleAppointment';
  static const scheduleAppointment = '/scheduleAppointment';
  static const medicalRecords = '/medicalRecords';
  static const videoPage = '/videoPage';
  static const queue = '/queue';
  static const history = '/history';
  static const prescription = '/prescription';
  static const labTest = '/labTest';
  static const notes = '/notes';

  // Legacy alias — points to the first shell tab
  static const calendar = doctorCalendar;

  // static const logout = '/basicDetails';

  /// ================================
  /// 🔹 PHARMACY
  /// ================================
  static const pharmacyLogin = '/pharmacyLogin';
  static const pharmacyHome = '/pharmacyHome';
}
