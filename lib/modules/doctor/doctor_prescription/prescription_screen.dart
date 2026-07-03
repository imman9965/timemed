import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_details_dialog.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_screen_list.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../doctor_basic_details/signature_pad.dart';
import '../doctor_basic_details/dummy_data_5.dart'
    show doctorSignature, dummyPatient, prescriptionAdvice;

class DoctorPrescriptionScreen extends StatefulWidget {
  const DoctorPrescriptionScreen({super.key});

  @override
  State<DoctorPrescriptionScreen> createState() =>
      _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
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

  Future<void> _previewTemplate() async {
    if (_prescription.isEmpty) {
      _snack('Add at least one drug to preview the template');
      return;
    }
    await showDialog(
      context: context,
      builder: (_) => _PrescriptionTemplateDialog(
        items: List<_PrescriptionItem>.from(_prescription),
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
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          CurvedHeader(title: "DOCTOR PRESCRIPTION",titleStyle: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
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
                  const Divider(color: DoctorColors.fieldBorder, height: 1),
                  const SizedBox(height: 14),
                  const Text(
                    'Prescription',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: DoctorColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPrescriptionList(),
                  const SizedBox(height: 14),
                  _buildTemplateActions(),
                  const SizedBox(height: 18),
                  _buildPreviewButton(),
                  const SizedBox(height: 12),
                  _buildSendButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Header ----------
  // Widget _buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [DoctorColors.primaryDark, DoctorColors.primaryLight],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(28),
  //         bottomRight: Radius.circular(28),
  //       ),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.arrow_back_ios_new,
  //               color: Colors.white, size: 20),
  //           onPressed: () => Navigator.of(context).maybePop(),
  //         ),
  //         const Expanded(
  //           child: Text(
  //             'DOCTOR PRESCRIPTION',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w700,
  //               letterSpacing: 0.6,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 40),
  //       ],
  //     ),
  //   );
  // }

  // ---------- Drug name with search ----------
  Widget _buildDrugNameField() {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _drugNameController,
              style: const TextStyle(fontSize: 16, color: DoctorColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Drug Name',
                hintStyle: TextStyle(fontSize: 16, color: DoctorColors.textSecondary),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: DoctorColors.primary, size: 26),
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
              style: TextStyle(fontSize: 16, color: DoctorColors.textSecondary)),
          icon: const Icon(Icons.keyboard_arrow_down, color: DoctorColors.textSecondary),
          style: const TextStyle(fontSize: 16, color: DoctorColors.textPrimary),
          dropdownColor: DoctorColors.cardWhite,
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
            style: TextStyle(fontSize: 14, color: DoctorColors.textSecondary, height: 1.2),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: DoctorColors.textSecondary),
          style: const TextStyle(fontSize: 16, color: DoctorColors.textPrimary),
          dropdownColor: DoctorColors.cardWhite,
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
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DoctorColors.fieldBorder),
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
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DoctorColors.fieldBorder),
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
                    color: DoctorColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DoctorColors.textPrimary,
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
                      size: 22, color: DoctorColors.textSecondary),
                ),
              ),
              InkWell(
                onTap: onDecrement,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Icon(Icons.arrow_drop_down,
                      size: 22, color: DoctorColors.textSecondary),
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
      style: const TextStyle(fontSize: 16, color: DoctorColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Add Notes',
        hintStyle: const TextStyle(fontSize: 16, color: DoctorColors.textSecondary),
        filled: true,
        fillColor: DoctorColors.cardWhite,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          borderSide: const BorderSide(color: DoctorColors.primary, width: 1.5),
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
          backgroundColor: DoctorColors.errorRed,
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
          backgroundColor: DoctorColors.success,
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
          color: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: DoctorColors.fieldBorder),
        ),
        child: const Center(
          child: Text(
            'No drugs added yet',
            style: TextStyle(color: DoctorColors.textSecondary, fontSize: 14),
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
            color: DoctorColors.cardWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DoctorColors.fieldBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: DoctorColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: DoctorColors.primary,
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
                        color: DoctorColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${p.frequency} • ${p.days} day${p.days > 1 ? 's' : ''} • Qty ${p.qty}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: DoctorColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.foodRelation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: DoctorColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (p.notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Note: ${p.notes}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: DoctorColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: DoctorColors.errorRed, size: 20),
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
            Icon(icon, color: DoctorColors.primary, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DoctorColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Preview as Template ----------
  Widget _buildPreviewButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: _previewTemplate,
        icon: const Icon(Icons.description_outlined,
            color: DoctorColors.primary, size: 22),
        label: const Text(
          'Preview as Template',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: DoctorColors.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: DoctorColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
          backgroundColor: DoctorColors.success,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          shadowColor: DoctorColors.primary.withOpacity(0.3),
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
// Prescription template (formatted Rx sheet with signature)
// ============================================================
class _PrescriptionTemplateDialog extends StatelessWidget {
  final List<_PrescriptionItem> items;
  const _PrescriptionTemplateDialog({required this.items});

  String _today() {
    final d = DateTime.now();
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 28),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.9,
          maxWidth: 500,

        ),
        child: Container(

          // clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: DoctorColors.cardWhite,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: DoctorColors.dividerCool),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _topBar(context),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _letterhead(),
                      _sectionDivider(),
                      _patientBlock(),
                      _sectionDivider(),
                      _rxHeading(),
                      _sectionDivider(),
                      _medicineTable(),
                      _sectionDivider(),
                      _adviceBlock(),
                      _sectionDivider(),
                      _signatureFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionDivider() =>
      const Divider(height: 1, thickness: 1, color: DoctorColors.dividerCool);

  // Slim coloured title bar with a close affordance
  Widget _topBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.primary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: DoctorColors.dividerCool),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 6, 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'PRESCRIPTION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.close, color: Colors.white, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Doctor letterhead — all details from Basic Details (persisted locally)
  Widget _letterhead() {
    final sig = doctorSignature;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DR. ${sig.doctorName.toUpperCase()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: DoctorColors.primary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 3),
            if (sig.qualification.isNotEmpty)
              Text(
                sig.qualification,
                style: const TextStyle(
                    fontSize: 13, color: DoctorColors.textPrimary),
              ),
            if (sig.regNo.isNotEmpty)
              Text(
                'Reg No: ${sig.regNo}',
                style: const TextStyle(
                    fontSize: 12, color: DoctorColors.textSecondary),
              ),
            const SizedBox(height: 4),
            Text(
              sig.clinic,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: DoctorColors.textPrimary,
              ),
            ),
            if (sig.city.isNotEmpty)
              Text(
                sig.city,
                style: const TextStyle(
                    fontSize: 12, color: DoctorColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }

  // Aligned "Label : value" row
  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DoctorColors.textPrimary,
              ),
            ),
          ),
          const Text(':  ',
              style: TextStyle(fontSize: 13, color: DoctorColors.textSecondary)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13, color: DoctorColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Patient details block
  Widget _patientBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kv('Patient', dummyPatient.name),
          _kv('Age', dummyPatient.age),
          _kv('Gender', dummyPatient.gender),
          _kv('Date', _today()),
        ],
      ),
    );
  }

  // Rx section heading
  Widget _rxHeading() {
    return Container(
      width: double.infinity,
      color: DoctorColors.primarySoft,
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
      child: Row(
        children: [
          const Text(
            '℞',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: DoctorColors.primary,
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Prescription',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: DoctorColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Medicine table: #  Medicine  Freq  Days
  Widget _medicineTable() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Table(
        border: TableBorder(
          horizontalInside:
              BorderSide(color: DoctorColors.dividerCool, width: 1),
        ),
        columnWidths: const {
          0: FixedColumnWidth(28),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(60),
          3: FixedColumnWidth(44),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: DoctorColors.primarySoft),
            children: [
              _cell('#', header: true),
              _cell('Medicine', header: true),
              _cell('Freq', header: true),
              _cell('Days', header: true),
              _cell('Food Relation', header: true),
            ],
          ),
          ...List.generate(items.length, (i) {
            final p = items[i];
            return TableRow(children: [
              _cell('${i + 1}'),
              _cell(p.drugName),
              _cell(p.frequency),
              _cell('${p.days}'),
              _cell('${p.foodRelation}'),

            ]);
          }),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool header = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
      child: Text(
        text,
        style: TextStyle(
          fontSize: header ? 12.5 : 13,
          fontWeight: header ? FontWeight.w700 : FontWeight.w500,
          color: header ? DoctorColors.primary : DoctorColors.textPrimary,
        ),
      ),
    );
  }

  // Advice / instructions
  Widget _adviceBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Note:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: DoctorColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.notes,
                      style: const TextStyle(
                        fontSize: 13,
                        color: DoctorColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Signature footer — right aligned, scaled + clipped to its box
  Widget _signatureFooter() {
    final sig = doctorSignature;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Row(
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drawn signature, scaled to fit and clipped so it never overflows
              SizedBox(
                height: 50,
                width: 180,
                child: sig.hasDrawing
                    ? ClipRect(
                        child: CustomPaint(
                          painter: SignaturePainter(sig.strokes,
                              strokeWidth: 2, fit: true),
                          size: Size.infinite,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Container(
                width: 150,
                height: 1,
                color: DoctorColors.textPrimary,
                margin: const EdgeInsets.only(bottom: 5),
              ),
              const Text(
                'Signature',
                style: TextStyle(
                  fontSize: 11,
                  color: DoctorColors.textSecondary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Dr. ${sig.doctorName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: DoctorColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
                  const TextStyle(fontSize: 15, color: DoctorColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search drugs...',
                    hintStyle:
                    const TextStyle(color: DoctorColors.textHint, fontSize: 15),
                    prefixIcon: const Icon(Icons.search,
                        color: DoctorColors.textHint, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: DoctorColors.dividerCool),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: DoctorColors.dividerCool),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: DoctorColors.primary, width: 1.5),
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
                          color: DoctorColors.textHint, fontSize: 14),
                    ),
                  ),
                )
                    : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: DoctorColors.dividerCool,
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
                                color: DoctorColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                drug,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: DoctorColors.textPrimary,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: DoctorColors.textHint, size: 20),
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
