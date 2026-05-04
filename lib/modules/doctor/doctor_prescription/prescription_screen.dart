import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_details_dialog.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_screen_list.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  const DoctorPrescriptionScreen({super.key});

  @override
  State<DoctorPrescriptionScreen> createState() =>
      _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  // ---------- Theme ----------
  static const Color _primaryDark = Color(0xFF1E5FBF);
  static const Color _primary = Color(0xFF2F7BE0);
  static const Color _primaryLight = Color(0xFF5EA1F0);
  static const Color _background = Color(0xFFF4F8FE);
  static const Color _cardWhite = Colors.white;
  static const Color _fieldBorder = Color(0xFFD9E2F0);
  static const Color _hintGrey = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFF1A2236);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _clearRed = Color(0xFFEF4444);
  static const Color _accentSoft = Color(0xFFE5EFFC);

  // ---------- Mock master data ----------
  final List<String> _drugDatabase = const [
    'Paracetamol 500mg',
    'Amoxicillin 250mg',
    'Azithromycin 500mg',
    'Ibuprofen 400mg',
    'Cetirizine 10mg',
    'Pantoprazole 40mg',
    'Metformin 500mg',
    'Atorvastatin 10mg',
    'Amlodipine 5mg',
    'Losartan 50mg',
    'Omeprazole 20mg',
    'Diclofenac 50mg',
  ];

  final List<String> _frequencyOptions = const [
    '1-0-0',
    '0-1-0',
    '0-0-1',
    '1-0-1',
    '1-1-1',
    '1-1-1-1',
    'SOS',
    'STAT',
  ];

  final List<String> _foodRelationOptions = const [
    'Before Food',
    'After Food',
    'With Food',
    'Empty Stomach',
    'Bedtime',
  ];

  // ---------- Form state ----------
  final TextEditingController _drugNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedFrequency;
  int _days = 1;
  int _qty = 1;
  String? _selectedFoodRelation;

  // ---------- Prescription items ----------
  final List<_PrescriptionItem> _prescription = [];

  @override
  void dispose() {
    _drugNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _drugNameController.clear();
      _notesController.clear();
      _selectedFrequency = null;
      _selectedFoodRelation = null;
      _days = 1;
      _qty = 1;
    });
  }

  void _addDrug() {
    final drugName = _drugNameController.text.trim();
    if (drugName.isEmpty) {
      _snack('Please enter drug name');
      return;
    }
    if (_selectedFrequency == null) {
      _snack('Please select frequency');
      return;
    }
    if (_selectedFoodRelation == null) {
      _snack('Please select food relation');
      return;
    }
    setState(() {
      _prescription.add(_PrescriptionItem(
        drugName: drugName,
        frequency: _selectedFrequency!,
        days: _days,
        qty: _qty,
        foodRelation: _selectedFoodRelation!,
        notes: _notesController.text.trim(),
      ));
    });
    _clearForm();
    _snack('Drug added to prescription');
  }

  void _removePrescriptionItem(int index) {
    setState(() => _prescription.removeAt(index));
  }

  Future<void> _sendPrescription() async {
    if (_prescription.isEmpty) {
      _snack('Please add at least one drug');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Send Prescription?'),
        content: Text(
          'Send prescription with ${_prescription.length} drug${_prescription.length > 1 ? 's' : ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final payload = _prescription.map((p) => p.toMap()).toList();
      debugPrint('Sending prescription: $payload');
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _prescription.clear());
        _snack('Prescription sent successfully');
      }
    }
  }


  Future<void> _onTemplateList() async {
    final result = await context.push<List<TemplateDrug>>(AppRoutes.templateList);
    if (result != null && result.isNotEmpty) {
      setState(() {
        for (final drug in result) {
          _prescription.add(_PrescriptionItem(
            drugName: drug.name,
            frequency: drug.frequency,
            days: drug.days,
            qty: drug.qty,
            foodRelation: drug.foodRelation,
            notes: '',
          ));
        }
      });
      _snack('${result.length} drug${result.length > 1 ? 's' : ''} loaded from template');
    }
  }


  Future<void> _onSaveExisting() async {
    if (_prescription.isEmpty) {
      _snack('Add drugs before saving to a template');
      return;
    }
    if (templates.isEmpty) {
      _snack('No existing templates. Use "Save New" instead');
      return;
    }
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Save to Existing Template'),
          children: templates.map((t) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, t.id),
              child: Text(t.name, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
        );
      },
    );
    if (selected != null) {
      // Update the drugs map with current prescription
      templateDrugsMap[selected] = _prescription
          .map((p) => TemplateDrug(
                name: p.drugName,
                frequency: p.frequency,
                days: p.days,
                qty: p.qty,
                foodRelation: p.foodRelation,
              ))
          .toList();
      final tName = templates.firstWhere((t) => t.id == selected).name;
      _snack('Saved to $tName');
    }
  }

  Future<void> _onSaveNew() async {
    if (_prescription.isEmpty) {
      _snack('Add drugs before saving as template');
      return;
    }
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Save as New Template'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Template Name',
                  hintText: 'e.g. Fever Protocol',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'e.g. Common fever treatment',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(ctx, {
                  'name': nameController.text.trim(),
                  'desc': descController.text.trim(),
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    nameController.dispose();
    descController.dispose();
    if (result != null) {
      final newId = '${templates.length + 1}';
      templates.add(PrescriptionTemplate(
        id: newId,
        name: result['name']!,
        description: result['desc'] ?? '',
        date: DateTime.now(),
      ));
      templateDrugsMap[newId] = _prescription
          .map((p) => TemplateDrug(
                name: p.drugName,
                frequency: p.frequency,
                days: p.days,
                qty: p.qty,
                foodRelation: p.foodRelation,
              ))
          .toList();
      _snack('Template "${result['name']}" saved');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openDrugSearch() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => _DrugSearchDialog(drugs: _drugDatabase),
    );
    if (picked != null) {
      setState(() => _drugNameController.text = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDrugNameField(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildFrequencyDropdown()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDaysSpinner()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildQtySpinner()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildFoodRelationDropdown()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildNotesField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildClearButton()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAddDrugButton()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: _fieldBorder, height: 1),
                    const SizedBox(height: 14),
                    const Text(
                      'Prescription',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPrescriptionList(),
                    const SizedBox(height: 14),
                    _buildTemplateActions(),
                    const SizedBox(height: 18),
                    _buildSendButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryDark, _primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: Text(
              'DOCTOR PRESCRIPTION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ---------- Drug name with search ----------
  Widget _buildDrugNameField() {
    return Container(
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _drugNameController,
              style: const TextStyle(fontSize: 16, color: _textPrimary),
              decoration: const InputDecoration(
                hintText: 'Drug Name',
                hintStyle: TextStyle(fontSize: 16, color: _hintGrey),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: _primary, size: 26),
            onPressed: _openDrugSearch,
            tooltip: 'Search drugs',
          ),
        ],
      ),
    );
  }

  // ---------- Frequency dropdown ----------
  Widget _buildFrequencyDropdown() {
    return _dropdownContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedFrequency,
          hint: const Text('Frequency',
              style: TextStyle(fontSize: 16, color: _hintGrey)),
          icon: const Icon(Icons.keyboard_arrow_down, color: _hintGrey),
          style: const TextStyle(fontSize: 16, color: _textPrimary),
          dropdownColor: _cardWhite,
          borderRadius: BorderRadius.circular(10),
          items: _frequencyOptions
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (v) => setState(() => _selectedFrequency = v),
        ),
      ),
    );
  }

  // ---------- Days spinner ----------
  Widget _buildDaysSpinner() {
    return _numberSpinner(
      label: 'Days',
      value: _days,
      onIncrement: () => setState(() => _days++),
      onDecrement: () =>
          setState(() => _days = (_days > 1) ? _days - 1 : 1),
    );
  }

  // ---------- Qty spinner ----------
  Widget _buildQtySpinner() {
    return _numberSpinner(
      label: 'Qty',
      value: _qty,
      onIncrement: () => setState(() => _qty++),
      onDecrement: () => setState(() => _qty = (_qty > 1) ? _qty - 1 : 1),
    );
  }

  // ---------- Food relation dropdown ----------
  Widget _buildFoodRelationDropdown() {
    return _dropdownContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedFoodRelation,
          hint: const Text(
            'Food\nRelation',
            style: TextStyle(fontSize: 14, color: _hintGrey, height: 1.2),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: _hintGrey),
          style: const TextStyle(fontSize: 16, color: _textPrimary),
          dropdownColor: _cardWhite,
          borderRadius: BorderRadius.circular(10),
          items: _foodRelationOptions
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (v) => setState(() => _selectedFoodRelation = v),
        ),
      ),
    );
  }

  Widget _dropdownContainer({required Widget child}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fieldBorder),
      ),
      child: Center(child: child),
    );
  }

  Widget _numberSpinner({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _hintGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onIncrement,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Icon(Icons.arrow_drop_up,
                      size: 22, color: _hintGrey),
                ),
              ),
              InkWell(
                onTap: onDecrement,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Icon(Icons.arrow_drop_down,
                      size: 22, color: _hintGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Notes ----------
  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 4,
      minLines: 4,
      style: const TextStyle(fontSize: 16, color: _textPrimary),
      decoration: InputDecoration(
        hintText: 'Add Notes',
        hintStyle: const TextStyle(fontSize: 16, color: _hintGrey),
        filled: true,
        fillColor: _cardWhite,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
    );
  }

  // ---------- Buttons ----------
  Widget _buildClearButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _clearForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _clearRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Clear',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAddDrugButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _addDrug,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Add Drug',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------- Prescription list ----------
  Widget _buildPrescriptionList() {
    if (_prescription.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: _cardWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _fieldBorder),
        ),
        child: const Center(
          child: Text(
            'No drugs added yet',
            style: TextStyle(color: _hintGrey, fontSize: 14),
          ),
        ),
      );
    }
    return Column(
      children: List.generate(_prescription.length, (i) {
        final p = _prescription[i];
        return Container(
          margin: EdgeInsets.only(bottom: i == _prescription.length - 1 ? 0 : 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _fieldBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.drugName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${p.frequency} • ${p.days} day${p.days > 1 ? 's' : ''} • Qty ${p.qty}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: _textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.foodRelation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: _primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (p.notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Note: ${p.notes}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: _clearRed, size: 20),
                onPressed: () => _removePrescriptionItem(i),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ---------- Template actions ----------
  Widget _buildTemplateActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _templateAction(
            icon: Icons.list_alt,
            label: 'Template List',
            onTap: _onTemplateList,
          ),
          const SizedBox(width: 18),
          _templateAction(
            icon: Icons.save_outlined,
            label: 'Save Existing',
            onTap: _onSaveExisting,
          ),
          const SizedBox(width: 18),
          _templateAction(
            icon: Icons.save_as_outlined,
            label: 'Save New',
            onTap: _onSaveNew,
          ),
        ],
      ),
    );
  }

  Widget _templateAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: _primary, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Send Prescription ----------
  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _sendPrescription,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          shadowColor: _primary.withOpacity(0.3),
        ),
        child: const Text(
          'Send Prescription',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}



// ============================================================
// Internal model
// ============================================================
class _PrescriptionItem {
  final String drugName;
  final String frequency;
  final int days;
  final int qty;
  final String foodRelation;
  final String notes;

  _PrescriptionItem({
    required this.drugName,
    required this.frequency,
    required this.days,
    required this.qty,
    required this.foodRelation,
    required this.notes,
  });

  Map<String, dynamic> toMap() => {
    'drugName': drugName,
    'frequency': frequency,
    'days': days,
    'qty': qty,
    'foodRelation': foodRelation,
    'notes': notes,
  };
}

// ============================================================
// Drug search dialog
// ============================================================
class _DrugSearchDialog extends StatefulWidget {
  final List<String> drugs;
  const _DrugSearchDialog({required this.drugs});

  @override
  State<_DrugSearchDialog> createState() => _DrugSearchDialogState();
}

class _DrugSearchDialogState extends State<_DrugSearchDialog> {
  static const Color _primaryDark = Color(0xFF1E5FBF);
  static const Color _primary = Color(0xFF2F7BE0);
  static const Color _primaryLight = Color(0xFF5EA1F0);
  static const Color _divider = Color(0xFFE5EAF2);
  static const Color _textPrimary = Color(0xFF1A2236);
  static const Color _hintGrey = Color(0xFF94A3B8);

  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filtered {
    if (_query.trim().isEmpty) return widget.drugs;
    final q = _query.toLowerCase();
    return widget.drugs.where((d) => d.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.75,
          maxWidth: 480,
        ),
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
                    colors: [_primaryDark, _primaryLight],
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
                        'SELECT DRUG',
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
              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (v) => setState(() => _query = v),
                  style:
                  const TextStyle(fontSize: 15, color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search drugs...',
                    hintStyle:
                    const TextStyle(color: _hintGrey, fontSize: 15),
                    prefixIcon: const Icon(Icons.search,
                        color: _hintGrey, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: _primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              // List
              Flexible(
                child: _filtered.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No matching drugs',
                      style: TextStyle(
                          color: _hintGrey, fontSize: 14),
                    ),
                  ),
                )
                    : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: _divider,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (_, i) {
                    final drug = _filtered[i];
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(drug),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            const Icon(Icons.medication_outlined,
                                color: _primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                drug,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: _textPrimary,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: _hintGrey, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
