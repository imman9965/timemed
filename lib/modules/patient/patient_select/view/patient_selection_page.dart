import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/modules/patient/patient_select/model/patient_selection_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientSelectionPage extends StatefulWidget {
  const PatientSelectionPage({super.key});

  @override
  State<PatientSelectionPage> createState() => _PatientSelectionPageState();
}

class _PatientSelectionPageState extends State<PatientSelectionPage> {
  // Sample patient data - replace with actual data from controller
  final List<PatientSelectionModel> patients = [
    PatientSelectionModel(
      id: '1',
      name: 'John Doe',
      relation: 'Self',
      gender: "Male",
      age: 30,
    ),
    PatientSelectionModel(
      id: '2',
      name: 'Sarah Doe',
      relation: 'Spouse',
      gender: "Female",
      age: 28,
    ),
    PatientSelectionModel(
      id: '3',
      name: 'Emma Doe',
      relation: 'Daughter',
      gender: "Female",
      age: 5,
    ),
    PatientSelectionModel(
      id: '4',
      name: 'Robert Doe',
      relation: 'Father',
      gender: "Male",
      age: 60,
    ),
  ];

  PatientSelectionModel? selectedPatient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: "Select Patient", showBack: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          Expanded(child: _buildPatientList()),

          _buildContinueButton(),
        ],
      ),
    );
  }

  /// Header - Show selected patient or prompt to select
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Who is this appointment for?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Select a patient or add a new one",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Patient List - Show list of patients to select from
  Widget _buildPatientList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: patients.length + 1,
      itemBuilder: (context, index) {
        if (index == patients.length) {
          return _buildAddPatientCard();
        }

        final patient = patients[index];
        final isSelected = selectedPatient?.id == patient.id;

        return GestureDetector(
          onTap: () {
            setState(() => selectedPatient = patient);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    patient.name[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${patient.relation} • ${patient.age} yrs • ${patient.gender}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.primary),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Add Patient Card - Show option to add new patient

  Widget _buildAddPatientCard() {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.addPatient);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: const [
            Icon(Icons.add, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              "Add New Patient",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom card - Show continue button if patient selected, else show add patient option
  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: selectedPatient == null
              ? null
              : () {
                  context.go(AppRoutes.patientHome);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Continue"),
        ),
      ),
    );
  }
}
