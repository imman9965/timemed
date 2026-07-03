import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/doctor/calendar/calendar_page.dart';
import 'package:timesmed_project/modules/ai_chat/view/ai_chat_page.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_screen_list.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_details/view/patient_lab_test_details_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_track/view/patient_lab_test_tracking_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/home_collection/home_collection_address/view/patient_home_collection_address_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/home_collection/home_collection_checkout/view/patient_home_collection_checkout_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/home_collection/home_collection_slot/view/patient_home_collection_slot_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/home_collection/home_collection_success/view/patient_home_collection_success_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/visit_lab/lab_slot_selection/view/patient_lap_slot_selection_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/visit_lab/lab_test_booking_success/view/patient_lab_test_booking_success_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/visit_lab/lab_test_checkout/view/patient_lab_test_checkout_page.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/visit_lab/nearby_labs/view/nearby_labs_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/address/binding/address_binding.dart';
import 'package:timesmed_project/modules/patient/medical_module/address/view/address_selection_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/cart/binding/cart_binding.dart';
import 'package:timesmed_project/modules/patient/medical_module/cart/view/cart_view.dart';
import 'package:timesmed_project/modules/patient/medical_module/order_details/view/patient_prescription_order_details_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/order_status/view/patient_prescription_order_status_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/order_success/view/patient_prescription_order_success_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/payment/view/patient_prescription_payment_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/binding/medical_records_binding.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/view/medical_records_view.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/binding/medical_records_details_binding.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/controller/midical_record_details_controller.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/view/medical_recorde_details_page.dart';
import 'package:timesmed_project/modules/patient/medical_module/track_order/view/patient_prescription_track_order_page.dart';
import 'package:timesmed_project/modules/patient/patient_add/view/patient_add_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/confirmation/view/clinical_visit_confirmation_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/doctor_details/view/clinical_doctor_details_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/doctor_list/view/clinical_doctor_list_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/filter/view/clinical_filter_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/payment/view/clinical_visit_payment_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/schedule/view/clinical_schedule_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/doctor_list/binding/video_doctor_list_binding.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/doctor_list/view/video_doctor_list_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/binding/Vvdeo_filter_binding.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/view/video_consultation_filter_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/payment/view/video_payment_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/queue/view/video_queue_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/rating/view/rating_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/schedule/view/video_schedule_page.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/video_call/view/video_call_page.dart';
import 'package:timesmed_project/modules/patient/patient_dashboard/view/patient_dashboard_page.dart';
import 'package:timesmed_project/modules/patient/patient_home/binding/patient_home_page_binding.dart';
import 'package:timesmed_project/modules/patient/patient_home/view/patient_home_page.dart';
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
import 'package:timesmed_project/modules/patient/patient_services/view/patient_services_page.dart';
import 'package:timesmed_project/modules/patient/patient_signup/binding/patient_signup_binding.dart';
import 'package:timesmed_project/modules/patient/patient_signup/view/patient_signup_page.dart';
import 'package:timesmed_project/modules/patient/speciality_doctors/binding/speciality_doctor_binding.dart';
import 'package:timesmed_project/modules/patient/speciality_doctors/view/speciality_doctors_list_page.dart';

// Views
import 'package:timesmed_project/modules/splash/view/splash_view.dart';
import 'package:timesmed_project/modules/super/view/super_home_view.dart';

// Bindings
import 'package:timesmed_project/routes/app_routes.dart';
import 'package:timesmed_project/modules/doctor/patient_register/patient_registeration.dart';

import '../modules/doctor/call_page/disconnect_screen.dart';
import '../modules/doctor/dashboard/schedule_from_dashboard.dart';
import '../modules/doctor/end_call_screen.dart';
import '../modules/doctor/medical_history/medical_history.dart';
import '../modules/doctor/medical_history/medical_history_records.dart';
import '../modules/doctor/calendar/dashboard.dart';
import '../modules/doctor/call_logs/call_logs.dart';
import '../modules/doctor/call_page/call_page.dart';
import '../modules/doctor/clinical_notes/clinical notes_screen.dart';
import '../modules/doctor/dashboard/dashboard_screen.dart';
import '../modules/doctor/doctor_basic_details/doctor_basic_details.dart';
import '../modules/doctor/doctor_login_page/view/login_page.dart';
import '../modules/doctor/doctor_login_page/view/otp_page.dart';
import '../modules/doctor/doctor_prescription/prescription_screen.dart';
import '../modules/doctor/doctor_profile/doctor_profile.dart';
import '../modules/doctor/doctor_shell/doctor_shell.dart';
import '../modules/doctor/hospital_list_doctor/hospital_list_based_on_doctor.dart';
import '../modules/doctor/lap_test/Lab_test.dart';
import '../modules/doctor/medical_records/medical_records.dart';
import '../modules/doctor/missed_call_page/missed_call.dart';
import '../modules/doctor/patient_waiting_list/patient_waiting_list.dart';
import '../modules/doctor/request_list/request_list.dart';
import '../modules/doctor/schedule_appointment/schedule_appointment.dart';
import '../modules/doctor/schedule_appointment_list/schedule_appointmnet_list.dart';
import '../modules/doctor/notifications/doctor_notifications_screen.dart';

import '../modules/patient/patient_main/binding/patient_main_binding.dart';
import '../modules/doctor/patient_register/patients_list.dart';

// Navigator keys for each shell branch
final _dashboardNavKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _calendarNavKey = GlobalKey<NavigatorState>(debugLabel: 'calendar');
final _waitingListNavKey = GlobalKey<NavigatorState>(debugLabel: 'waitingList');
final _callLogsNavKey = GlobalKey<NavigatorState>(debugLabel: 'callLogs');
final _missedCallsNavKey = GlobalKey<NavigatorState>(debugLabel: 'missedCalls');
final _prescriptionNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'prescription',
);
final _clinicalNotesNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'clinicalNotes',
);
final _appointmentsNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'appointments',
);
final _notificationsNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'notifications',
);

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
            path: AppRoutes.patientPreviousAppointments,
            builder: (context, state) {
              // PatientOrderBinding().dependencies();
              return PatientPreviousAppointmentPage();
            },
          ),
          GoRoute(
            path: AppRoutes.patientDashboard,
            builder: (context, state) {
              // PatientOrderBinding().dependencies();
              return PatientDashboardPage();
            },
          ),

          // GoRoute(
          //   path: AppRoutes.patientLabTracking,
          //   builder: (context, state) {
          //     return PatientLabTrackingPage();
          //   },
          // ),
          //
          // GoRoute(
          //   path: AppRoutes.patientOrder,
          //   builder: (context, state) {
          //     PatientOrderBinding().dependencies();
          //     return PatientOrderPage();
          //   },
          // ),
          GoRoute(
            path: AppRoutes.patientServices,
            builder: (context, state) {
              return PatientServicesPage();
            },
          ),
          GoRoute(
            path: AppRoutes.patientProfile,
            builder: (context, state) {
              PatientHomePageBinding().dependencies();
              return PatientProfilePage();
            },
          ),
        ],
      ),
      /// demo
      GoRoute(
        path: AppRoutes.patientLabTracking,
        builder: (context, state) {
          return PatientLabTrackingPage();
        },
      ),

      GoRoute(
        path: AppRoutes.patientOrder,
        builder: (context, state) {
          PatientOrderBinding().dependencies();
          return PatientOrderPage();
        },
      ),
      ///

      // ...........Dashboard................ //
      GoRoute(
        path: AppRoutes.patientDashboard,
        builder: (context, state) => PatientDashboardPage(

        ),
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

      GoRoute(
        path: AppRoutes.clinicalPayment,
        builder: (context, state) => ClinicalVisitPaymentPage(),
      ),
      GoRoute(
        path: AppRoutes.clinicalConfirmation,
        builder: (context, state) => ClinicalVisitConfirmationPage(),
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
        path: AppRoutes.specialityDoctorList,
        builder: (context, state) {
          SpecialityDoctorBinding().dependencies();
          return SpecialityDoctorsListPage();
        },
      ),
      GoRoute(
        path: AppRoutes.videoPayment,
        builder: (context, state) => VideoPaymentPage(),
      ),

      GoRoute(
        path: AppRoutes.videoQueue,
        builder: (context, state) => VideoQueuePage(),
      ),

      GoRoute(
        path: AppRoutes.rating,
        builder: (context, state) => RatingPage(),
      ),

      // 🔹 Schedule Flow
      GoRoute(
        path: AppRoutes.videoSchedule,
        builder: (context, state) => VideoSchedulePage(),
      ),

      GoRoute(
        path: AppRoutes.videoCall,
        builder: (context, state) => VideoCallPage(),
      ),

      // 🔹 Medical Record
      GoRoute(
        path: AppRoutes.patientMedicalRecords,
        builder: (context, state) {
          final initialRecord = state.extra as MedicalRecordModel?;
          MedicalRecordsBinding().dependencies();
          return MedicalRecordsPage(initialRecord: initialRecord);
        },
      ),
      GoRoute(
        path: AppRoutes.patientMedicalRecordDetail,
        builder: (context, state) {
          final record = state.extra as MedicalRecordModel?;
          MedicalRecordsDetailsBinding().dependencies();
          final controller = Get.find<MedicalRecordsDetailsController>();
          if (record != null) {
            controller.setRecord(record);
          }
          return MedicalRecordDetailsPage();
        },
      ),

      GoRoute(
        path: AppRoutes.patientMedicineCart,
        builder: (context, state) {
          CartBinding().dependencies();
          return MedicineCartPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patientAddressSelection,
        builder: (context, state) {
          AddressBinding().dependencies();
          return const AddressSelectionPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patientPrescriptionPayment,
        builder: (context, state) {
          return const PatientPrescriptionPaymentPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patientPrescriptionOrderSuccess,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;

          return PatientPrescriptionOrderSuccessPage(
            orderId: data?['orderId'] ?? '',
            amount: data?['amount'] ?? 0.0,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.patientPrescriptionOrderTracking,
        builder: (context, state) {
          return const PatientPrescriptionTrackOrderPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patientPrescriptionOrderStatus,
        builder: (context, state) {
          return const PatientPrescriptionOrderStatusPage();
        },
      ),
      GoRoute(
        path: AppRoutes.patientPrescriptionOrderDetails,
        builder: (context, state) {
          final order = state.extra as Map;
          return PatientPrescriptionOrderDetailsPage(order: order);
        },
      ),

      // 🔹 Lab Test
      /// 🔹 LAB TEST FLOW
      GoRoute(
        path: AppRoutes.patientLabTestDetails,
        builder: (context, state) {
          final labTests = state.extra as List<LabTest>;
          return PatientLabTestDetailsPage(labTest: labTests);
        },
      ),

      GoRoute(
        path: AppRoutes.patientNearbyLabsPage,
        builder: (context, state) {
          final labTests = state.extra as List<LabTest>;
          return PatientNearbyLabsPage(labTest: labTests);
        },
      ),
      GoRoute(
        path: AppRoutes.patientLabSlotSelection,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return PatientLabSlotSelectionPage(
            selectedLab: data["selectedLab"],
            labTest: data["labTest"],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientLabTestCheckout,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return PatientLabTestCheckoutPage(
            labTest: data["labTest"],
            selectedLab: data["selectedLab"],
            selectedTime: data["selectedTime"],
            selectedDate: data["selectedDate"],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.patientLabTestBookingSuccess,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return PatientLabTestBookingSuccessPage(
            bookingData: data,
          );
        },
      ),

      /// 🔹 HOME COLLECTION SLOT
      GoRoute(
        path: AppRoutes.patientHomeCollectionSlot,
        builder: (context, state) {
          final labTests = state.extra as List<LabTest>;

          return PatientHomeCollectionSlotPage(
            labTest: labTests,
          );
        },
      ),

      /// 🔹 HOME COLLECTION ADDRESS
      GoRoute(
        path: AppRoutes.patientHomeCollectionAddress,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return PatientHomeCollectionAddressPage(
            labTest: data["labTest"],
            selectedDate: data["selectedDate"],
            selectedTime: data["selectedTime"],
          );
        },
      ),

      /// 🔹 HOME COLLECTION CHECKOUT
      GoRoute(
        path: AppRoutes.patientHomeCollectionCheckout,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return PatientHomeCollectionCheckoutPage(
            bookingData: data,
          );
        },
      ),

      /// 🔹 HOME COLLECTION SUCCESS
      GoRoute(
        path: AppRoutes.patientHomeCollectionSuccess,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return PatientHomeCollectionSuccessPage(
            bookingData: data,
          );
        },
      ),

      /// ================================
      /// 🔹 DOCTOR
      /// ================================
      GoRoute(
        path: AppRoutes.doctorLogin,
        builder: (context, state) => DoctorLoginPage(),
      ),

      // ConsultationSummaryScreen

      /// ================================
      /// 🔹 DOCTOR — Shell Route (bottom nav)
      /// ================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DoctorShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _dashboardNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.doctorDashboard,
                builder: (context, state) => const AppointmentDashboard(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _calendarNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.doctorCalendar,
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
          // Tab 1: Patient Waiting List
          StatefulShellBranch(
            navigatorKey: _waitingListNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.doctorWaitingList,
                builder: (context, state) => const PatientWaitingListScreen(),
              ),
            ],
          ),
          // Tab 2: Call Logs
          StatefulShellBranch(
            navigatorKey: _callLogsNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.doctorCallLogs,
                builder: (context, state) => CallLogsScreen(
                         ),
              ),
            ],
          ),
          // Tab 3: Missed Calls
          StatefulShellBranch(
            navigatorKey: _missedCallsNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.doctorMissedCalls,
                builder: (context, state) =>
                    const MissedCallPatientListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _prescriptionNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.patientListScreen,
                builder: (context, state) => PatientScreenBlue(),
              ),
            ],
          ),
        ],
      ),

      /// ================================
      /// 🔹 DOCTOR — Sub-pages (pushed on top, no bottom nav)
      /// ================================
      GoRoute(
        path: AppRoutes.doctorNotifications,
        builder: (context, state) => const DoctorNotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.callLogsScreenDash,
        builder: (context, state) => CallLogsScreenDash(
            title: state.extra as String?
        ),
      ),

      GoRoute(
        path: AppRoutes.clinicalSchedule,
        builder: (context, state) => ClinicalSchedulePage(),
      ),

      GoRoute(
        path: AppRoutes.basicDetails,
        name: AppRoutes.basicDetails,
        builder: (context, state) => DoctorBasicDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.hospitalList,
        name: AppRoutes.hospitalList,
        builder: (context, state) => HospitalListScreen(),
      ),
      GoRoute(
        path: AppRoutes.rescheduleAppointment,
        name: AppRoutes.rescheduleAppointment,
        builder: (context, state) => ScheduleAppointmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.scheduleAppointment,
        name: AppRoutes.scheduleAppointment,
        builder: (context, state) => ScheduledAppointmentListScreen(),
      ),

      GoRoute(
        path: AppRoutes.medicalRecords,
        name: AppRoutes.medicalRecords,
        builder: (context, state) => MedicalRecordsScreen(),
      ),

      GoRoute(
        path: AppRoutes.consultationSummaryScreen,
        name: AppRoutes.consultationSummaryScreen,
        builder: (context, state) => UpdateCallStatusScreen(),
      ),
      GoRoute(
        path: AppRoutes.videoPage,
        name: AppRoutes.videoPage,
        builder: (context, state) => VideoCallScreen(),
      ),
      GoRoute(
        path: AppRoutes.appointmentDashboard,
        name: AppRoutes.appointmentDashboard,
        builder: (context, state) => AppointmentDashboard(),
      ),
      GoRoute(
        path: AppRoutes.requestScreen,
        name: AppRoutes.requestScreen,
        builder: (context, state) => RequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorProfile,
        name: AppRoutes.doctorProfile,
        builder: (context, state) => DoctorProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecordHistory,
        name: AppRoutes.medicalRecordHistory,
        builder: (context, state) => MedicalRecordsScreenHistory(),
      ),

      GoRoute(
        path: AppRoutes.medicalRecordHistoryDetails,
        name: AppRoutes.medicalRecordHistoryDetails,
        builder: (context, state) => medicalRecordHistoryDetails(),
      ),

      GoRoute(
        path: AppRoutes.labTest,
        name: AppRoutes.labTest,
        builder: (context, state) => LabTestRequestScreen(),
      ),

      GoRoute(
        path: AppRoutes.queue,
        name: AppRoutes.queue,
        builder: (context, state) => PatientWaitingListScreen(),
      ),

      GoRoute(
        path: AppRoutes.prescription,
        name: AppRoutes.prescription,
        builder: (context, state) => DoctorPrescriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.notes,
        name: AppRoutes.notes,
        builder: (context, state) => ClinicalNotesListScreen(),
      ),

      GoRoute(
        path: AppRoutes.addPatientScreen,
        name: AppRoutes.addPatientScreen,
        builder: (context, state) => PatientRegistrationScreen(),
      ),

      GoRoute(
        path: AppRoutes.medicalRecordsScreenHistory,
        name: AppRoutes.medicalRecordsScreenHistory,
        builder: (context, state) => MedicalRecordsScreenHistory(),
      ),
      GoRoute(
        path: AppRoutes.patientOtpScreen,
        name: AppRoutes.patientOtpScreen,
        builder: (context, state) => OtpPage(),
      ),

      GoRoute(
        path: AppRoutes.templateList,
        name: AppRoutes.templateList,
        builder: (context, state) => TemplateListScreen(),
      ),
      // appointmentList
      GoRoute(
        path: AppRoutes.appointmentList,
        name: AppRoutes.appointmentList,
        builder: (context, state) => ScheduledAppointmentListScreen(),
      ),

    ],
  );
}
