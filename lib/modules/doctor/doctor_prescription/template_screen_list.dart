import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_details_dialog.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_editor.dart';
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
  final Set<String> _selectedIds = {};
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ---------- Helpers ----------
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime dt) =>
      '${dt.day} ${_months[dt.month - 1]} ${dt.year}';

  List<PrescriptionTemplate> get _filtered {
    if (_query.trim().isEmpty) return templates;
    final q = _query.toLowerCase();
    return templates
        .where((t) =>
            t.name.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q))
        .toList();
  }

  int _drugCount(String id) => templateDrugsMap[id]?.length ?? 0;

  String _newId() {
    var max = 0;
    for (final t in templates) {
      final n = int.tryParse(t.id) ?? 0;
      if (n > max) max = n;
    }
    return '${max + 1}';
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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

  // ---------- CRUD ----------
  Future<void> _createTemplate() async {
    final result = await showTemplateEditor(context);
    if (result == null) return;
    final id = _newId();
    setState(() {
      templates.insert(
        0,
        PrescriptionTemplate(
          id: id,
          name: result.name,
          description: result.description,
          date: DateTime.now(),
        ),
      );
      templateDrugsMap[id] = result.drugs;
    });
    _snack('Template created');
  }

  Future<void> _editTemplate(PrescriptionTemplate t) async {
    final result = await showTemplateEditor(
      context,
      initialName: t.name,
      initialDescription: t.description,
      initialDrugs: templateDrugsMap[t.id],
    );
    if (result == null) return;
    final index = templates.indexWhere((e) => e.id == t.id);
    if (index == -1) return;
    setState(() {
      templates[index] = PrescriptionTemplate(
        id: t.id,
        name: result.name,
        description: result.description,
        date: t.date,
      );
      templateDrugsMap[t.id] = result.drugs;
    });
    _snack('Template updated');
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

  Future<void> _deleteOne(PrescriptionTemplate t) async {
    final confirmed = await _confirmDelete(
      title: 'Delete Template?',
      message: 'Delete "${t.name}"? This cannot be undone.',
    );
    if (confirmed != true) return;
    setState(() {
      templateDrugsMap.remove(t.id);
      templates.removeWhere((e) => e.id == t.id);
      _selectedIds.remove(t.id);
    });
    _snack('Template deleted');
  }

  Future<void> _deleteSelected() async {
    if (_selectedIds.isEmpty) {
      _snack('Please select templates to delete');
      return;
    }
    final n = _selectedIds.length;
    final confirmed = await _confirmDelete(
      title: 'Delete Templates?',
      message:
          'Delete $n selected template${n > 1 ? 's' : ''}? This cannot be undone.',
    );
    if (confirmed != true) return;
    setState(() {
      for (final id in _selectedIds) {
        templateDrugsMap.remove(id);
      }
      templates.removeWhere((t) => _selectedIds.contains(t.id));
      _selectedIds.clear();
    });
    _snack('Templates deleted');
  }

  Future<bool?> _confirmDelete(
      {required String title, required String message}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
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
  }

  void _onSelect() {
    if (_selectedIds.isEmpty) {
      _snack('Please select a template');
      return;
    }
    final List<TemplateDrug> allDrugs = [];
    for (final id in _selectedIds) {
      final drugs = templateDrugsMap[id];
      if (drugs != null) allDrugs.addAll(drugs);
    }
    context.pop(allDrugs);
  }

  // ======================================================================
  //  BUILD
  // ======================================================================
  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: DoctorColors.background,
      body: Column(
        children: [
          const CurvedHeader(title: "TEMPLATES"),
          _buildSearchBar(),
          _buildCountRow(list.length),
          Expanded(
            child: templates.isEmpty
                ? _buildEmpty(
                    icon: Icons.description_outlined,
                    text: 'No templates yet',
                    subtext: 'Tap + to create your first template',
                  )
                : list.isEmpty
                    ? _buildEmpty(
                        icon: Icons.search_off,
                        text: 'No matching templates',
                        subtext: 'Try a different search',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) => _buildTemplateCard(list[i]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTemplate,
        backgroundColor: DoctorColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Template',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ---------- Search ----------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 14.5, color: DoctorColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search templates...',
          hintStyle:
              const TextStyle(fontSize: 14.5, color: DoctorColors.textSecondary),
          prefixIcon:
              const Icon(Icons.search, color: DoctorColors.textSecondary),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close,
                      color: DoctorColors.textSecondary, size: 20),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                ),
          isDense: true,
          filled: true,
          fillColor: DoctorColors.cardWhite,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: DoctorColors.fieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: DoctorColors.fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: DoctorColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCountRow(int shown) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
      child: Row(
        children: [
          Text(
            '$shown template${shown == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: DoctorColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (_selectedIds.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _selectedIds.clear()),
              child: Row(
                children: [
                  Text(
                    '${_selectedIds.length} selected',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: DoctorColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.close,
                      size: 15, color: DoctorColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Empty ----------
  Widget _buildEmpty({
    required IconData icon,
    required String text,
    required String subtext,
  }) {
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
            child: Icon(icon, size: 38, color: DoctorColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: const TextStyle(
              color: DoctorColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: const TextStyle(
                color: DoctorColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ---------- Card ----------
  Widget _buildTemplateCard(PrescriptionTemplate t) {
    final isSelected = _selectedIds.contains(t.id);
    final drugCount = _drugCount(t.id);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? DoctorColors.primary : DoctorColors.fieldBorder,
          width: isSelected ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DoctorColors.primary.withOpacity(isSelected ? 0.12 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ---- Tappable info area (selects the template) ----
          InkWell(
            onTap: () => _toggleSelection(t.id),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCheckbox(isSelected),
                  const SizedBox(width: 12),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: DoctorColors.primary.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_outlined,
                        color: DoctorColors.primary, size: 23),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: DoctorColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          t.description.isEmpty
                              ? 'No description'
                              : t.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: DoctorColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 9),
                        _buildMetaRow(drugCount, t.date),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: DoctorColors.dividerCool),
          // ---- Action bar: three equal thirds, cannot overflow ----
          Row(
            children: [
              _footerAction(
                icon: Icons.visibility_outlined,
                label: 'View',
                color: DoctorColors.primary,
                onTap: () => _viewTemplate(t),
              ),
              _verticalDivider(),
              _footerAction(
                icon: Icons.edit_outlined,
                label: 'Edit',
                color: DoctorColors.warningPending,
                onTap: () => _editTemplate(t),
              ),
              _verticalDivider(),
              _footerAction(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: DoctorColors.errorRed,
                onTap: () => _deleteOne(t),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(int drugCount, DateTime date) {
    return Row(
      children: [
        const Icon(Icons.medication_outlined,
            size: 14, color: DoctorColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '$drugCount drug${drugCount == 1 ? '' : 's'}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DoctorColors.textSecondary,
          ),
        ),
        Container(
          width: 1,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: DoctorColors.dividerCool,
        ),
        const Icon(Icons.calendar_today_outlined,
            size: 13, color: DoctorColors.textSecondary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            _formatDate(date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DoctorColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 26,
      color: DoctorColors.dividerCool,
    );
  }

  Widget _footerAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: color,
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
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: selected ? DoctorColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
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

  // ---------- Bottom bar ----------
  Widget _buildBottomBar() {
    final hasSelection = _selectedIds.isNotEmpty;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: DoctorColors.cardWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: hasSelection ? _deleteSelected : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DoctorColors.errorRed,
                    side: BorderSide(
                      color: hasSelection
                          ? DoctorColors.errorRed
                          : DoctorColors.fieldBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    hasSelection ? 'Use (${_selectedIds.length})' : 'Use',
                    style: const TextStyle(
                      fontSize: 16,
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
