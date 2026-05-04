import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/widgets/theme.dart';
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
  // In-memory data. Replace with your repository / Bloc / Riverpod / API.
  final List<ClinicalNote> _notes = [
    ClinicalNote(
      id: '1',
      dateTime: DateTime(2025, 1, 24, 15, 32),
      height: 156,
      weight: 55,
      pulse: 89,
      temperature: 90,
      diseaseComplaints: 'Mild fever and headache for 2 days',
      diagnosis: 'fever',
    ),
    ClinicalNote(
      id: '2',
      dateTime: DateTime(2025, 1, 20, 18, 49),
      height: 156,
      weight: 55,
      pulse: 78,
      temperature: 98,
      diseaseComplaints: 'Sore throat',
    ),
    ClinicalNote(
      id: '3',
      dateTime: DateTime(2025, 1, 20, 18, 7),
      height: 156,
      weight: 55,
      pulse: 82,
      temperature: 99,
      diseaseComplaints: 'Routine check-up',
    ),
  ];

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
            style: TextButton.styleFrom(foregroundColor: AppColors100.deleteRed),
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
      backgroundColor: AppColors100.background,
      body: SafeArea(
        child: Column(
          children: [
             CurvedHeader(title: 'CLINICAL NOTES'),
            Expanded(
              child: _notes.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: _notes.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 14),
                itemBuilder: (_, i) => _buildNoteCard(_notes[i]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
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
                backgroundColor: AppColors100.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
                shadowColor: AppColors100.primary.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined,
              size: 72, color: AppColors100.textHint),
          const SizedBox(height: 12),
          const Text(
            'No clinical notes yet',
            style: TextStyle(
              fontSize: 16,
              color: AppColors100.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(ClinicalNote note) {
    return InkWell(
      onTap: () => _openDetail(note),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors100.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors100.fieldBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors100.primary.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: AppColors100.iconBlue),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(note.dateTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors100.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 18, color: AppColors100.iconBlue),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(note.dateTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors100.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    note.diseaseComplaints.isEmpty
                        ? 'Disease Complaints:'
                        : 'Disease Complaints: ${note.diseaseComplaints}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors100.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _circleAction(
              bg: AppColors100.editTealBg,
              borderColor: AppColors100.editTeal,
              icon: Icons.edit_outlined,
              iconColor: AppColors100.editTeal,
              onTap: () => _openForm(existing: note),
            ),
            const SizedBox(width: 8),
            _circleAction(
              bg: AppColors100.deleteRedBg,
              borderColor: AppColors100.deleteRed,
              icon: Icons.delete_outline,
              iconColor: AppColors100.deleteRed,
              onTap: () => _confirmDelete(note),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors100.textHint),
          ],
        ),
      ),
    );
  }

  Widget _circleAction({
    required Color bg,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor.withOpacity(0.4)),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}
