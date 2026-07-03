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

  // ✅ Source of truth for all record pages
  List<MedicalRecordModel> _dummyRecords() {
    return [
      // 1. MAXIMUM DATA STATE: 5 Prescriptions + Lab Tests + Detailed Remarks
      MedicalRecordModel(
        id: 'REC001',
        patientId: 'PAT001',
        patientName: 'Mr. Vignesh',
        doctorId: 'DOC001',
        doctorName: 'Dr. Mariappan',
        speciality: 'Dermatologist',
        visitId: '261915',
        date: '05/04/2026',
        time: '05:49 PM',
        status: 'Completed',
        diagnosis: 'Severe Chronic Dermatitis & Secondary Infection',
        notes: 'Patient exhibits widespread acute redness and scaling. Follow the 5 prescribed medications exactly as directed. Complete the full antibiotic course. Avoid direct sunlight and harsh soaps.',
        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED001',
            medicineName: 'Cetaphil Gentle Skin Cleanser',
            frequency: '1-0-0-1',
            days: 10,
            instructions: 'Apply gently before bathing',
            quantity: 2,
            price: 250.0,
          ),
          PrescriptionItem(
            medicineId: 'MED002',
            medicineName: 'Amoxicillin 500mg Capsules',
            frequency: '1-1-1-0',
            days: 5,
            instructions: 'After food - Complete the course',
            quantity: 15,
            price: 120.0,
          ),
          PrescriptionItem(
            medicineId: 'MED003',
            medicineName: 'Levocetirizine 5mg Tablets',
            frequency: '0-0-0-1',
            days: 7,
            instructions: 'At bedtime - May cause drowsiness',
            quantity: 7,
            price: 45.0,
          ),
          PrescriptionItem(
            medicineId: 'MED004',
            medicineName: 'Hydrocortisone 1% Cream',
            frequency: '1-0-1-0',
            days: 7,
            instructions: 'Apply thinly over affected areas only',
            quantity: 1,
            price: 85.0,
          ),
          PrescriptionItem(
            medicineId: 'MED005',
            medicineName: 'Vitamin C 500mg Chewable Tabs',
            frequency: '0-1-0-0',
            days: 30,
            instructions: 'Chew completely after lunch',
            quantity: 30,
            price: 150.0,
          ),
        ],
        labTests: [
          LabTest(
            category: 'MICROBIOLOGY',
            testName: 'Skin Scraping for Fungus / KOH Mount',
            instructions: 'Do not apply any cream on the morning of the test',
          ),
          LabTest(
            category: 'HEMATOLOGY',
            testName: 'Complete Blood Count (CBC) with Absolute Eosinophil Count',
            instructions: 'Fasting preferred but not mandatory',
          ),
        ],
      ),

      // 2. MODERATE DATA STATE: 2 Prescriptions + NO Lab Tests + Detailed Remarks
      MedicalRecordModel(
        id: 'REC002',
        patientId: 'PAT002',
        patientName: 'Mr. Immanuel',
        doctorId: 'DOC001',
        doctorName: 'Dr. Mariappan',
        speciality: 'Dermatologist',
        visitId: '261918',
        date: '22/03/2026',
        time: '10:45 AM',
        status: 'Completed',
        diagnosis: 'Acute Common Cold & Body Aches',
        notes: 'Take complete bed rest for 3 days and stay well hydrated with warm fluids. Review immediately if high fever persists beyond 48 hours.',
        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED006',
            medicineName: 'Paracetamol 650mg Syrup',
            frequency: '1-1-1-1',
            days: 4,
            instructions: 'After food when needed for fever',
            quantity: 1,
            price: 95.0,
          ),
          PrescriptionItem(
            medicineId: 'MED007',
            medicineName: 'Azithromycin 500mg Tablets',
            frequency: '1-0-0-0',
            days: 3,
            instructions: '1 hour before food or 2 hours after food',
            quantity: 3,
            price: 72.0,
          ),
        ],
        labTests: [],
      ),

      // 3. DIAGNOSTIC STATE: NO Prescriptions + 2 Lab Tests + Detailed Remarks
      MedicalRecordModel(
        id: 'REC003',
        patientId: 'PAT003',
        patientName: 'Mr. Arjun',
        doctorId: 'DOC002',
        doctorName: 'Dr. John Mathew',
        speciality: 'Cardiologist',
        visitId: '261922',
        date: '18/04/2026',
        time: '11:15 AM',
        status: 'Completed',
        diagnosis: 'Chest Discomfort Evaluation',
        notes: 'Advised to undergo immediate cardiac profiling. Strictly limit high-sodium food intake and avoid strenuous physical exertion until reports are thoroughly reviewed.',
        prescriptions: [],
        labTests: [
          LabTest(
            category: 'BIOCHEMISTRY',
            testName: 'Lipid Profile Extended Panel',
            instructions: 'Strictly 12 hours fasting required. Water is permissible.',
          ),
          LabTest(
            category: 'CARDIOLOGY',
            testName: '12-Lead Electrocardiogram (ECG)',
            instructions: 'No special preparation needed.',
          ),
        ],
      ),

      // 4. MINIMAL STATE: NO Prescriptions + NO Lab Tests + Simple Remarks
      MedicalRecordModel(
        id: 'REC004',
        patientId: 'PAT001',
        patientName: 'Mr. Vignesh',
        doctorId: 'DOC001',
        doctorName: 'Dr. Mariappan',
        speciality: 'Dermatologist',
        visitId: '261916',
        date: '01/04/2026',
        time: '11:30 AM',
        status: 'Completed',
        diagnosis: 'Mild Xerosis (Dry Skin)',
        notes: 'Apply standard over-the-counter emollient moisturizer twice daily immediately after taking a shower while skin is damp.',
        prescriptions: [],
        labTests: [],
      ),

      // 5. EMPTY STATE: NO Prescriptions + NO Lab Tests + NO Remarks
      MedicalRecordModel(
        id: 'REC005',
        patientId: 'PAT004',
        patientName: 'Mrs. Priya',
        doctorId: 'DOC002',
        doctorName: 'Dr. John Mathew',
        speciality: 'Cardiologist',
        visitId: '261925',
        date: '28/03/2026',
        time: '02:15 PM',
        status: 'Completed',
        diagnosis: 'Routine Annual Health Checkup',
        notes: '', // Completely empty remarks field to test blank screen handling
        prescriptions: [],
        labTests: [],
      ),
    ];
  }
}
