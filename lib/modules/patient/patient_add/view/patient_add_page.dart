import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

    final relationships = [
      {"title": "Son", "icon": Icons.boy},
      {"title": "Daughter", "icon": Icons.girl},
      {"title": "Wife", "icon": Icons.favorite},
      {"title": "Brother", "icon": Icons.man},
      {"title": "Sister", "icon": Icons.woman},
      {"title": "Friend", "icon": Icons.people},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Handle
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Select Relationship",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 20),

                  ...relationships.map((item) {
                    final title = item["title"] as String;
                    final icon = item["icon"] as IconData;

                    final isSelected = tempSelection == title;

                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          tempSelection = title;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(.08)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: Colors.black.withOpacity(.03),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(.12)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedRelationship = tempSelection;
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _relationshipField() {
    return GestureDetector(
      onTap: _openRelationshipDialog,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(blurRadius: 18, color: Colors.black.withOpacity(.04)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.family_restroom,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                selectedRelationship.isEmpty
                    ? "Choose Relationship"
                    : selectedRelationship,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selectedRelationship.isEmpty
                      ? Colors.grey
                      : Colors.black87,
                ),
              ),
            ),

            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
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
