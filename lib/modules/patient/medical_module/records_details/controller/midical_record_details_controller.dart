import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';

class MedicalRecordsDetailsController extends GetxController {
  final isLoading = false.obs;

  /// 🔹 Single record for details page (demo)
  final selectedRecord = Rxn<MedicalRecordModel>();
  final selectedIds = <String>{}.obs;

  void toggleMedicine(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  bool isSelected(String id) => selectedIds.contains(id);

  bool get hasSelection => selectedIds.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadDemoRecord(); // ✅ load static data here
  }

  void loadDemoRecord() {
    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      selectedRecord.value = _demoRecord();
      isLoading.value = false;
    });
  }

  /// ✅ STATIC DATA INSIDE CONTROLLER
  MedicalRecordModel _demoRecord() {
    return MedicalRecordModel(
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
          instructions: 'Apply gently on skin',
          quantity: 3,
          price: 250,
        ),
        PrescriptionItem(
          medicineId: 'MED002',
          medicineName: 'Paracetamol 500mg',
          frequency: '1-0-1-0',
          days: 5,
          instructions: 'After food',
          quantity: 2,
          price: 50,
        ),
        PrescriptionItem(
          medicineId: 'MED003',
          medicineName: 'Cetaphil Gentle Skin Cleanser',
          frequency: '1-1-0-1',
          days: 6,
          instructions: 'Apply gently on skin',
          quantity: 3,
          price: 250,
        ),
        PrescriptionItem(
          medicineId: 'MED004',
          medicineName: 'Paracetamol 500mg',
          frequency: '1-0-1-0',
          days: 5,
          instructions: 'After food',
          quantity: 2,
          price: 50,
        ),
      ],

      labTests: [
        LabTest(
          category: 'MICROBIOLOGY',
          testName: 'MP QBC',
          instructions: 'Fasting required',
        ),
      ],
    );
  }
}
