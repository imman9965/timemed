class MedicalRecordModel {
  final String id;
  final String patientId;
  final String patientName; // ✅ NEW
  final String doctorId;
  final String doctorName;
  final String speciality;
  final String visitId;
  final String date;
  final String time; // ✅ NEW
  final String status; // ✅ NEW
  final String diagnosis;
  final String notes;
  final List<PrescriptionItem> prescriptions;
  final List<LabTest> labTests;

  MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.speciality,
    required this.visitId,
    required this.date,
    required this.time,
    required this.status,
    required this.diagnosis,
    required this.notes,
    required this.prescriptions,
    required this.labTests,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] ?? '',
      patientId: json['patient_id'] ?? '',
      patientName: json['patient_name'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      speciality: json['speciality'] ?? '',
      visitId: json['visit_id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '10:00 AM',
      status: json['status'] ?? 'Completed',
      diagnosis: json['diagnosis'] ?? '',
      notes: json['notes'] ?? '',
      prescriptions: (json['prescriptions'] as List<dynamic>? ?? [])
          .map((e) => PrescriptionItem.fromJson(e))
          .toList(),
      labTests: (json['lab_tests'] as List<dynamic>? ?? [])
          .map((e) => LabTest.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'patient_name': patientName,
    'doctor_id': doctorId,
    'doctor_name': doctorName,
    'speciality': speciality,
    'visit_id': visitId,
    'date': date,
    'time': time,
    'status': status,
    'diagnosis': diagnosis,
    'notes': notes,
    'prescriptions': prescriptions.map((e) => e.toJson()).toList(),
    'lab_tests': labTests.map((e) => e.toJson()).toList(),
  };
}

class PrescriptionItem {
  final String medicineId;
  final String medicineName;
  final String frequency;
  final int days;
  final String instructions;
  int quantity; // ✅ remove final
  final double price;

  PrescriptionItem({
    required this.medicineId,
    required this.medicineName,
    required this.frequency,
    required this.days,
    required this.instructions,
    required this.quantity,
    required this.price,
  });

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      medicineId: json['medicine_id'] ?? '',
      medicineName: json['medicine_name'] ?? '',
      frequency: json['frequency'] ?? '',
      days: json['days'] ?? 0,
      instructions: json['instructions'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'frequency': frequency,
    'days': days,
    'instructions': instructions,
    'quantity': quantity,
    'price': price,
  };
}

class LabTest {
  final String category;
  final String testName;
  final String instructions;

  LabTest({
    required this.category,
    required this.testName,
    required this.instructions,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      category: json['category'] ?? '',
      testName: json['test_name'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'test_name': testName,
    'instructions': instructions,
  };
}
