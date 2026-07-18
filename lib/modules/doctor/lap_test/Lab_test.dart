import 'package:flutter/material.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';

import '../theme/doctor_theme.dart';
import 'dropdown&.dart';

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
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _openTestSelector() async {
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Department first')),
      );
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

  void _sendRequest() {
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a department')),
      );
      return;
    }
    if (_selectedTests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one test')),
      );
      return;
    }
    final payload = {
      'department': _selectedDepartment,
      'tests': _selectedTests,
      'instructions': _instructionsController.text.trim(),
    };
    debugPrint('Lab test request: $payload');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          CurvedHeader(
            title: "LAB TEST REQUEST",
              titleStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )

          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDepartmentDropdown(),
                  const SizedBox(height: 12),
                  _buildTestsField(),
                  // const SizedBox(height: 16),
                  // _buildAddTestPanel(),
                  const SizedBox(height: 16),
                  _buildInstructionsField(),
                  const SizedBox(height: 16),
                  _buildSendRequestButton(),
                  const SizedBox(height: 24),
                  const Text(
                    'Lab Test Records',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: DoctorColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildEmptyRecords(),
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
  //     decoration:  BoxDecoration(
  //       color: AppColors.primary,
  //       // gradient: LinearGradient(
  //       //   colors: [DoctorColors.primaryDark, DoctorColors.primaryLight],
  //       //   begin: Alignment.topLeft,
  //       //   end: Alignment.bottomRight,
  //       // ),
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
  //             'LAB TEST REQUEST',
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

  // ---------- Department dropdown ----------
  Widget _buildDepartmentDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedDepartment,
          hint: const Text(
            'Department',
            style: TextStyle(fontSize: 16, color: DoctorColors.textSecondary),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: DoctorColors.textSecondary),
          style: const TextStyle(fontSize: 16, color: DoctorColors.textPrimary),
          dropdownColor: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(10),
          items: _departments
              .map((d) => DropdownMenuItem(
            value: d,
            child: Text(d),
          ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedDepartment = v;
              _selectedTests.clear(); // reset tests when department changes
            });
          },
        ),
      ),
    );
  }

  // ---------- Selected tests field (looks like a disabled dropdown until populated) ----------
  Widget _buildTestsField() {
    return InkWell(
      onTap: _openTestSelector,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: DoctorColors.fieldBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: _selectedTests.isEmpty
                  ? const Text(
                'Please select Department first',
                style: TextStyle(fontSize: 16, color: DoctorColors.textSecondary),
              )
                  : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _selectedTests
                    .map((t) => Chip(
                  label: Text(
                    t,
                    style: const TextStyle(fontSize: 12),
                  ),

                  backgroundColor:
                  DoctorColors.primary.withOpacity(0.1),
                  side: BorderSide(
                      color: DoctorColors.primary.withOpacity(0.3)),
                  materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onDeleted: () {
                    setState(() => _selectedTests.remove(t));
                  },
                  deleteIconColor: DoctorColors.primary,
                ))
                    .toList(),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: DoctorColors.textSecondary),
          ],
        ),
      ),
    );
  }

  // ---------- "Please Add New Test here" panel ----------
  // Widget _buildAddTestPanel() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
  //     decoration: BoxDecoration(
  //       color: DoctorColors.cardWhite,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: DoctorColors.fieldBorder),
  //     ),
  //     child: Column(
  //       children: [
  //         RichText(
  //           textAlign: TextAlign.center,
  //           text: const TextSpan(
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: DoctorColors.textSecondary,
  //               fontWeight: FontWeight.w500,
  //             ),
  //             children: [
  //               TextSpan(text: 'Please '),
  //               TextSpan(
  //                 text: 'Add New Test',
  //                 style: TextStyle(
  //                   color: DoctorColors.primary,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //               TextSpan(text: ' here.'),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 14),
  //         SizedBox(
  //           width: double.infinity,
  //           height: 50,
  //           child: ElevatedButton(
  //             onPressed: _openTestSelector,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: DoctorColors.success,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               elevation: 0,
  //             ),
  //             child: const Text(
  //               'Add New Test',
  //               style: TextStyle(
  //                 fontSize: 17,
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ---------- Instructions ----------
  Widget _buildInstructionsField() {
    return TextField(
      controller: _instructionsController,
      maxLines: 4,
      minLines: 4,
      style: const TextStyle(fontSize: 16, color: DoctorColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Instructions',
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

  // ---------- Send Request ----------
  Widget _buildSendRequestButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _sendRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: DoctorColors.success,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          shadowColor: DoctorColors.primary.withOpacity(0.3),
        ),
        child: const Text(
          'Send Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------- Empty records placeholder ----------
  Widget _buildEmptyRecords() {
    return Center(
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
          const SizedBox(height: 8),
          const Text(
            'No records yet',
            style: TextStyle(color: DoctorColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
