import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import 'dummy_data_5.dart';
import 'signature_pad.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel({super.key, required this.text});
  @override
  Widget build(BuildContext ctx) => Padding(
      padding: const EdgeInsets.only(bottom: AppDimens1.s),
      child: Text(text, style: AppTextStyles.sectionLabel));
}

class SelectionChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const SelectionChip({
    super.key, required this.label, required this.onRemove});
  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: DoctorColors.primaryVivid,
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: AppTextStyles.chipLabel),
        const SizedBox(width: 6),
        GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 16, height: 16,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 11),
            )),
      ]),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String label;
  final bool   isSelected;
  final VoidCallback onTap;
  const GenderButton({
    super.key, required this.label,
    required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
            color: isSelected ? DoctorColors.primaryVivid : DoctorColors.inputBg,
            borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
        child: Text(label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : DoctorColors.textDark)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class DoctorBasicDetailsScreen extends StatefulWidget {
  const DoctorBasicDetailsScreen({super.key});
  @override
  State<DoctorBasicDetailsScreen> createState() =>
      _DoctorBasicDetailsScreenState();
}

class _DoctorBasicDetailsScreenState
    extends State<DoctorBasicDetailsScreen> {

  final _form = DoctorFormData();

  // Controllers
  final _firstNameCtrl      = TextEditingController();
  final _lastNameCtrl       = TextEditingController();
  final _dobCtrl            = TextEditingController();
  final _mobileCtrl         = TextEditingController();
  final _emailCtrl          = TextEditingController();
  final _experienceCtrl     = TextEditingController();
  final _specialisationCtrl = TextEditingController();
  final _addressCtrl        = TextEditingController();
  final _categoryCtrl       = TextEditingController();

  // Dropdown open states
  bool _qualificationOpen      = false;
  bool _categoryOpen           = true;
  bool _languageOpen           = false;
  bool _showSpecSuggestions    = false;
  bool _showAddressSuggestions = false;

  // Filtered lists
  List<String>         _filteredSpec     = [];
  List<String>         _filteredAddress  = [];
  List<DropdownOption> _filteredCategory = List.from(categoryOptions);

  // Errors
  String? _emailError;
  String? _mobileError;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl.addListener(() => _form.firstName = _firstNameCtrl.text);
    _lastNameCtrl.addListener (() => _form.lastName  = _lastNameCtrl.text);
    _addressCtrl.addListener  (() => _form.address   = _addressCtrl.text);

    _mobileCtrl.addListener(() {
      _form.mobile = _mobileCtrl.text;
      setState(() =>
      _mobileError = _validateMobile(_mobileCtrl.text));
    });
    _emailCtrl.addListener(() {
      _form.email = _emailCtrl.text;
      setState(() => _emailError = _validateEmail(_emailCtrl.text));
    });
    _experienceCtrl.addListener(() {
      _form.experience = int.tryParse(_experienceCtrl.text) ?? 0;
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _experienceCtrl.dispose();
    _specialisationCtrl.dispose();
    _addressCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  // ── Validators ────────────────────────────────────────
  String? _validateEmail(String v) {
    if (v.isEmpty) return null;
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(v)
        ? null : 'Invalid email';
  }

  String? _validateMobile(String v) {
    if (v.isEmpty) return null;
    return v.length == 10 ? null : 'Must be 10 digits';
  }

  // ── Actions ────────────────────────────────────────────
  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _form.dateOfBirth ?? DateTime(1990),
      firstDate:   DateTime(1940),
      lastDate:    DateTime.now(),
      builder: (c, w) => Theme(
        data: Theme.of(c).copyWith(
            colorScheme: const ColorScheme.light(
                primary: DoctorColors.primaryVivid, onPrimary: Colors.white)),
        child: w!,
      ),
    );
    if (picked != null) {
      setState(() {
        _form.dateOfBirth = picked;
        _dobCtrl.text =
        '${picked.day.toString().padLeft(2,'0')}/'
            '${picked.month.toString().padLeft(2,'0')}/${picked.year}';
      });
    }
  }

  void _incrementExp() {
    final v = int.tryParse(_experienceCtrl.text) ?? 0;
    setState(() => _experienceCtrl.text = (v + 1).toString());
  }

  void _decrementExp() {
    final v = int.tryParse(_experienceCtrl.text) ?? 0;
    if (v > 0) setState(() => _experienceCtrl.text = (v - 1).toString());
  }

  void _onSpecialisationChanged(String q) {
    setState(() {
      if (q.trim().isEmpty) {
        _filteredSpec = [];
        _showSpecSuggestions = false;
      } else {
        _filteredSpec = specialisationSuggestions
            .where((s) =>
        s.toLowerCase().contains(q.toLowerCase()) &&
            !_form.specialisations.contains(s))
            .toList();
        _showSpecSuggestions = _filteredSpec.isNotEmpty;
      }
    });
  }

  void _addSpecialisation(String v) {
    final t = v.trim();
    if (t.isEmpty) return;
    if (!_form.specialisations.contains(t)) {
      setState(() {
        _form.specialisations.add(t);
        _specialisationCtrl.clear();
        _showSpecSuggestions = false;
      });
    }
  }

  void _onCategorySearch(String q) {
    setState(() {
      _filteredCategory = q.trim().isEmpty
          ? List.from(categoryOptions)
          : categoryOptions
          .where((o) =>
          o.label.toLowerCase().contains(q.toLowerCase()))
          .toList();
      _categoryOpen = true;
    });
  }

  void _addLanguage(String label) {
    if (!_form.languages.contains(label)) {
      setState(() => _form.languages.add(label));
    }
  }

  void _onAddressChanged(String q) {
    setState(() {
      if (q.trim().isEmpty) {
        _filteredAddress = [];
        _showAddressSuggestions = false;
      } else {
        _filteredAddress = addressSuggestions
            .where((a) =>
            a.toLowerCase().contains(q.toLowerCase()))
            .toList();
        _showAddressSuggestions = _filteredAddress.isNotEmpty;
      }
    });
  }

  void _closeAllDropdowns() {
    setState(() {
      _qualificationOpen      = false;
      _languageOpen           = false;
      _showSpecSuggestions    = false;
      _showAddressSuggestions = false;
    });
  }

  void _onSave() {
    final errors = <String>[];
    if (_form.firstName.isEmpty)           errors.add('First name');
    if (_form.lastName.isEmpty)            errors.add('Last name');
    if (_form.dateOfBirth == null)         errors.add('DOB');
    if (_form.mobile.length != 10)         errors.add('10-digit mobile');
    if (_validateEmail(_form.email) != null) errors.add('Valid email');
    if (_form.qualification == null)       errors.add('Qualification');
    if (_form.specialisations.isEmpty)     errors.add('Specialisation');
    if (_form.category == null)            errors.add('Category');
    if (_form.languages.isEmpty)           errors.add('Language');
    if (_form.address.isEmpty)             errors.add('Address');

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Missing: ${errors.join(', ')}'),
          backgroundColor: DoctorColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Push the collected details into the shared store so the prescription
    // template shows the real doctor name / qualification / specialisation.
    doctorSignature.updateFrom(_form);
    DoctorProfileStore.save(); // persist to local DB

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Profile Saved',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Doctor profile has been saved successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DoctorColors.primaryVivid,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // context.push(AppRoutes.prescription);
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.cardWhite,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _closeAllDropdowns();
        },
        child: Column(
          children: [
            const CurvedHeader(title: 'Doctor Basic Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppDimens1.screenHPadding, AppDimens1.xl,
                    AppDimens1.screenHPadding, AppDimens1.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: AppDimens1.xl),
                    _buildNameFields(),
                    const SizedBox(height: AppDimens1.l),
                    _buildDobField(),
                    const SizedBox(height: AppDimens1.l),
                    _buildGenderSection(),
                    const SizedBox(height: AppDimens1.l),
                    _buildContactDetails(),
                    const SizedBox(height: AppDimens1.l),
                    _buildExperienceQualification(),
                    const SizedBox(height: AppDimens1.l),
                    _buildSpecialisationSection(),
                    const SizedBox(height: AppDimens1.l),
                    _buildCategorySection(),
                    const SizedBox(height: AppDimens1.l),
                    _buildLanguageSection(),
                    const SizedBox(height: AppDimens1.l),
                    _buildAddressSection(),
                    const SizedBox(height: AppDimens1.l),
                    _buildSignatureSection(),
                    const SizedBox(height: AppDimens1.xxl),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAvatar() {
    return Center(
      child: Stack(children: [
        Container(
          width: 90, height: 90,
          decoration: const BoxDecoration(
              color: DoctorColors.avatarGrey, shape: BoxShape.circle),
          child: const Icon(Icons.person,
              color: Colors.white, size: 56),
        ),
        Positioned(
          bottom: 2, right: 2,
          child: Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
                color:  DoctorColors.avatarGrey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
            child: const Icon(Icons.camera_alt,
                color: Colors.white, size: 13),
          ),
        ),
      ]),
    );
  }

  Widget _buildNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Name'),
        Row(children: [
          Expanded(child: _inputBox(_firstNameCtrl, 'First name')),
          const SizedBox(width: AppDimens1.m),
          Expanded(child: _inputBox(_lastNameCtrl, 'Last name')),
        ]),
      ],
    );
  }

  Widget _buildDobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Date Of Birth'),
        GestureDetector(
          onTap: _pickDob,
          child: AbsorbPointer(
            child: _inputBox(
              _dobCtrl, 'DD/MM/YYYY',
              suffix: const Icon(Icons.calendar_month,
                  color: DoctorColors.primaryVivid, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Gender'),
        Row(
          children: genderOptions.map((g) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GenderButton(
                label: _genderLabel(g),
                isSelected: _form.gender == g,
                onTap: () => setState(() => _form.gender = g),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Contact Details'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputBox(
                    _mobileCtrl, 'Mobile number',
                    keyboardType: TextInputType.phone,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  if (_mobileError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(_mobileError!,
                          style: const TextStyle(
                              fontSize: 11, color: DoctorColors.error)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens1.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputBox(
                    _emailCtrl, 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(_emailError!,
                          style: const TextStyle(
                              fontSize: 11, color: DoctorColors.error)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceQualification() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: 'Experience'),
              Container(
                height: AppDimens1.inputHeight,
                decoration: BoxDecoration(
                    color: DoctorColors.inputBg,
                    borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _experienceCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      style: AppTextStyles.inputText,
                      decoration: InputDecoration(
                        hintText:  'Years',
                        hintStyle: AppTextStyles.inputHint,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 13),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _incrementExp,
                        child: const Icon(Icons.keyboard_arrow_up,
                            color: DoctorColors.textMuted, size: 18),
                      ),
                      GestureDetector(
                        onTap: _decrementExp,
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: DoctorColors.textMuted, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimens1.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: 'Qualification'),
              _buildDropdownSelector(
                hint:    'Mbbs,Bds,...',
                value:   _form.qualification,
                options: qualificationOptions,
                isOpen:  _qualificationOpen,
                onToggle: () => setState(() {
                  _qualificationOpen = !_qualificationOpen;
                  _languageOpen = false;
                }),
                onSelect: (v) => setState(() {
                  _form.qualification = v;
                  _qualificationOpen  = false;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialisationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Specialisation'),
        Container(
          height: AppDimens1.inputHeight,
          decoration: BoxDecoration(
              color: DoctorColors.inputBg,
              borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _specialisationCtrl,
                onChanged: _onSpecialisationChanged,
                onSubmitted: _addSpecialisation,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText:  '(e.g Dental, Cardiologist)',
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 13),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _addSpecialisation(_specialisationCtrl.text),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.search,
                    color: DoctorColors.primaryVivid, size: 20),
              ),
            ),
          ]),
        ),

        if (_showSpecSuggestions) ...[
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
                color: DoctorColors.inputBg,
                borderRadius: BorderRadius.circular(AppDimens1.radiusMd),
                border: Border.all(color: DoctorColors.divider)),
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView(
              shrinkWrap: true,
              children: _filteredSpec.map((s) => ListTile(
                dense: true,
                title: Text(s, style: AppTextStyles.inputText),
                onTap: () => _addSpecialisation(s),
              )).toList(),
            ),
          ),
        ],

        const SizedBox(height: AppDimens1.s),

        // Chips iterated
        if (_form.specialisations.isNotEmpty)
          Wrap(
            spacing: 8, runSpacing: 6,
            children: _form.specialisations.map((s) =>
                SelectionChip(
                  label: s,
                  onRemove: () =>
                      setState(() => _form.specialisations.remove(s)),
                )).toList(),
          ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Category'),
        Container(
          height: AppDimens1.inputHeight,
          decoration: BoxDecoration(
              color: DoctorColors.inputBg,
              borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _categoryCtrl,
                onChanged: _onCategorySearch,
                onTap: () => setState(() => _categoryOpen = true),
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText:  '(e.g Cardiologist)',
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 13),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _categoryOpen = !_categoryOpen),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.search,
                    color: DoctorColors.primaryVivid, size: 20),
              ),
            ),
          ]),
        ),

        if (_categoryOpen) ...[
          const SizedBox(height: AppDimens1.s),
          Container(
            decoration: BoxDecoration(
                color: DoctorColors.primaryVivid,
                borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
            child: Column(
              children: _filteredCategory.asMap().entries.map((entry) {
                final idx   = entry.key;
                final opt   = entry.value;
                final isLast = idx == _filteredCategory.length - 1;
                final isFirst = idx == 0;
                final isSel = _form.category == opt.value;

                return Column(children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      _form.category     = opt.value;
                      _categoryCtrl.text = opt.label;
                      _categoryOpen      = false;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      child: Row(children: [
                        Expanded(
                          child: Text(opt.label,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                        if (isFirst)
                          GestureDetector(
                            onTap: () => setState(() =>
                            _categoryOpen = false),
                            child: const Icon(Icons.keyboard_arrow_up,
                                color: Colors.white, size: 22),
                          ),
                        if (isLast && !isFirst)
                          const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white, size: 22),
                        if (isSel && !isFirst && !isLast)
                          const Icon(Icons.check,
                              color: Colors.white, size: 18),
                      ]),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1, color: Colors.white.withOpacity(0.4),
                      indent: 16, endIndent: 16,
                    ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Language'),
        _buildDropdownSelector(
          hint:    '(e.g Tamil,English,..)',
          value:   null,
          options: languageOptions,
          isOpen:  _languageOpen,
          onToggle: () => setState(() {
            _languageOpen      = !_languageOpen;
            _qualificationOpen = false;
          }),
          onSelect: (v) {
            final label = languageOptions
                .firstWhere((o) => o.value == v).label;
            _addLanguage(label);
            setState(() => _languageOpen = false);
          },
        ),
        const SizedBox(height: AppDimens1.s),
        if (_form.languages.isNotEmpty)
          Wrap(
            spacing: 8, runSpacing: 6,
            children: _form.languages.map((l) =>
                SelectionChip(
                  label: l,
                  onRemove: () =>
                      setState(() => _form.languages.remove(l)),
                )).toList(),
          ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Address'),
        Container(
          height: AppDimens1.inputHeight,
          decoration: BoxDecoration(
              color: DoctorColors.inputBg,
              borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _addressCtrl,
                onChanged: _onAddressChanged,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText:  'Chennai, Tamilnadu',
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 13),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.search,
                  color: DoctorColors.primaryVivid, size: 20),
            ),
          ]),
        ),
        if (_showAddressSuggestions) ...[
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
                color: DoctorColors.inputBg,
                borderRadius: BorderRadius.circular(AppDimens1.radiusMd),
                border: Border.all(color: DoctorColors.divider)),
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView(
              shrinkWrap: true,
              children: _filteredAddress.map((a) => ListTile(
                dense: true,
                leading: const Icon(Icons.location_on_outlined,
                    color: DoctorColors.textMuted, size: 18),
                title: Text(a, style: AppTextStyles.inputText),
                onTap: () {
                  setState(() {
                    _addressCtrl.text = a;
                    _form.address = a;
                    _showAddressSuggestions = false;
                  });
                  FocusScope.of(context).unfocus();
                },
              )).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Signature'),
        SignaturePad(data: doctorSignature),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _onSave,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
              color: DoctorColors.primaryVivid,
              borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
          child: const Text('Save',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  HELPERS
  // ════════════════════════════════════════════════════

  Widget _inputBox(
      TextEditingController ctrl,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? formatters,
        Widget? suffix,
      }) {
    return Container(
      height: AppDimens1.inputHeight,
      decoration: BoxDecoration(
          color: DoctorColors.inputBg,
          borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        style: AppTextStyles.inputText,
        decoration: InputDecoration(
          hintText:  hint,
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 13),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _buildDropdownSelector({
    required String  hint,
    required String? value,
    required List<DropdownOption> options,
    required bool    isOpen,
    required VoidCallback onToggle,
    required void Function(String) onSelect,
  }) {
    final label = value != null
        ? options.firstWhere((o) => o.value == value).label
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            height: AppDimens1.inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: DoctorColors.inputBg,
                borderRadius: BorderRadius.circular(AppDimens1.radiusMd)),
            child: Row(children: [
              Expanded(
                child: Text(label ?? hint,
                    style: label != null
                        ? AppTextStyles.inputText
                        : AppTextStyles.inputHint),
              ),
              Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: DoctorColors.primaryVivid, size: 20),
            ]),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: AppDimens1.xs),
          Container(
            decoration: BoxDecoration(
                color: DoctorColors.inputBg,
                borderRadius: BorderRadius.circular(AppDimens1.radiusMd),
                border: Border.all(color: DoctorColors.divider)),
            child: Column(
              children: options.asMap().entries.map((entry) {
                final isLast = entry.key == options.length - 1;
                final opt    = entry.value;
                return Column(children: [
                  GestureDetector(
                    onTap: () => onSelect(opt.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                      child: Row(children: [
                        Expanded(
                          child: Text(opt.label,
                              style: AppTextStyles.inputText),
                        ),
                        if (value == opt.value)
                          const Icon(Icons.check,
                              color: DoctorColors.primaryVivid, size: 16),
                      ]),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                        height: 1, color: DoctorColors.divider),
                ]);
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  String _genderLabel(Gender g) => g == Gender.male
      ? 'Male'
      : g == Gender.female
      ? 'Female'
      : 'Others';
}