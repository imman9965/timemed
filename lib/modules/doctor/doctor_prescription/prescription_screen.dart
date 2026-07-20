import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_details_dialog.dart';
import 'package:timesmed_project/modules/doctor/doctor_prescription/template_screen_list.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  const DoctorPrescriptionScreen({super.key});

  @override
  State<DoctorPrescriptionScreen> createState() =>
      _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
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
    '1-1-1',
  ];

  final List<String> _foodRelationOptions = const [
    'Before Food',
    'After Food',
    'With Food',
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
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          CurvedHeader(
            title: "DOCTOR PRESCRIPTION",
            titleStyle: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _addMedicationCard(),
                  const SizedBox(height: 20),
                  _prescriptionHeader(),
                  const SizedBox(height: 12),
                  _buildPrescriptionList(),
                  const SizedBox(height: 18),
                  _buildTemplateActions(),
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

  // ─────────────────────────────────────────────
  //  SHARED BUILDING BLOCKS
  // ─────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DoctorColors.dividerCool),
        boxShadow: [
          BoxShadow(
            color: DoctorColors.primary.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardTitle(IconData icon, String text) {
    return Row(children: [
      Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DoctorColors.primarySoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 19, color: DoctorColors.primary),
      ),
      const SizedBox(width: 10),
      Text(text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: DoctorColors.textPrimary)),
    ]);
  }

  Widget _fieldLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: DoctorColors.textSecondary,
      ),
    );
  }

  Widget _labeled(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  BoxDecoration _fieldDeco() => BoxDecoration(
        color: DoctorColors.backgroundFrost,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DoctorColors.dividerCool),
      );

  // ─────────────────────────────────────────────
  //  ADD MEDICATION CARD
  // ─────────────────────────────────────────────
  Widget _addMedicationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(Icons.medication_rounded, 'Add Medication'),
          const SizedBox(height: 16),
          _fieldLabel('Drug name'),
          const SizedBox(height: 6),
          _buildDrugNameField(),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _labeled('Frequency', _buildFrequencyDropdown())),
              const SizedBox(width: 12),
              Expanded(child: _labeled('Days', _buildDaysSpinner())),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _labeled('Quantity', _buildQtySpinner())),
              const SizedBox(width: 12),
              Expanded(
                  child: _labeled(
                      'Food relation', _buildFoodRelationDropdown())),
            ],
          ),
          const SizedBox(height: 14),
          _fieldLabel('Notes'),
          const SizedBox(height: 6),
          _buildNotesField(),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _buildClearButton()),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _buildAddDrugButton()),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Drug name with search ----------
  Widget _buildDrugNameField() {
    return Container(
      decoration: _fieldDeco(),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.medication_liquid_rounded,
              size: 18, color: DoctorColors.primary),
          Expanded(
            child: TextField(
              controller: _drugNameController,
              style: const TextStyle(
                  fontSize: 15,
                  color: DoctorColors.textPrimary,
                  fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                hintText: 'e.g. Paracetamol 500mg',
                hintStyle: TextStyle(
                    fontSize: 14, color: DoctorColors.textMuted),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: _openDrugSearch,
              child: Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DoctorColors.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.search, color: Colors.white, size: 18),
              ),
            ),
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
          hint: const Text('Select',
              style: TextStyle(
                  fontSize: 14, color: DoctorColors.textMuted)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: DoctorColors.primary),
          style: const TextStyle(
              fontSize: 15,
              color: DoctorColors.textPrimary,
              fontWeight: FontWeight.w600),
          dropdownColor: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          items: _frequencyOptions
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (v) => setState(() => _selectedFrequency = v),
        ),
      ),
    );
  }

  Widget _buildDaysSpinner() {
    return _numberSpinner(
      value: _days,
      onIncrement: () => setState(() => _days++),
      onDecrement: () => setState(() => _days = (_days > 1) ? _days - 1 : 1),
    );
  }

  Widget _buildQtySpinner() {
    return _numberSpinner(
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
          hint: const Text('Select',
              style: TextStyle(
                  fontSize: 14, color: DoctorColors.textMuted)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: DoctorColors.primary),
          style: const TextStyle(
              fontSize: 15,
              color: DoctorColors.textPrimary,
              fontWeight: FontWeight.w600),
          dropdownColor: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
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
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: _fieldDeco(),
      child: Center(child: child),
    );
  }

  Widget _numberSpinner({
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: _fieldDeco(),
      child: Row(
        children: [
          _spinBtn(Icons.remove_rounded, onDecrement),
          Expanded(
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: DoctorColors.textPrimary)),
          ),
          _spinBtn(Icons.add_rounded, onIncrement),
        ],
      ),
    );
  }

  Widget _spinBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: DoctorColors.primarySoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18, color: DoctorColors.primary),
        ),
      ),
    );
  }

  // ---------- Notes ----------
  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      minLines: 3,
      style: const TextStyle(fontSize: 15, color: DoctorColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Optional instructions for the patient',
        hintStyle:
            const TextStyle(fontSize: 14, color: DoctorColors.textMuted),
        filled: true,
        fillColor: DoctorColors.backgroundFrost,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DoctorColors.dividerCool),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DoctorColors.dividerCool),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DoctorColors.primary, width: 1.5),
        ),
      ),
    );
  }

  // ---------- Form buttons ----------
  Widget _buildClearButton() {
    return SizedBox(
      height: 50,
      child: TextButton.icon(
        onPressed: _clearForm,
        icon: const Icon(Icons.refresh_rounded,
            size: 18, color: DoctorColors.errorRed),
        label: const Text('Clear',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: DoctorColors.errorRed)),
        style: TextButton.styleFrom(
          backgroundColor: DoctorColors.errorSoftBg,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildAddDrugButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _addDrug,
        icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
        label: const Text('Add Drug',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: DoctorColors.success,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ---------- Prescription section ----------
  Widget _prescriptionHeader() {
    return Row(children: [
      Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DoctorColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.receipt_long_rounded,
            size: 18, color: Colors.white),
      ),
      const SizedBox(width: 10),
      const Text('Prescription',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: DoctorColors.textPrimary)),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: DoctorColors.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('${_prescription.length}',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: DoctorColors.primary)),
      ),
    ]);
  }

  Widget _buildPrescriptionList() {
    if (_prescription.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DoctorColors.dividerCool),
        ),
        child: const Column(
          children: [
            Icon(Icons.medication_outlined,
                size: 36, color: DoctorColors.textMuted),
            SizedBox(height: 10),
            Text('No drugs added yet',
                style: TextStyle(
                    color: DoctorColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 3),
            Text('Fill the form above and tap Add Drug',
                style:
                    TextStyle(color: DoctorColors.textSecondary, fontSize: 12)),
          ],
        ),
      );
    }
    return Column(
      children: List.generate(_prescription.length, (i) {
        final p = _prescription[i];
        return Container(
          margin:
              EdgeInsets.only(bottom: i == _prescription.length - 1 ? 0 : 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DoctorColors.cardWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: DoctorColors.dividerCool),
            boxShadow: [
              BoxShadow(
                color: DoctorColors.primary.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DoctorColors.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text('${i + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.drugName,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: DoctorColors.textPrimary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _rxChip(Icons.schedule_rounded, p.frequency),
                        _rxChip(Icons.event_rounded,
                            '${p.days} day${p.days > 1 ? 's' : ''}'),
                        _rxChip(Icons.tag_rounded, 'Qty ${p.qty}'),
                        _rxChip(Icons.restaurant_rounded, p.foodRelation),
                      ],
                    ),
                    if (p.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Note: ${p.notes}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: DoctorColors.textSecondary,
                              fontStyle: FontStyle.italic)),
                    ],
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _removePrescriptionItem(i),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: DoctorColors.errorSoftBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: DoctorColors.errorRed, size: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _rxChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DoctorColors.backgroundFrost,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DoctorColors.dividerSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: DoctorColors.primary),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: DoctorColors.textPrimary)),
        ],
      ),
    );
  }

  // ---------- Template actions ----------
  Widget _buildTemplateActions() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: _onTemplateList,
        icon: const Icon(Icons.list_alt_rounded,
            color: DoctorColors.primary, size: 20),
        label: const Text(
          'Template List',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: DoctorColors.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: DoctorColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
      child: ElevatedButton.icon(
        onPressed: _sendPrescription,
        icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
        label: const Text(
          'Send Prescription',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: DoctorColors.success,
          elevation: 2,
          shadowColor: DoctorColors.success.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
