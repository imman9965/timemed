import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';
import 'template_details_dialog.dart';

/// Result returned by [showTemplateEditor].
class TemplateEditResult {
  final String name;
  final String description;
  final List<TemplateDrug> drugs;

  TemplateEditResult({
    required this.name,
    required this.description,
    required this.drugs,
  });
}

/// Internal result of the add/edit drug dialog.
class _DrugSubmit {
  final TemplateDrug drug;
  final bool again; // true = save & add another (keep flow going)
  _DrugSubmit(this.drug, {this.again = false});
}

/// Opens a bottom sheet to create or edit a prescription template.
/// Returns a [TemplateEditResult] on save, or null if cancelled.
Future<TemplateEditResult?> showTemplateEditor(
  BuildContext context, {
  String? initialName,
  String? initialDescription,
  List<TemplateDrug>? initialDrugs,
}) {
  return showModalBottomSheet<TemplateEditResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TemplateEditorSheet(
      initialName: initialName,
      initialDescription: initialDescription,
      initialDrugs: initialDrugs,
    ),
  );
}

class _TemplateEditorSheet extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final List<TemplateDrug>? initialDrugs;

  const _TemplateEditorSheet({
    this.initialName,
    this.initialDescription,
    this.initialDrugs,
  });

  @override
  State<_TemplateEditorSheet> createState() => _TemplateEditorSheetState();
}

class _TemplateEditorSheetState extends State<_TemplateEditorSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final List<TemplateDrug> _drugs;
  bool _nameError = false;

  bool get _isEditing => widget.initialName != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _descCtrl = TextEditingController(text: widget.initialDescription ?? '');
    _drugs = List<TemplateDrug>.from(widget.initialDrugs ?? const []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _addOrEditDrug({int? index}) async {
    var again = true;
    while (again && mounted) {
      final res = await showDialog<_DrugSubmit>(
        context: context,
        builder: (_) => _DrugFormDialog(
          existing: index != null ? _drugs[index] : null,
        ),
      );
      if (res == null) return;
      setState(() {
        if (index != null) {
          _drugs[index] = res.drug;
        } else {
          _drugs.add(res.drug);
        }
      });
      // Only keep looping (with a fresh, cleared form) when adding new drugs.
      again = res.again && index == null;
    }
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    Navigator.of(context).pop(
      TemplateEditResult(
        name: name,
        description: _descCtrl.text.trim(),
        drugs: _drugs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxH = MediaQuery.of(context).size.height * 0.9;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxH),
        decoration: const BoxDecoration(
          color: DoctorColors.backgroundWarm,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGrabber(),
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Template Name', required: true),
                    const SizedBox(height: 8),
                    _textField(
                      _nameCtrl,
                      hint: 'e.g. Common cold protocol',
                      error: _nameError ? 'Name is required' : null,
                      onChanged: (_) {
                        if (_nameError) setState(() => _nameError = false);
                      },
                    ),
                    const SizedBox(height: 16),
                    _label('Description'),
                    const SizedBox(height: 8),
                    _textField(
                      _descCtrl,
                      hint: 'Short description of this template',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _label('Drugs'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: DoctorColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_drugs.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: DoctorColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_drugs.isEmpty)
                      _buildNoDrugs()
                    else
                      ...List.generate(
                        _drugs.length,
                        (i) => _buildDrugCard(_drugs[i], i),
                      ),
                    const SizedBox(height: 10),
                    _buildAddDrugButton(),
                  ],
                ),
              ),
            ),
            _buildSaveBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrabber() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: DoctorColors.fieldBorder,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: DoctorColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isEditing ? Icons.edit_note : Icons.note_add_outlined,
              color: DoctorColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditing ? 'Edit Template' : 'New Template',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: DoctorColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: DoctorColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DoctorColors.textPrimary,
          ),
        ),
        if (required)
          const Text(' *',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: DoctorColors.errorRed)),
      ],
    );
  }

  Widget _textField(
    TextEditingController ctrl, {
    String? hint,
    String? error,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14.5, color: DoctorColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 14.5, color: DoctorColors.textSecondary),
        errorText: error,
        filled: true,
        fillColor: DoctorColors.cardWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DoctorColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DoctorColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: DoctorColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildNoDrugs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.medication_outlined,
              size: 34, color: DoctorColors.textSecondary),
          SizedBox(height: 8),
          Text(
            'No drugs added yet',
            style: TextStyle(color: DoctorColors.textSecondary, fontSize: 13.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugCard(TemplateDrug drug, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: DoctorColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.medication_outlined,
                color: DoctorColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drug.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DoctorColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Freq ${drug.frequency}  •  ${drug.days}d  •  Qty ${drug.qty}  •  ${drug.foodRelation}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: DoctorColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: DoctorColors.primary, size: 20),
            onPressed: () => _addOrEditDrug(index: index),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: DoctorColors.errorRed, size: 20),
            onPressed: () => setState(() => _drugs.removeAt(index)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddDrugButton() {
    return InkWell(
      onTap: () => _addOrEditDrug(),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: DoctorColors.primary.withOpacity(0.4), width: 1.2),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: DoctorColors.primary, size: 20),
            SizedBox(width: 6),
            Text(
              'Add Drug',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DoctorColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: DoctorColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              shadowColor: DoctorColors.primary.withOpacity(0.4),
            ),
            child: Text(
              _isEditing ? 'Update Template' : 'Create Template',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================================
//  DRUG FORM DIALOG
// ======================================================================
class _DrugFormDialog extends StatefulWidget {
  final TemplateDrug? existing;
  const _DrugFormDialog({this.existing});

  @override
  State<_DrugFormDialog> createState() => _DrugFormDialogState();
}

class _DrugFormDialogState extends State<_DrugFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _freq;
  late final TextEditingController _days;
  late final TextEditingController _qty;
  String _food = 'After Food';
  bool _nameError = false;

  static const List<String> _foodOptions = [
    'Before Food',
    'After Food',
    'With Food',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _freq = TextEditingController(text: e?.frequency ?? '1-0-1');
    _days = TextEditingController(text: e?.days.toString() ?? '3');
    _qty = TextEditingController(text: e?.qty.toString() ?? '');
    if (e != null && _foodOptions.contains(e.foodRelation)) {
      _food = e.foodRelation;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _freq.dispose();
    _days.dispose();
    _qty.dispose();
    super.dispose();
  }

  void _submit({bool again = false}) {
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    final days = int.tryParse(_days.text.trim()) ?? 0;
    final qty = int.tryParse(_qty.text.trim()) ?? 0;
    Navigator.of(context).pop(
      _DrugSubmit(
        TemplateDrug(
          name: _name.text.trim(),
          frequency: _freq.text.trim().isEmpty ? '0-0-0' : _freq.text.trim(),
          days: days,
          qty: qty,
          foodRelation: _food,
        ),
        again: again,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: DoctorColors.primaryBrand,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.existing == null ? 'Add Drug' : 'Edit Drug',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('Drug Name', _name,
                        hint: 'e.g. Paracetamol 500mg',
                        error: _nameError ? 'Required' : null, onChanged: (_) {
                      if (_nameError) setState(() => _nameError = false);
                    }),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _field('Frequency', _freq, hint: '1-0-1'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field('Days', _days,
                              hint: '3', keyboard: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _field('Qty', _qty,
                              hint: '9', keyboard: TextInputType.number),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _foodDropdown()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    final isAdd = widget.existing == null;
    if (!isAdd) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () => _submit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: DoctorColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    // Add mode: primary "Add" + "Save & add another" for a faster flow.
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _submit(again: false),
            style: ElevatedButton.styleFrom(
              backgroundColor: DoctorColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () => _submit(again: true),
            style: OutlinedButton.styleFrom(
              foregroundColor: DoctorColors.primary,
              side: const BorderSide(color: DoctorColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Save & add another',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    String? error,
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: DoctorColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          onChanged: onChanged,
          style:
              const TextStyle(fontSize: 14, color: DoctorColors.textPrimary),
          decoration: InputDecoration(
            // hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 14, color: DoctorColors.textSecondary),
            errorText: error,
            isDense: true,
            filled: true,
            fillColor: DoctorColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: DoctorColors.fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: DoctorColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide:
                  const BorderSide(color: DoctorColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _foodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Intake',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: DoctorColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: DoctorColors.background,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: DoctorColors.fieldBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _food,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: DoctorColors.textSecondary, size: 20),
              style: const TextStyle(
                  fontSize: 13.5, color: DoctorColors.textPrimary),
              items: _foodOptions
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _food = v ?? _food),
            ),
          ),
        ),
      ],
    );
  }
}
