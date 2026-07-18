import 'package:flutter/material.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';

import '../theme/doctor_theme.dart';
import 'dropdown&.dart';
import 'lab_test_record.dart';
import 'lab_test_record_card.dart';

class LabTestRequestScreen extends StatefulWidget {
  const LabTestRequestScreen({super.key});

  @override
  State<LabTestRequestScreen> createState() => _LabTestRequestScreenState();
}

class _LabTestRequestScreenState extends State<LabTestRequestScreen> {
  // ---------- Mock data ----------
  final List<String> _departments = const [
    'Hematology',
    'Biochemistry',
    'Microbiology',
    'Pathology',
    'Radiology',
  ];

  // department -> available tests
  final Map<String, List<String>> _testsByDepartment = const {
    'Hematology': [
      'HEMOGRAM - 6 PART (DIFF)',
      'HEMOGLOBIN VARIANT ANALYSIS - HPLC',
      'BETA-THALASSEMIA SCREENING',
      'MALARIAL ANTIGEN',
      'ERYTHROPOIETIN',
      'Erythrocytes (RBCs)',
      'Hematocrit',
      'Hemoglobin (Hb)',
      'INR',
    ],
    'Biochemistry': [
      'Blood Glucose - Fasting',
      'Blood Glucose - PP',
      'HbA1c',
      'Lipid Profile',
      'Liver Function Test',
      'Kidney Function Test',
      'Thyroid Profile (T3, T4, TSH)',
      'Vitamin D',
      'Vitamin B12',
    ],
    'Microbiology': [
      'Urine Culture',
      'Blood Culture',
      'Sputum Culture',
      'Stool Culture',
      'Throat Swab',
    ],
    'Pathology': [
      'Biopsy',
      'FNAC',
      'Pap Smear',
      'Histopathology',
    ],
    'Radiology': [
      'X-Ray Chest',
      'Ultrasound Abdomen',
      'CT Scan',
      'MRI',
      'ECG',
    ],
  };

  String? _selectedDepartment;
  final List<String> _selectedTests = [];
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isUrgent = false;
  static const int _notesMax = 200;

  // Existing lab test records for this patient.
  final List<LabTestRecord> _records = List.of(mockLabTestRecords);

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openTestSelector() async {
    if (_selectedDepartment == null) {
      _snack('Please select a department first');
      return;
    }
    final tests = _testsByDepartment[_selectedDepartment] ?? const [];
    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: true,
      builder: (_) => TestSelectionDialog(
        availableTests: tests,
        initiallySelected: _selectedTests,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedTests
          ..clear()
          ..addAll(result);
      });
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _sendRequest() {
    if (_selectedDepartment == null) {
      _snack('Please select a department');
      return;
    }
    if (_selectedTests.isEmpty) {
      _snack('Please add at least one test');
      return;
    }
    final payload = {
      'department': _selectedDepartment,
      'tests': _selectedTests,
      'notes': _notesController.text.trim(),
      'requestType': _isUrgent ? 'Urgent' : 'Routine',
    };
    debugPrint('Lab test request: $payload');

    setState(() {
      _records.insert(
        0,
        LabTestRecord(
          id: 'LT-${DateTime.now().millisecondsSinceEpoch % 10000}',
          department: _selectedDepartment!,
          tests: List.of(_selectedTests),
          requestedOn: DateTime.now(),
          status: LabTestStatus.pending,
          urgent: _isUrgent,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
      _selectedTests.clear();
      _notesController.clear();
    });

    _snack('Lab test request sent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.background,
      body: Column(
        children: [
          const CurvedHeader(
            title: "LAB TEST REQUEST",
            titleStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRequestCard(),
                  const SizedBox(height: 20),
                  _buildRecordsHeader(),
                  const SizedBox(height: 14),
                  if (_records.isEmpty)
                    _buildEmptyRecords()
                  else
                    ..._records.map((r) => LabTestRecordCard(record: r)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================================
  //  REQUEST CARD
  // ======================================================================
  Widget _buildRequestCard() {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DoctorColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: DoctorColors.primary.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(),
          const SizedBox(height: 14),
          _buildInfoBanner(),
          const SizedBox(height: 18),
          _buildLabel('Select Department', required: true),
          const SizedBox(height: 8),
          _buildDepartmentDropdown(),
          const SizedBox(height: 18),
          _buildLabelRow('Clinical Notes', trailing: '(Optional)'),
          const SizedBox(height: 8),
          _buildNotesField(),
          const SizedBox(height: 18),
          _buildLabel('Select Tests'),
          const SizedBox(height: 8),
          _buildSearchRow(),
          if (_selectedTests.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSelectedChips(),
          ],
          const SizedBox(height: 12),
          _buildAddMoreButton(),
          const SizedBox(height: 18),
          _buildLabel('Request Type'),
          const SizedBox(height: 8),
          _buildRequestTypeSelector(),
          const SizedBox(height: 20),
          _buildSendRequestButton(),
        ],
      ),
    );
  }

  Widget _buildCardTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.science_outlined,
            color: DoctorColors.primary, size: 30),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lab Test Request',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: DoctorColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Create a lab test request for this patient',
                style: TextStyle(
                  fontSize: 12.5,
                  color: DoctorColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: DoctorColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.assignment_outlined,
              color: DoctorColors.primary, size: 18),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: DoctorColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: DoctorColors.primary, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Lab test request will be created for the patient you are currently consulting with.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: DoctorColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Labels ----------
  Widget _buildLabel(String text, {bool required = false}) {
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
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: DoctorColors.errorRed,
            ),
          ),
      ],
    );
  }

  Widget _buildLabelRow(String text, {required String trailing}) {
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
        const SizedBox(width: 6),
        Text(
          trailing,
          style: const TextStyle(
            fontSize: 12.5,
            color: DoctorColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ---------- Department dropdown ----------
  Widget _buildDepartmentDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.apartment_rounded,
              color: DoctorColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedDepartment,
                hint: const Text(
                  'Select department',
                  style: TextStyle(
                      fontSize: 14.5, color: DoctorColors.textSecondary),
                ),
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: DoctorColors.textSecondary),
                style: const TextStyle(
                    fontSize: 14.5, color: DoctorColors.textPrimary),
                dropdownColor: DoctorColors.cardWhite,
                borderRadius: BorderRadius.circular(10),
                items: _departments
                    .map((d) =>
                        DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedDepartment = v;
                    _selectedTests.clear();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Clinical notes ----------
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _notesController,
          maxLines: 4,
          minLines: 4,
          maxLength: _notesMax,
          buildCounter: (_,
                  {required int currentLength,
                  required int? maxLength,
                  required bool isFocused}) =>
              null,
          style: const TextStyle(
              fontSize: 14.5, color: DoctorColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter clinical notes or instruction...',
            hintStyle: const TextStyle(
                fontSize: 14.5, color: DoctorColors.textSecondary),
            filled: true,
            fillColor: DoctorColors.background,
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
        ),
        const SizedBox(height: 4),
        Text(
          '${_notesController.text.length}/$_notesMax',
          style: const TextStyle(
              fontSize: 11.5, color: DoctorColors.textSecondary),
        ),
      ],
    );
  }

  // ---------- Search + Browse ----------
  Widget _buildSearchRow() {
    return Row(
      children: [
        // Expanded(
        //   child: TextField(
        //     controller: _searchController,
        //     readOnly: true,
        //     onTap: _openTestSelector,
        //     style: const TextStyle(
        //         fontSize: 14, color: DoctorColors.textPrimary),
        //     decoration: InputDecoration(
        //       hintText: 'Search tests...',
        //       hintStyle: const TextStyle(
        //           fontSize: 14, color: DoctorColors.textSecondary),
        //       prefixIcon: const Icon(Icons.search,
        //           color: DoctorColors.textSecondary, size: 20),
        //       isDense: true,
        //       filled: true,
        //       fillColor: DoctorColors.background,
        //       contentPadding:
        //           const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: const BorderSide(color: DoctorColors.fieldBorder),
        //       ),
        //       enabledBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: const BorderSide(color: DoctorColors.fieldBorder),
        //       ),
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: const BorderSide(color: DoctorColors.fieldBorder),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 10),
        // InkWell(
        //   onTap: _openTestSelector,
        //   borderRadius: BorderRadius.circular(10),
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        //     decoration: BoxDecoration(
        //       color: DoctorColors.primary.withOpacity(0.08),
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(color: DoctorColors.primary.withOpacity(0.25)),
        //     ),
        //     child: Row(
        //       children: const [
        //         Icon(Icons.grid_view_rounded,
        //             color: DoctorColors.primary, size: 17),
        //         SizedBox(width: 6),
        //         Text(
        //           'Browse by Category',
        //           style: TextStyle(
        //             fontSize: 13,
        //             fontWeight: FontWeight.w700,
        //             color: DoctorColors.primary,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // ---------- Selected chips ----------
  Widget _buildSelectedChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedTests.map((t) {
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 7, 8, 7),
          decoration: BoxDecoration(
            color: DoctorColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: DoctorColors.primary.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  t,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: DoctorColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => setState(() => _selectedTests.remove(t)),
                borderRadius: BorderRadius.circular(20),
                child: const Icon(Icons.close,
                    size: 15, color: DoctorColors.primary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ---------- Add more ----------
  Widget _buildAddMoreButton() {
    return InkWell(
      onTap: _openTestSelector,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: DoctorColors.primary.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: DoctorColors.primary, size: 20),
            SizedBox(width: 6),
            Text(
              'Add More Tests',
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

  // ---------- Request type ----------
  Widget _buildRequestTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _requestTypeCard(
            selected: !_isUrgent,
            icon: Icons.access_time,
            title: 'Routine',
            subtitle: 'Normal processing',
            accent: DoctorColors.primary,
            onTap: () => setState(() => _isUrgent = false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _requestTypeCard(
            selected: _isUrgent,
            icon: Icons.error_outline,
            title: 'Urgent',
            subtitle: 'High priority processing',
            accent: DoctorColors.errorRed,
            onTap: () => setState(() => _isUrgent = true),
          ),
        ),
      ],
    );
  }

  Widget _requestTypeCard({
    required bool selected,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(0.08) : DoctorColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? accent : DoctorColors.fieldBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: DoctorColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: DoctorColors.textSecondary,
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

  // ---------- Send ----------
  Widget _buildSendRequestButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _sendRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: DoctorColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: DoctorColors.primary.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Send Lab Test Request',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  //  RECORDS
  // ======================================================================
  Widget _buildRecordsHeader() {
    return Row(
      children: [
        const Icon(Icons.receipt_long_outlined,
            color: DoctorColors.primary, size: 20),
        const SizedBox(width: 8),
        const Text(
          'Lab Test Records',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: DoctorColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: DoctorColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_records.length}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DoctorColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyRecords() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: DoctorColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_outlined,
                color: DoctorColors.primary, size: 32),
          ),
          const SizedBox(height: 10),
          const Text(
            'No records yet',
            style: TextStyle(color: DoctorColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
