import 'package:get/get.dart';
import '../model/medical_record_model.dart';

class MedicalRecordsController extends GetxController {
  final isLoading = false.obs;
  final records = <MedicalRecordModel>[].obs;
  final selectedRecord = Rxn<MedicalRecordModel>();

  @override
  void onInit() {
    super.onInit();
    fetchMedicalRecords();
  }

  Future<void> fetchMedicalRecords() async {
    try {
      isLoading.value = true;

      // TODO: Replace with API
      await Future.delayed(const Duration(seconds: 1));

      records.value = _dummyRecords();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medical records');
    } finally {
      isLoading.value = false;
    }
  }

  void selectRecord(MedicalRecordModel record) {
    selectedRecord.value = record;
  }

  // ✅ Updated Dummy Data (matches new model)
  List<MedicalRecordModel> _dummyRecords() {
    return [
      MedicalRecordModel(
        id: 'REC001',
        patientId: 'PAT001',
        patientName: 'Mr. Vignesh',
        doctorId: 'DOC001',
        doctorName: 'Dr. Mariappan',
        speciality: 'Dermatologist',
        visitId: '261915',
        date: '05/04/2026',
        diagnosis: 'Skin Allergy',
        notes: 'Follow the above mentioned drugs for 5 days',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED001',
            medicineName: 'Cetaphil Gentle Skin Cleanser',
            frequency: '1-1-0-1',
            days: 6,
            instructions: 'Use as directed',
            quantity: 3,
            price: 250.0,
          ),

          PrescriptionItem(
            medicineId: 'MED002',
            medicineName: 'Hydrocortisone Cream',
            frequency: '1-0-1-0',
            days: 5,
            instructions: 'Apply externally',
            quantity: 1,
            price: 180.0,
          ),
        ],

        labTests: [
          LabTest(
            category: 'MICROBIOLOGY',
            testName: 'MP QBC',
            instructions: 'Fasting not required',
          ),

          LabTest(
            category: 'BLOOD TEST',
            testName: 'Complete Blood Count',
            instructions: 'Drink enough water before test',
          ),
        ],
      ),

      MedicalRecordModel(
        id: 'REC002',
        patientId: 'PAT001',
        patientName: 'Mr. Vignesh',
        doctorId: 'DOC002',
        doctorName: 'Dr. John Mathew',
        speciality: 'Cardiologist',
        visitId: '261916',
        date: '01/04/2026',
        diagnosis: 'Hypertension',
        notes: 'Monitor BP regularly and reduce salt intake',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED003',
            medicineName: 'Amlodipine 5mg',
            frequency: '1-0-1-0',
            days: 30,
            instructions: 'After food',
            quantity: 2,
            price: 120.0,
          ),

          PrescriptionItem(
            medicineId: 'MED004',
            medicineName: 'Telmisartan 40mg',
            frequency: '0-1-0-1',
            days: 30,
            instructions: 'Before food',
            quantity: 1,
            price: 320.0,
          ),
        ],

        labTests: [
          LabTest(
            category: 'CARDIAC',
            testName: 'Lipid Profile',
            instructions: '10 hours fasting required',
          ),

          LabTest(
            category: 'CARDIAC',
            testName: 'ECG',
            instructions: 'Avoid caffeine before test',
          ),
        ],
      ),

      MedicalRecordModel(
        id: 'REC003',
        patientId: 'PAT002',
        patientName: 'Mrs. Priya',
        doctorId: 'DOC003',
        doctorName: 'Dr. Kavitha',
        speciality: 'Gynecologist',
        visitId: '261917',
        date: '28/03/2026',
        diagnosis: 'Hormonal Imbalance',
        notes: 'Review after 2 weeks',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED005',
            medicineName: 'Iron Supplements',
            frequency: '1-0-0-1',
            days: 15,
            instructions: 'After breakfast',
            quantity: 2,
            price: 210.0,
          ),
        ],

        labTests: [
          LabTest(
            category: 'HORMONE',
            testName: 'Thyroid Profile',
            instructions: 'Morning sample preferred',
          ),

          LabTest(
            category: 'SCAN',
            testName: 'Pelvic Ultrasound',
            instructions: 'Drink water before scan',
          ),
        ],
      ),

      MedicalRecordModel(
        id: 'REC004',
        patientId: 'PAT003',
        patientName: 'Master Rahul',
        doctorId: 'DOC004',
        doctorName: 'Dr. Stephen',
        speciality: 'Pediatrician',
        visitId: '261918',
        date: '22/03/2026',
        diagnosis: 'Viral Fever',
        notes: 'Take proper rest and fluids',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED006',
            medicineName: 'Paracetamol Syrup',
            frequency: '1-1-1-1',
            days: 4,
            instructions: 'After food',
            quantity: 1,
            price: 95.0,
          ),

          PrescriptionItem(
            medicineId: 'MED007',
            medicineName: 'Vitamin C Syrup',
            frequency: '1-0-1-0',
            days: 10,
            instructions: 'Morning and night',
            quantity: 1,
            price: 140.0,
          ),
        ],

        labTests: [
          LabTest(
            category: 'GENERAL',
            testName: 'Dengue Test',
            instructions: 'No preparation needed',
          ),
        ],
      ),

      MedicalRecordModel(
        id: 'REC005',
        patientId: 'PAT004',
        patientName: 'Mr. Arjun',
        doctorId: 'DOC005',
        doctorName: 'Dr. Meena',
        speciality: 'Orthopedic',
        visitId: '261919',
        date: '18/03/2026',
        diagnosis: 'Knee Joint Pain',
        notes: 'Avoid heavy workouts for 2 weeks',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED008',
            medicineName: 'Pain Relief Gel',
            frequency: '1-1-1-0',
            days: 7,
            instructions: 'Apply on affected area',
            quantity: 2,
            price: 175.0,
          ),

          PrescriptionItem(
            medicineId: 'MED009',
            medicineName: 'Calcium Tablets',
            frequency: '0-1-0-1',
            days: 20,
            instructions: 'After meals',
            quantity: 1,
            price: 260.0,
          ),
        ],

        labTests: [
          LabTest(
            category: 'RADIOLOGY',
            testName: 'Knee X-Ray',
            instructions: 'Remove metal accessories',
          ),

          LabTest(
            category: 'BLOOD TEST',
            testName: 'Vitamin D Test',
            instructions: 'No fasting required',
          ),
        ],
      ),
    ];
  }
}
