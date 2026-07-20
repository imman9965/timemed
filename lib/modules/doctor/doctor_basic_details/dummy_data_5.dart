import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../theme/doctor_theme.dart';



// ════════════════════════════════════════════════════════
//  APP DIMENSIONS
// ════════════════════════════════════════════════════════

class AppDimens1 {
  static const xs  = 4.0;
  static const s   = 8.0;
  static const m   = 12.0;
  static const l   = 16.0;
  static const xl  = 20.0;
  static const xxl = 24.0;
  static const radiusMd       = 10.0;
  static const inputHeight    = 46.0;
  static const screenHPadding = 20.0;
}



class AppTextStyles {
  static final sectionLabel = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: DoctorColors.textDark);
  static final inputHint = TextStyle(
      fontSize: 14, color: DoctorColors.textMuted);
  static final inputText = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: DoctorColors.textDark);
  static final chipLabel = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white);
}

// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

enum Gender { male, female, others }

class DropdownOption {
  final String value;
  final String label;
  const DropdownOption({required this.value, required this.label});
}

class DoctorFormData {
  String       firstName      = '';
  String       lastName       = '';
  DateTime?    dateOfBirth;
  Gender       gender         = Gender.male;
  String       mobile         = '';
  String       email          = '';
  int          experience     = 0;
  String?      qualification;
  List<String> specialisations = ['Dental', 'Cardiology'];
  String?      category;
  List<String> languages      = ['Tamil'];
  String       address        = '';

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender.index,
        'mobile': mobile,
        'email': email,
        'experience': experience,
        'qualification': qualification,
        'specialisations': specialisations,
        'category': category,
        'languages': languages,
        'address': address,
      };

  static DoctorFormData fromJson(Map<String, dynamic> j) {
    final f = DoctorFormData();
    f.firstName = (j['firstName'] as String?) ?? '';
    f.lastName = (j['lastName'] as String?) ?? '';
    final dob = j['dateOfBirth'] as String?;
    f.dateOfBirth =
        (dob != null && dob.isNotEmpty) ? DateTime.tryParse(dob) : null;
    final gi = j['gender'];
    f.gender = (gi is int && gi >= 0 && gi < Gender.values.length)
        ? Gender.values[gi]
        : Gender.male;
    f.mobile = (j['mobile'] as String?) ?? '';
    f.email = (j['email'] as String?) ?? '';
    f.experience = (j['experience'] as num?)?.toInt() ?? 0;
    f.qualification = j['qualification'] as String?;
    f.specialisations =
        (j['specialisations'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];
    f.category = j['category'] as String?;
    f.languages =
        (j['languages'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];
    f.address = (j['address'] as String?) ?? '';
    return f;
  }

  /// Deep copy via JSON round-trip.
  DoctorFormData copy() => DoctorFormData.fromJson(toJson());
}

// ════════════════════════════════════════════════════════
//  DOCTOR SIGNATURE (shared across basic-details & prescription)
// ════════════════════════════════════════════════════════

/// Holds the doctor's hand-drawn signature (as freehand strokes) together with
/// the printed name / qualification shown beneath it. A single shared instance
/// ([doctorSignature]) is captured on the Basic Details screen and read back on
/// the Prescription screen and its template detail view.
class DoctorSignatureData {
  /// Each entry is one continuous pen stroke (a list of points).
  List<List<Offset>> strokes;
  String doctorName;
  String qualification;
  String specialisation;
  String clinic;
  String regNo;
  String city;

  DoctorSignatureData({
    List<List<Offset>>? strokes,
    required this.doctorName,
    required this.qualification,
    this.specialisation = '',
    this.clinic = 'TimesMed Hospital',
    this.regNo = '',
    this.city = '',
  }) : strokes = strokes ?? <List<Offset>>[];

  /// True once the doctor has actually drawn something.
  bool get hasDrawing => strokes.any((s) => s.isNotEmpty);

  void clear() => strokes = <List<Offset>>[];

  /// Copy the saved Basic-Details form into this shared store so the
  /// prescription template shows the real doctor details.
  void updateFrom(DoctorFormData form) {
    final name = '${form.firstName} ${form.lastName}'.trim();
    if (name.isNotEmpty) doctorName = name;
    final qual = form.qualification == null
        ? ''
        : qualificationOptions
            .firstWhere((o) => o.value == form.qualification,
                orElse: () => DropdownOption(
                    value: form.qualification!, label: form.qualification!))
            .label;
    if (qual.isNotEmpty) qualification = qual;
    specialisation = form.specialisations.join(', ');
    if (form.address.trim().isNotEmpty) city = form.address.trim();
  }

  Map<String, dynamic> toJson() => {
        'doctorName': doctorName,
        'qualification': qualification,
        'specialisation': specialisation,
        'clinic': clinic,
        'regNo': regNo,
        'city': city,
        'strokes': strokes
            .map((s) => s.map((p) => [p.dx, p.dy]).toList())
            .toList(),
      };

  void applyJson(Map<String, dynamic> j) {
    doctorName = (j['doctorName'] as String?) ?? doctorName;
    qualification = (j['qualification'] as String?) ?? qualification;
    specialisation = (j['specialisation'] as String?) ?? specialisation;
    clinic = (j['clinic'] as String?) ?? clinic;
    regNo = (j['regNo'] as String?) ?? regNo;
    city = (j['city'] as String?) ?? city;
    final st = j['strokes'];
    if (st is List) {
      strokes = st
          .map<List<Offset>>((s) => (s as List)
              .map<Offset>((p) => Offset(
                  (p[0] as num).toDouble(), (p[1] as num).toDouble()))
              .toList())
          .toList();
    }
  }
}

/// Tiny local-DB layer: persists the doctor profile to secure on-device
/// storage so the prescription letterhead keeps the saved details across
/// app restarts.
class DoctorProfileStore {
  DoctorProfileStore._();
  static const _key = 'doctor_profile';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> save() async {
    await _storage.write(key: _key, value: jsonEncode(doctorSignature.toJson()));
  }

  static Future<void> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return;
    try {
      doctorSignature.applyJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt/old payload — ignore and keep defaults.
    }
  }
}

/// Shared, dummy-seeded signature. Name + qualification are pre-filled so the
/// prescription always has details to show; once the doctor saves the Basic
/// Details form these are overwritten with the real values via [updateFrom].
final DoctorSignatureData doctorSignature = DoctorSignatureData(
  doctorName: 'Mariappan',
  qualification: 'MBBS, MD (General Medicine)',
  specialisation: 'General Medicine',
  clinic: 'TimesMed Hospital',
  regNo: 'TNMC 12345',
  city: 'Chennai',
);

// ════════════════════════════════════════════════════════
//  DUMMY PATIENT + ADVICE (prescription template)
// ════════════════════════════════════════════════════════
class PatientInfo {
  final String name;
  final String age;
  final String gender;
  const PatientInfo({
    required this.name,
    required this.age,
    required this.gender,
  });
}

const PatientInfo dummyPatient = PatientInfo(
  name: 'Kumar',
  age: '32',
  gender: 'Male',
);

const List<String> prescriptionAdvice = [
  'Drink plenty of water',
  'Take complete medication',
];

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

const List<Gender> genderOptions = [
  Gender.male, Gender.female, Gender.others,
];

const List<DropdownOption> qualificationOptions = [
  DropdownOption(value: 'mbbs', label: 'MBBS'),
  DropdownOption(value: 'bds',  label: 'BDS'),
  DropdownOption(value: 'md',   label: 'MD'),
  DropdownOption(value: 'ms',   label: 'MS'),
  DropdownOption(value: 'bams', label: 'BAMS'),
  DropdownOption(value: 'bhms', label: 'BHMS'),
];

const List<DropdownOption> categoryOptions = [
  DropdownOption(value: 'allergist',         label: 'Allergist'),
  DropdownOption(value: 'anesthesiologist',  label: 'Anesthesiologist'),
  DropdownOption(value: 'audiologist',       label: 'Audiologist'),
  DropdownOption(value: 'cardiologist',      label: 'Cardiologist'),
  DropdownOption(value: 'dermatologist',     label: 'Dermatologist'),
  DropdownOption(value: 'endocrinologist',   label: 'Endocrinologist'),
  DropdownOption(value: 'neurologist',       label: 'Neurologist'),
  DropdownOption(value: 'pediatrician',      label: 'Pediatrician'),
];

const List<String> specialisationSuggestions = [
  'Dental','Cardiology','Neurology','Orthopedics',
  'Pediatrics','Dermatology','Ophthalmology','ENT',
  'Gynecology','Pulmonology','Psychiatry','Radiology',
];

const List<DropdownOption> languageOptions = [
  DropdownOption(value: 'tamil',     label: 'Tamil'),
  DropdownOption(value: 'english',   label: 'English'),
  DropdownOption(value: 'hindi',     label: 'Hindi'),
  DropdownOption(value: 'telugu',    label: 'Telugu'),
  DropdownOption(value: 'kannada',   label: 'Kannada'),
  DropdownOption(value: 'malayalam', label: 'Malayalam'),
];

const List<String> addressSuggestions = [
  'Chennai, Tamilnadu',
  'Coimbatore, Tamilnadu',
  'Madurai, Tamilnadu',
  'Bangalore, Karnataka',
  'Mumbai, Maharashtra',
  'Delhi, India',
  'Hyderabad, Telangana',
];