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
        patientName: 'Mr. Vignesh', // ✅ NEW
        doctorId: 'DOC001',
        doctorName: 'Dr. Mariappan',
        speciality: 'Dermatologist',
        visitId: '261915', // ✅ NEW
        date: '5/4/2026',
        diagnosis: 'Skin Allergy',
        notes: 'Follow the above mentioned drugs for 5 days',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED001',
            medicineName: 'Cetaphil Gentle Skin Cleanser',
            frequency: '1-1-0-1', // ✅ UPDATED
            days: 6, // ✅ UPDATED
            instructions: 'Use as directed',
            quantity: 3, // ✅ REQUIRED for cart
            price: 250.0, // ✅ REQUIRED for payment
          ),
        ],

        labTests: [
          LabTest(
            category: 'MICROBIOLOGY',
            testName: 'MP QBC',
            instructions: 'ghg',
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
        notes: 'Monitor BP regularly',

        prescriptions: [
          PrescriptionItem(
            medicineId: 'MED002',
            medicineName: 'Amlodipine 5mg',
            frequency: '1-0-1-0',
            days: 30,
            instructions: 'After food',
            quantity: 2,
            price: 120.0,
          ),
        ],

        labTests: [],
      ),
    ];
  }
}
