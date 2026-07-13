import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_details_dialog.dart';
import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';


final List<PrescriptionTemplate> templates = [
  PrescriptionTemplate(
    id: '1',
    name: 'Template-1',
    description: 'template description',
    date: DateTime(2025, 1, 20),
  ),
  PrescriptionTemplate(
    id: '2',
    name: 'Template-2',
    description: 'Common cold and fever prescription',
    date: DateTime(2025, 1, 22),
  ),
  PrescriptionTemplate(
    id: '3',
    name: 'Template-3',
    description: 'Diabetes follow-up with HbA1c review',
    date: DateTime(2025, 2, 5),
  ),
  PrescriptionTemplate(
    id: '4',
    name: 'Template-4',
    description: 'Hypertension daily medication',
    date: DateTime(2025, 2, 12),
  ),
  PrescriptionTemplate(
    id: '5',
    name: 'Template-5',
    description: 'Pediatric viral fever protocol',
    date: DateTime(2025, 3, 1),
  ),
  PrescriptionTemplate(
    id: '6',
    name: 'Template-6',
    description: 'Post-surgery antibiotic regimen',
    date: DateTime(2025, 3, 15),
  ),
];

/// Maps template IDs to their drug lists (mock data).
final Map<String, List<TemplateDrug>> templateDrugsMap = {
  '1': const [
    TemplateDrug(name: 'itraconazolwe', frequency: '1-1-0-1', days: 1, qty: 2, foodRelation: 'Before Food'),
    TemplateDrug(name: 'DOXYCYCLINE', frequency: '1-0-0-1', days: 3, qty: 3, foodRelation: 'After Food'),
  ],
  '2': const [
    TemplateDrug(name: 'Paracetamol 500mg', frequency: '1-1-1', days: 3, qty: 9, foodRelation: 'After Food'),
    TemplateDrug(name: 'Cetirizine 10mg', frequency: '0-0-1', days: 5, qty: 5, foodRelation: 'After Food'),
    TemplateDrug(name: 'Amoxicillin 250mg', frequency: '1-1-1', days: 5, qty: 15, foodRelation: 'After Food'),
  ],
  '3': const [
    TemplateDrug(name: 'Metformin 500mg', frequency: '1-0-1', days: 30, qty: 60, foodRelation: 'After Food'),
    TemplateDrug(name: 'Atorvastatin 10mg', frequency: '0-0-1', days: 30, qty: 30, foodRelation: 'After Food'),
  ],
  '4': const [
    TemplateDrug(name: 'Amlodipine 5mg', frequency: '1-0-0', days: 30, qty: 30, foodRelation: 'Before Food'),
    TemplateDrug(name: 'Losartan 50mg', frequency: '1-0-0', days: 30, qty: 30, foodRelation: 'Before Food'),
  ],
  '5': const [
    TemplateDrug(name: 'Paracetamol 500mg', frequency: '1-1-1', days: 3, qty: 9, foodRelation: 'After Food'),
    TemplateDrug(name: 'Cetirizine 10mg', frequency: '0-0-1', days: 3, qty: 3, foodRelation: 'After Food'),
  ],
  '6': const [
    TemplateDrug(name: 'Amoxicillin 250mg', frequency: '1-1-1', days: 7, qty: 21, foodRelation: 'After Food'),
    TemplateDrug(name: 'Diclofenac 50mg', frequency: '1-0-1', days: 5, qty: 10, foodRelation: 'After Food'),
    TemplateDrug(name: 'Pantoprazole 40mg', frequency: '1-0-0', days: 7, qty: 7, foodRelation: 'Before Food'),
  ],
};

class TemplateListScreen extends StatefulWidget {
  const TemplateListScreen({super.key});

  @override
  State<TemplateListScreen> createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends State<TemplateListScreen> {
  // ---------- Dummy data ----------


  final Set<String> _selectedIds = {};

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _viewTemplate(PrescriptionTemplate t) {
    final drugs = templateDrugsMap[t.id] ?? [];
    showDialog(
      context: context,
      builder: (_) => TemplateDetailDialog(
        templateName: t.name,
        drugs: List<TemplateDrug>.from(drugs),
      ),
    );
  }

  Future<void> _onDelete() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select templates to delete')),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Templates?'),
        content: Text(
          'Delete ${_selectedIds.length} selected template${_selectedIds.length > 1 ? 's' : ''}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: DoctorColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        for (final id in _selectedIds) {
          templateDrugsMap.remove(id);
        }
        templates.removeWhere((t) => _selectedIds.contains(t.id));
        _selectedIds.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Templates deleted')),
        );
      }
    }
  }

  void _onSelect() {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a template')),
      );
      return;
    }
    // Collect all drugs from selected templates
    final List<TemplateDrug> allDrugs = [];
    for (final id in _selectedIds) {
      final drugs = templateDrugsMap[id];
      if (drugs != null) {
        allDrugs.addAll(drugs);
      }
    }
    context.pop(allDrugs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: SafeArea(
        child: Column(
          children: [
            CurvedHeader(title: "TEMPLATE"),
            Expanded(
              child: templates.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                itemCount: templates.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (_, i) => _buildTemplateCard(templates[i]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DoctorColors.errorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DoctorColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selectedIds.isEmpty
                          ? 'Select'
                          : 'Select (${_selectedIds.length})',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------

  // ---------- Empty ----------
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: DoctorColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.description_outlined,
                size: 40, color: DoctorColors.primary),
          ),
          const SizedBox(height: 12),
          const Text(
            'No templates yet',
            style: TextStyle(color: DoctorColors.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ---------- Card ----------
  Widget _buildTemplateCard(PrescriptionTemplate t) {
    final isSelected = _selectedIds.contains(t.id);
    return InkWell(
      onTap: () => _toggleSelection(t.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? DoctorColors.primary : DoctorColors.fieldBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: DoctorColors.primary.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Checkbox
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                child: _buildCheckbox(isSelected),
              ),
              // Vertical divider
              Container(
                width: 1,
                color: DoctorColors.fieldBorder,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
              // Name + description
              Expanded(
                flex: 5,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: DoctorColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: DoctorColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Vertical divider
              Container(
                width: 1,
                color: DoctorColors.fieldBorder,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
              // Date
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: DoctorColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _formatDate(t.date),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: DoctorColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // View eye button
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _viewTemplate(t),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: DoctorColors.successLightBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: DoctorColors.primary.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.visibility_outlined,
                          color: DoctorColors.success, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? DoctorColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: selected ? DoctorColors.primary : DoctorColors.fieldBorder,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}

// ============================================================
// Internal model
// ============================================================
class PrescriptionTemplate {
  final String id;
  final String name;
  final String description;
  final DateTime date;

  PrescriptionTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'date': date.toIso8601String(),
  };
}

// ============================================================
// Preview dialog (when eye icon tapped)
// ============================================================
class _TemplatePreviewDialog extends StatelessWidget {
  final PrescriptionTemplate template;
  const _TemplatePreviewDialog({required this.template});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [DoctorColors.primaryDark, DoctorColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'TEMPLATE PREVIEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: DoctorColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: DoctorColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        '${template.date.month}/${template.date.day.toString().padLeft(2, '0')}/${template.date.year}',
                        style: const TextStyle(
                          color: DoctorColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 13,
                      color: DoctorColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    template.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: DoctorColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
