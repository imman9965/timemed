import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';

class PatientAddPage extends StatefulWidget {
  const PatientAddPage({super.key});

  @override
  State<PatientAddPage> createState() => _PatientAddPageState();
}

class _PatientAddPageState extends State<PatientAddPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final ageController = TextEditingController();

  String selectedGender = "";
  String selectedMarital = "";

  String selectedRelationship = "";

  /// DOB Picker
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);

      int age = DateTime.now().year - picked.year;
      ageController.text = age.toString();
    }
  }

  ///
  File? _patientImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery, // or camera
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _patientImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: "Add Patient", showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Image
            _buildImagePicker(),

            const SizedBox(height: 20),

            /// FIRST + LAST NAME
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Patient Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                //
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: firstNameController,
                        hint: 'First Name',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        controller: lastNameController,
                        hint: 'Last Name',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// DOB + AGE
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: _textField(
                        label: "Date of Birth",
                        controller: dobController,
                        hint: "DD/MM/YYYY",
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    label: "Age",
                    hint: 'Enter Age',
                    controller: ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// GENDER
            _sectionTitle("Gender"),
            const SizedBox(height: 10),
            Row(
              children: [
                _selectionCard("Male", Icons.male),
                _selectionCard("Female", Icons.female),
                _selectionCard("Others", Icons.transgender),
              ],
            ),

            const SizedBox(height: 20),

            /// MARITAL STATUS
            _sectionTitle("Marital Status"),
            const SizedBox(height: 10),
            Row(children: [_maritalCard("Single"), _maritalCard("Married")]),

            const SizedBox(height: 30),

            _sectionTitle("Relationship"),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _openRelationshipDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedRelationship.isEmpty
                          ? "Select Relationship"
                          : selectedRelationship,
                      style: TextStyle(
                        color: selectedRelationship.isEmpty
                            ? Colors.grey
                            : AppColors.textPrimary,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// REGISTER BUTTON
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Image Pick
  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            /// PROFILE IMAGE
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _patientImage != null
                  ? FileImage(_patientImage!)
                  : null,
              child: _patientImage == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),

            /// CAMERA ICON
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TEXT FIELD
  Widget _textField({
    TextEditingController? controller,
    String? label,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? "", style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TitleTextFormField(
          controller: controller,
          hintText: hint,
          filled: true,
          fillColor: AppColors.backgroundLight.withOpacity(0.2),
          prefixIcon: icon != null ? Icon(icon) : null,
          borderColor: Colors.transparent,
        ),
      ],
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// GENDER CARD
  Widget _selectionCard(String value, IconData icon) {
    final isSelected = selectedGender == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedGender = value);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : Colors.orange),
              const SizedBox(height: 6),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }

  /// MARITAL CARD
  Widget _maritalCard(String value) {
    final isSelected = selectedMarital == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedMarital = value);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Center(child: Text(value)),
        ),
      ),
    );
  }

  void _openRelationshipDialog() {
    String tempSelection = selectedRelationship;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HEADER
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "SELECT RELATIONSHIP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  /// OPTIONS (IMPORTANT FIX HERE)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildRadio("Son", tempSelection, setStateDialog, (
                          val,
                        ) {
                          tempSelection = val;
                        }),
                        _buildRadio("Daughter", tempSelection, setStateDialog, (
                          val,
                        ) {
                          tempSelection = val;
                        }),
                        _buildRadio("Wife", tempSelection, setStateDialog, (
                          val,
                        ) {
                          tempSelection = val;
                        }),
                        _buildRadio("Brother", tempSelection, setStateDialog, (
                          val,
                        ) {
                          tempSelection = val;
                        }),
                        _buildRadio("Sister", tempSelection, setStateDialog, (
                          val,
                        ) {
                          tempSelection = val;
                        }),
                        _buildRadio("Friend", tempSelection, setStateDialog, (
                          val,
                        ) {
                          tempSelection = val;
                        }),
                      ],
                    ),
                  ),

                  /// BUTTON
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CommonButton(
                      borderRadius: 25,
                      width: 180,
                      title: "Submit",
                      onPressed: () {
                        setState(() {
                          selectedRelationship = tempSelection;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadio(
    String value,
    String currentValue,
    Function(void Function()) setStateDialog,
    Function(String) onChangedValue,
  ) {
    return RadioListTile<String>(
      value: value,
      groupValue: currentValue,
      title: Text(value),
      onChanged: (val) {
        setStateDialog(() {
          onChangedValue(val!);
        });
      },
    );
  }
}
