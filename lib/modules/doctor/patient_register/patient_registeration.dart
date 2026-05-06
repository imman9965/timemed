import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/common/curved_header.dart';
import '../theme/doctor_colors.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _registrationNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _targetInrFromController = TextEditingController();
  final _targetInrToController = TextEditingController();

  String? _selectedGender; // 'Male' or 'Female'
  bool _obscurePassword = true;

  // Theme color used in the header gradient (forwarded to DoctorColors)
  static const Color _primaryGreen = DoctorColors.successFresh;
  static const Color _primaryTeal  = DoctorColors.successJade;
  static const Color _bgLavender   = DoctorColors.backgroundLavender;
  static const Color _fieldBorder  = DoctorColors.borderGreyLight;
  static const Color _hintGrey     = DoctorColors.textHintGrey;
  static const Color _genderIcon   = DoctorColors.warningGold;
  static const Color _closeRed     = DoctorColors.errorCoral;
  static const Color _saveYellow   = DoctorColors.warningAmber;

  @override
  void dispose() {
    _registrationNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _targetInrFromController.dispose();
    _targetInrToController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender')),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      // Build the patient data map
      final patientData = {
        'registrationNumber': _registrationNumberController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()),
        'gender': _selectedGender,
        'phone': _phoneController.text.trim(),
        'whatsapp': _whatsappController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'targetInrFrom': double.tryParse(_targetInrFromController.text.trim()),
        'targetInrTo': double.tryParse(_targetInrToController.text.trim()),
      };
      debugPrint('Patient data: $patientData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient saved successfully')),
      );
    }
  }

  void _onClose() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLavender,
      body: SafeArea(
        child: Column(
          children: [
            CurvedHeader(
              title:"Patient Registration"
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _registrationNumberController,
                        hint: 'Patient Registration Number',
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _firstNameController,
                        hint: 'First Name',
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _lastNameController,
                        hint: 'Last Name',
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _ageController,
                        hint: 'Age',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: _ageValidator,
                      ),
                      const SizedBox(height: 18),
                      _buildSectionLabel('Gender'),
                      const SizedBox(height: 10),
                      _buildGenderSelector(),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        validator: _phoneValidator,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _whatsappController,
                        hint: 'WhatsApp Number',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Mail Id',
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _hintGrey,
                          ),
                          onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                      const SizedBox(height: 18),
                      _buildSectionLabel('Target INR'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _targetInrFromController,
                              hint: 'From',
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildTextField(
                              controller: _targetInrToController,
                              hint: 'To',
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                      const SizedBox(height: 8),
                    ],
                  ),
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
          colors: [_primaryTeal, _primaryGreen],
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
              'PATIENT REGISTRATION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 40), // balance the back button
        ],
      ),
    );
  }

  // ---------- Reusable Text Field ----------
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _hintGrey, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
          borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  // ---------- Section Label ----------
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ---------- Gender Selector ----------
  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _genderCard(
            label: 'Male',
            icon: Icons.man,
            selected: _selectedGender == 'Male',
            onTap: () => setState(() => _selectedGender = 'Male'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _genderCard(
            label: 'Female',
            icon: Icons.woman,
            selected: _selectedGender == 'Female',
            onTap: () => setState(() => _selectedGender = 'Female'),
          ),
        ),
      ],
    );
  }

  Widget _genderCard({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _primaryGreen : _fieldBorder,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: _genderIcon, size: 44),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Action Buttons ----------
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: _closeRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Close',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: _saveYellow,
              foregroundColor: const Color(0xFF6B4FBE),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Validators ----------
  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  String? _ageValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null || age <= 0 || age > 130) return 'Enter a valid age';
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    if (value.length < 10) return 'Enter a valid phone number';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }
}