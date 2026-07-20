import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../doctor_basic_details/dummy_data_5.dart';

// ════════════════════════════════════════════════════════
//  HIRED DOCTOR MODEL
//  Wraps a DoctorFormData (the reused Basic-Details form) plus the
//  set of hospitals/clinics the doctor is assigned to (many-to-many).
// ════════════════════════════════════════════════════════

class HiredDoctor {
  /// 'main' for the account owner, 'doc_<ts>' for hired sub-doctors.
  final String id;

  /// True for the single account-owner doctor.
  final bool isMain;

  /// The shared Basic-Details form used for both main and sub doctors.
  DoctorFormData form;

  /// Ids of the hospitals this doctor works at.
  Set<String> hospitalIds;

  HiredDoctor({
    required this.id,
    required this.form,
    this.isMain = false,
    Set<String>? hospitalIds,
  }) : hospitalIds = hospitalIds ?? <String>{};

  String get displayName {
    final n = '${form.firstName} ${form.lastName}'.trim();
    if (n.isNotEmpty) return n;
    return isMain ? 'Main Doctor' : 'Unnamed Doctor';
  }

  /// Qualification + specialisation, e.g. "MBBS • Dental, Cardiology".
  String get subtitle {
    final parts = <String>[];
    final q = form.qualification;
    if (q != null && q.isNotEmpty) {
      parts.add(
        qualificationOptions
            .firstWhere((o) => o.value == q,
                orElse: () => DropdownOption(value: q, label: q))
            .label,
      );
    }
    if (form.specialisations.isNotEmpty) {
      parts.add(form.specialisations.join(', '));
    }
    return parts.join('  •  ');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isMain': isMain,
        'form': form.toJson(),
        'hospitalIds': hospitalIds.toList(),
      };

  static HiredDoctor fromJson(Map<String, dynamic> j) => HiredDoctor(
        id: j['id'] as String,
        isMain: (j['isMain'] as bool?) ?? false,
        form: DoctorFormData.fromJson(
            (j['form'] as Map).cast<String, dynamic>()),
        hospitalIds: ((j['hospitalIds'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet(),
      );
}

// ════════════════════════════════════════════════════════
//  DOCTOR REGISTRY
//  Single source of truth for the main doctor, hired sub-doctors and
//  the doctor <-> hospital assignments. Persisted to secure storage.
// ════════════════════════════════════════════════════════

class DoctorRegistry {
  DoctorRegistry._();
  static final DoctorRegistry instance = DoctorRegistry._();

  static const _key = 'doctor_registry';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  final List<HiredDoctor> doctors = <HiredDoctor>[];
  bool _loaded = false;

  /// The account-owner doctor. Created lazily if it doesn't exist yet.
  HiredDoctor get mainDoctor {
    for (final d in doctors) {
      if (d.isMain) return d;
    }
    final m = HiredDoctor(id: 'main', form: DoctorFormData(), isMain: true);
    doctors.insert(0, m);
    return m;
  }

  List<HiredDoctor> get subDoctors =>
      doctors.where((d) => !d.isMain).toList();

  HiredDoctor? byId(String id) {
    for (final d in doctors) {
      if (d.id == id) return d;
    }
    return null;
  }

  // ── CRUD ──────────────────────────────────────────────
  HiredDoctor addSubDoctor(DoctorFormData form) {
    final doc = HiredDoctor(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      form: form,
    );
    doctors.add(doc);
    save();
    return doc;
  }

  void removeDoctor(String id) {
    doctors.removeWhere((d) => d.id == id && !d.isMain);
    save();
  }

  // ── Assignment (many-to-many) ─────────────────────────
  Set<String> hospitalsForDoctor(String doctorId) =>
      byId(doctorId)?.hospitalIds ?? <String>{};

  List<HiredDoctor> doctorsForHospital(String hospitalId) =>
      doctors.where((d) => d.hospitalIds.contains(hospitalId)).toList();

  /// Assign from the doctor side.
  void setHospitalsForDoctor(String doctorId, Set<String> hospitalIds) {
    final d = byId(doctorId);
    if (d == null) return;
    d.hospitalIds = <String>{...hospitalIds};
    save();
  }

  /// Assign from the hospital side.
  void setDoctorsForHospital(String hospitalId, Set<String> doctorIds) {
    for (final d in doctors) {
      if (doctorIds.contains(d.id)) {
        d.hospitalIds.add(hospitalId);
      } else {
        d.hospitalIds.remove(hospitalId);
      }
    }
    save();
  }

  /// Called when a hospital is deleted — drops it from every doctor.
  void removeHospital(String hospitalId) {
    for (final d in doctors) {
      d.hospitalIds.remove(hospitalId);
    }
    save();
  }

  // ── Persistence ───────────────────────────────────────
  Future<void> save() async {
    try {
      final payload =
          jsonEncode(doctors.map((d) => d.toJson()).toList());
      await _storage.write(key: _key, value: payload);
    } catch (_) {
      // Best-effort persistence; ignore storage errors.
    }
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final raw = await _storage.read(key: _key);
      if (raw != null && raw.isNotEmpty) {
        final list = jsonDecode(raw) as List;
        doctors
          ..clear()
          ..addAll(list.map(
              (e) => HiredDoctor.fromJson((e as Map).cast<String, dynamic>())));
      }
    } catch (_) {
      // Corrupt/old payload — start fresh.
    }
    if (!doctors.any((d) => d.isMain)) {
      doctors.insert(
          0, HiredDoctor(id: 'main', form: DoctorFormData(), isMain: true));
    }
  }
}
