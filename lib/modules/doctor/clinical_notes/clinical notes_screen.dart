import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import 'clinical_notes_details_screen.dart';
import 'clinical_notes_form_screen.dart';
import 'dummy.dart';


class ClinicalNotesListScreen extends StatefulWidget {
  const ClinicalNotesListScreen({super.key});

  @override
  State<ClinicalNotesListScreen> createState() =>
      _ClinicalNotesListScreenState();
}

class _ClinicalNotesListScreenState extends State<ClinicalNotesListScreen> {
  final List<ClinicalNote> _notes = [];

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}-${two(dt.month)}-${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final hour12 = dt.hour == 0
        ? 12
        : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final mm = dt.minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$mm $period';
  }

  Future<void> _openDetail(ClinicalNote note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClinicalNoteDetailScreen(note: note),
      ),
    );
  }

  Future<void> _openForm({ClinicalNote? existing}) async {
    // Enforce a single clinical note: block adding when one already exists.
    if (existing == null && _notes.isNotEmpty) return;
    final result = await Navigator.push<ClinicalNote>(
      context,
      MaterialPageRoute(
        builder: (_) => ClinicalNoteFormScreen(existing: existing),
      ),
    );
    if (result == null) return;
    setState(() {
      final idx = _notes.indexWhere((n) => n.id == result.id);
      if (idx >= 0) {
        _notes[idx] = result;
      } else {
        _notes.insert(0, result);
      }
    });
  }

  Future<void> _confirmDelete(ClinicalNote note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Note?'),
        content: Text(
          'Delete the note from ${_formatDate(note.dateTime)}? '
              'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: DoctorColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _notes.removeWhere((n) => n.id == note.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
           CurvedHeader(title: 'CLINICAL NOTES',titleStyle: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),),
          Expanded(
            child: _notes.isEmpty
                ? _buildEmpty()
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: _notes.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 14),
              itemBuilder: (_, i) => _buildNoteCard(_notes[i]),
            ),
          ),
        ],
      ),
      // Only one clinical note is allowed. The "Add" button is shown
      // exclusively when no note exists yet; once a note is added it can
      // only be edited or deleted (no adding multiple notes).
      bottomNavigationBar: _notes.isEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Clinical Note',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DoctorColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                      shadowColor: DoctorColors.primaryBrand.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined,
              size: 72, color: DoctorColors.textHint),
          const SizedBox(height: 12),
          const Text(
            'No clinical notes yet',
            style: TextStyle(
              fontSize: 16,
              color: DoctorColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(ClinicalNote note) {
    final details = <Map<String, dynamic>>[
      {'label': 'Disease Complaints', 'value': note.diseaseComplaints, 'icon': Icons.sick_outlined, 'color': DoctorColors.error},
      {'label': 'Allergies', 'value': note.allergies, 'icon': Icons.warning_amber_rounded, 'color': DoctorColors.warningPending},
      {'label': 'Symptoms', 'value': note.symptoms, 'icon': Icons.healing_outlined, 'color': DoctorColors.purple},
      {'label': 'Diagnosis', 'value': note.diagnosis, 'icon': Icons.medical_information_outlined, 'color': DoctorColors.primaryBrand},
      {'label': 'Causes', 'value': note.causes, 'icon': Icons.search_outlined, 'color': DoctorColors.successTeal},
      {'label': 'Investigation', 'value': note.investigation, 'icon': Icons.science_outlined, 'color': DoctorColors.primaryDeep},
    ].where((d) => (d['value'] as String).trim().isNotEmpty).toList();

    return InkWell(
      onTap: () => {},
      borderRadius: BorderRadius.circular(18),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: DoctorColors.fieldBorder),
          boxShadow: [
            BoxShadow(
              color: DoctorColors.primaryBrand.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gradient header band: date + time, with edit/delete ──
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: DoctorColors1.gradPrimary,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.event_note_outlined,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(note.dateTime),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 13,
                                color: Colors.white.withOpacity(0.85)),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(note.dateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _headerBtn(
                    icon: Icons.edit_outlined,
                    onTap: () => _openForm(existing: note),
                  ),
                  const SizedBox(width: 8),
                  _headerBtn(
                    icon: Icons.delete_outline,
                    onTap: () => _confirmDelete(note),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Vitals: 4 colour-coded stat tiles ──
                  Row(
                    children: [
                      Expanded(
                          child: _vitalTile(Icons.height, 'Height',
                              note.height.toStringAsFixed(0), 'cm',
                              DoctorColors.primaryBrand)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _vitalTile(Icons.monitor_weight_outlined,
                              'Weight', note.weight.toStringAsFixed(0), 'kg',
                              DoctorColors.successTeal)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _vitalTile(Icons.favorite_outline, 'Pulse',
                              '${note.pulse}', '/min', DoctorColors.error)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _vitalTile(Icons.thermostat_outlined, 'Temp',
                              note.temperature.toStringAsFixed(0), 'c',
                              DoctorColors.warningPending)),
                    ],
                  ),

                  // ── Text details ──
                  if (details.isNotEmpty) const SizedBox(height: 4),
                  for (var i = 0; i < details.length; i++)
                    _detailBlock(
                      details[i]['icon'] as IconData,
                      details[i]['label'] as String,
                      details[i]['value'] as String,
                      details[i]['color'] as Color,
                      showDivider: i != details.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vitalTile(
      IconData icon, String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: DoctorColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 10,
                      color: DoctorColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: DoctorColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBlock(IconData icon, String label, String value, Color color,
      {required bool showDivider}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: DoctorColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: DoctorColors.fieldBorder),
        ],
      ],
    );
  }

  Widget _headerBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 19, color: Colors.white),
        ),
      ),
    );
  }
}
