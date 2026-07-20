import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../doctor_basic_details/dummy_data_5.dart';
import '../doctor_basic_details/doctor_basic_details.dart';
import '../medical_records/dummy_data_7.dart';
import 'assignment_picker.dart';
import 'doctor_registry.dart';

const Color _kBlue = DoctorColors.primaryVivid;
const Color _kGreen = DoctorColors.successTeal;

/// Manage the main doctor and hired sub-doctors, and assign each of them to
/// one or more hospitals/clinics (many-to-many).
class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final _registry = DoctorRegistry.instance;

  @override
  void initState() {
    super.initState();
    _registry.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  // ── Helpers ───────────────────────────────────────────
  void _snack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _clinicName(String id) {
    for (final h in initialHospitals) {
      if (h.id == id) return h.name;
    }
    return 'Clinic';
  }

  // ── Actions ───────────────────────────────────────────
  void _editMainDoctor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorBasicDetailsScreen(title: 'Main Doctor'),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _addSubDoctor() {
    final form = DoctorFormData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorBasicDetailsScreen(
          title: 'Add Doctor',
          initialForm: form,
          showSignature: false,
          onSaved: () => _registry.addSubDoctor(form),
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _editSubDoctor(HiredDoctor doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorBasicDetailsScreen(
          title: 'Edit Doctor',
          initialForm: doc.form,
          showSignature: false,
          onSaved: () => _registry.save(),
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _deleteSubDoctor(HiredDoctor doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete doctor?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        content: Text(
          'This will remove ${doc.displayName} and their clinic assignments.',
          style: const TextStyle(
              fontSize: 14, color: DoctorColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: DoctorColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: DoctorColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              _registry.removeDoctor(doc.id);
              Navigator.pop(ctx);
              setState(() {});
              _snack('Doctor deleted', DoctorColors.error);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _assignClinics(HiredDoctor doc) async {
    if (initialHospitals.isEmpty) {
      _snack('Add a hospital first, then assign', DoctorColors.warningOrange);
      return;
    }
    final result = await showAssignmentPicker(
      context: context,
      heading: 'Assign Clinics — ${doc.displayName}',
      icon: Icons.local_hospital_rounded,
      accent: _kGreen,
      items: initialHospitals
          .map((h) => PickerItem(
              id: h.id,
              title: h.name,
              subtitle: h.type.isNotEmpty ? '${h.category} · ${h.type}' : h.category))
          .toList(),
      selected: _registry.hospitalsForDoctor(doc.id),
      emptyMessage: 'No hospitals yet. Add one from Hospital List.',
    );
    if (result != null) {
      _registry.setHospitalsForDoctor(doc.id, result);
      setState(() {});
      _snack('Clinics updated for ${doc.displayName}',
          DoctorColors.successDeep);
    }
  }

  // ── Build ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final main = _registry.mainDoctor;
    final subs = _registry.subDoctors;

    return Scaffold(
      backgroundColor: DoctorColors.backgroundCream,
      body: Column(
        children: [
          const CurvedHeader(title: 'DOCTORS'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    icon: Icons.badge_rounded,
                    title: 'Main Doctor',
                    count: 1,
                  ),
                  const SizedBox(height: 12),
                  _doctorCard(main, isMain: true),
                  const SizedBox(height: 24),
                  _sectionHeader(
                    icon: Icons.groups_rounded,
                    title: 'Hired Doctors',
                    count: subs.length,
                    trailing: _addNewButton(),
                  ),
                  const SizedBox(height: 12),
                  if (subs.isEmpty)
                    _emptyState('No hired doctors yet',
                        'Tap "Add New" to add a doctor for your clinics')
                  else
                    ...subs.map((d) => _doctorCard(d, isMain: false)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required int count,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _kBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: DoctorColors.textPrimary,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: DoctorColors.primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: DoctorColors.primaryBrand,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _addNewButton() {
    return GestureDetector(
      onTap: _addSubDoctor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _kGreen,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _kGreen.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text('Add New',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard(HiredDoctor doc, {required bool isMain}) {
    final clinics = _registry.hospitalsForDoctor(doc.id).toList();
    final subtitle = doc.subtitle;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isMain ? _kBlue : _kGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                    isMain ? Icons.badge_rounded : Icons.person_rounded,
                    color: Colors.white,
                    size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                            color: DoctorColors.textPrimary)),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              color: DoctorColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
              _iconAction(Icons.edit_rounded, DoctorColors.primaryBrand,
                  DoctorColors.primarySoft,
                  () => isMain ? _editMainDoctor() : _editSubDoctor(doc)),
              if (!isMain) ...[
                const SizedBox(width: 6),
                _iconAction(Icons.delete_rounded, DoctorColors.error,
                    DoctorColors.errorSoftBg, () => _deleteSubDoctor(doc)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Assigned clinics + assign action
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.local_hospital_rounded,
                    size: 14, color: DoctorColors.successTeal),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: clinics.isEmpty
                    ? const Text('No clinics assigned',
                        style: TextStyle(
                            fontSize: 12,
                            color: DoctorColors.textMuted,
                            fontWeight: FontWeight.w600))
                    : Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: clinics
                            .map((id) => _clinicChip(_clinicName(id)))
                            .toList(),
                      ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _assignClinics(doc),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: DoctorColors.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link_rounded,
                          size: 14, color: DoctorColors.primaryBrand),
                      SizedBox(width: 4),
                      Text('Assign',
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: DoctorColors.primaryBrand)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _clinicChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _kGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration({double radius = 16}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: DoctorColors.dividerCool),
      boxShadow: [
        BoxShadow(
          color: DoctorColors.primaryBrand.withOpacity(0.06),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _iconAction(
      IconData icon, Color color, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DoctorColors.dividerCool),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_rounded,
              size: 34, color: DoctorColors.avatarGrey),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: DoctorColors.textPrimary)),
          const SizedBox(height: 3),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, color: DoctorColors.textSecondary)),
        ],
      ),
    );
  }
}
