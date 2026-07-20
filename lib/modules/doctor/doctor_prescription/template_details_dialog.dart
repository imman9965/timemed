import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';
import '../doctor_basic_details/signature_pad.dart';

/// Shows the list of drugs inside a template.
/// Open via:
///   showDialog(
///     context: context,
///     builder: (_) => TemplateDetailDialog(
///       templateName: 'Template-1',
///       drugs: [...],
///     ),
///   );
///
/// Or push as a full screen via Navigator.push.
class TemplateDetailDialog extends StatefulWidget {
  final String templateName;
  final List<TemplateDrug> drugs;

  const TemplateDetailDialog({
    super.key,
    required this.templateName,
    required this.drugs,
  });

  @override
  State<TemplateDetailDialog> createState() => _TemplateDetailDialogState();
}

class _TemplateDetailDialogState extends State<TemplateDetailDialog> {
  late final List<TemplateDrug> _drugs;

  @override
  void initState() {
    super.initState();
    _drugs = List<TemplateDrug>.from(widget.drugs);
  }

  Future<void> _confirmDelete(int index) async {
    final drug = _drugs[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Drug?'),
        content: Text('Remove "${drug.name}" from this template?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: DoctorColors.errorRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => _drugs.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.85,
          maxWidth: 480,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: DoctorColors.backgroundFrost,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Flexible(
                child: _drugs.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  itemCount: _drugs.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (_, i) => _buildDrugRow(_drugs[i], i),
                ),
              ),
              // if (_drugs.isNotEmpty)
              //   const Padding(
              //     padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
              //     child: SignatureView(showName: false),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return Container(
      decoration:  BoxDecoration(
        color:DoctorColors.primaryBrand,
        // gradient: LinearGradient(
        //   colors: [DoctorColors.primaryDark, DoctorColors.primaryLight],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 8, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.templateName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // ---------- Empty ----------
  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medication_outlined,
                size: 56, color: DoctorColors.textSecondary),
            SizedBox(height: 12),
            Text(
              'No drugs in this template',
              style: TextStyle(color: DoctorColors.textSecondary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Drug row ----------
  Widget _buildDrugRow(TemplateDrug drug, int index) {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DoctorColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: DoctorColors.primary.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drug.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DoctorColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatSubtitle(drug),
                  style: const TextStyle(
                    fontSize: 14,
                    color: DoctorColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _confirmDelete(index),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: DoctorColors.errorSoftBg,
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: DoctorColors.errorRed.withOpacity(0.4)),
                ),
                child: const Icon(Icons.delete_outline,
                    color: DoctorColors.errorRed, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSubtitle(TemplateDrug d) {
    return 'Frequency: ${d.frequency}, ${d.days} Day${d.days == 1 ? '' : 's'}, '
        'Qty: ${d.qty}, ${d.foodRelation}';
  }
}

// ============================================================
// Drug model
// ============================================================
class TemplateDrug {
  final String name;
  final String frequency; // e.g. "1-1-0-1"
  final int days;
  final int qty;
  final String foodRelation; // e.g. "Before Food", "After Food"

  const TemplateDrug({
    required this.name,
    required this.frequency,
    required this.days,
    required this.qty,
    required this.foodRelation,
  });
}

// ============================================================
// DEMO usage — drop this into your code to test the dialog
// ============================================================
//
// To show the dialog from anywhere:
//
// showDialog(
//   context: context,
//   builder: (_) => const TemplateDetailDialog(
//     templateName: 'Template-1',
//     drugs: kSampleTemplateDrugs,
//   ),
// );
//
const List<TemplateDrug> kSampleTemplateDrugs = [
  TemplateDrug(
    name: 'itraconazolwe',
    frequency: '1-1-0-1',
    days: 1,
    qty: 2,
    foodRelation: 'Before Food',
  ),
  TemplateDrug(
    name: 'DOXYCYCLINE',
    frequency: '1-0-0-1',
    days: 3,
    qty: 3,
    foodRelation: 'Intake/How to use',
  ),
  TemplateDrug(
    name: 'avamys nasal spray',
    frequency: '1-1-0-1',
    days: 2,
    qty: 3,
    foodRelation: 'Before Food',
  ),
  TemplateDrug(
    name: 'avamys nasal spray',
    frequency: '1-1-0-1',
    days: 2,
    qty: 3,
    foodRelation: 'Before Food',
  ),
  TemplateDrug(
    name: 'avamys nasal spray',
    frequency: '1-1-0-0',
    days: 4,
    qty: 5,
    foodRelation: 'Before Food',
  ),
  TemplateDrug(
    name: 'avamys nasal spray',
    frequency: '1-1-0-0',
    days: 4,
    qty: 5,
    foodRelation: 'Before Food',
  ),
  TemplateDrug(
    name: 'avamys nasal spray',
    frequency: '1-1-1-1',
    days: 85,
    qty: 55,
    foodRelation: 'After Food',
  ),
  TemplateDrug(
    name: 'T. CTD 12.5 MG',
    frequency: '1-0-0-1',
    days: 3,
    qty: 3,
    foodRelation: 'After Food',
  ),
];
