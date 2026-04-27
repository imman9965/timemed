import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import 'dummy_data_1.dart';

const List<ConsultationOption> _consultationOptions = [
  ConsultationOption(type: ConsultationType.textOnly,
      label: 'Text Consultation Only'),
  ConsultationOption(type: ConsultationType.videoOnly,
      label: 'Video Consultation Only'),
  ConsultationOption(type: ConsultationType.both,
      label: 'Both Video and Text Consultation'),
];


final List<SummaryItem> _summaryItems = [
  SummaryItem(
    icon:  Icons.phone_outlined,
    label: 'Call Mode:',
    valueGetter: (d) => d.callMode,
  ),
  SummaryItem(
    icon:  Icons.medical_services_outlined,
    label: 'Consultation Type:',
    valueGetter: (d) => d.typeLabel,
  ),
  SummaryItem(
    icon:  Icons.hourglass_bottom_outlined,
    label: 'Call Duration:',
    valueGetter: (d) => '${d.callInterval}',
  ),
  SummaryItem(
    icon:  Icons.chat_bubble_outline,
    label: 'Text Fee:',
    valueGetter: (d) => '₹ ${d.textFee}',
  ),
  SummaryItem(
    icon:  Icons.videocam_outlined,
    label: 'Video Fee:',
    valueGetter: (d) => '₹ ${d.videoFee}',
  ),
];

class AddOnlineConsultationScheduleDialog extends StatefulWidget {
  const AddOnlineConsultationScheduleDialog({super.key});

  /// Static helper to open dialog from anywhere
  static Future<ConsultationScheduleData?> show(BuildContext context) {
    return showDialog<ConsultationScheduleData>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => const AddOnlineConsultationScheduleDialog(),
    );
  }

  @override
  State<AddOnlineConsultationScheduleDialog> createState() =>
      _AddOnlineConsultationScheduleDialogState();
}

class _AddOnlineConsultationScheduleDialogState
    extends State<AddOnlineConsultationScheduleDialog> {

  // ── Persistent data ───────────────────────────────────
  final _data = ConsultationScheduleData(
    type:         ConsultationType.both,
    textFee:      550,
    videoFee:     550,
    callInterval: 6,
  );

  // ── Controllers ───────────────────────────────────────
  late final TextEditingController _textFeeCtrl;
  late final TextEditingController _videoFeeCtrl;
  late final TextEditingController _intervalCtrl;

  // ── Last-saved snapshot (for summary) ─────────────────
  late ConsultationScheduleData _savedData;

  @override
  void initState() {
    super.initState();
    _textFeeCtrl  = TextEditingController(text: _data.textFee.toString());
    _videoFeeCtrl = TextEditingController(text: _data.videoFee.toString());
    _intervalCtrl = TextEditingController(text: _data.callInterval.toString());

    // Initial saved state shows ₹200 text fee as in image
    _savedData = ConsultationScheduleData(
      type:         ConsultationType.both,
      textFee:      200,
      videoFee:     550,
      callInterval: 6,
    );
  }

  @override
  void dispose() {
    _textFeeCtrl.dispose();
    _videoFeeCtrl.dispose();
    _intervalCtrl.dispose();
    super.dispose();
  }

  // ── Update action ─────────────────────────────────────
  void _onUpdate() {
    final textFee  = int.tryParse(_textFeeCtrl.text)  ?? 0;
    final videoFee = int.tryParse(_videoFeeCtrl.text) ?? 0;
    final interval = int.tryParse(_intervalCtrl.text) ?? 0;
    Navigator.pop(context);
    if (interval <= 0) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Call interval must be greater than 0'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _data.textFee      = textFee;
      _data.videoFee     = videoFee;
      _data.callInterval = interval;

      // Snapshot new data to summary
      _savedData = ConsultationScheduleData(
        type:         _data.type,
        textFee:      textFee,
        videoFee:     videoFee,
        callInterval: interval,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule updated successfully'),
        backgroundColor: AppColors.greenBtn2,
        duration: Duration(seconds: 1),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          // ── Main popup card ──────────────────────────
          Container(
            constraints: BoxConstraints(maxHeight: screenH * 0.86),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Blue header ────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    color: AppColors.primaryBlue,
                    child: const Text(
                      'ADD ONLINE CONSULTATION\nSCHEDULE LIST',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        height: 1.4,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // ── Scrollable body ────────────────
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildConsultationCard(),
                          const SizedBox(height: 10),
                          _buildFeeCard(
                            title: 'Text Consultation Charge',
                            controller: _textFeeCtrl,
                          ),
                          const SizedBox(height: 10),
                          _buildFeeCard(
                            title: 'Video Consultation Charge',
                            controller: _videoFeeCtrl,
                          ),
                          const SizedBox(height: 10),
                          _buildIntervalCard(),
                          const SizedBox(height: 16),
                          _buildUpdateButton(),
                          const SizedBox(height: 16),
                          _buildSummaryCard(),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -12,
            right: -6,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.redClose2,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.close,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  SECTION BUILDERS
  // ════════════════════════════════════════════════════

  Widget _buildConsultationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consultation',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          // Iterated from _consultationOptions
          ..._consultationOptions.map((opt) => _buildRadioRow(opt)),
        ],
      ),
    );
  }

  Widget _buildRadioRow(ConsultationOption opt) {
    final selected = _data.type == opt.type;
    return GestureDetector(
      onTap: () => setState(() => _data.type = opt.type),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          // Custom radio dot
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? AppColors.greenBtn2
                    : AppColors.radioOutline2,
                width: 1.5,
              ),
              color: selected ? AppColors.greenBtn2 : Colors.transparent,
            ),
            child: selected
                ? const Center(
              child: Icon(Icons.circle, color: Colors.white, size: 6),
            )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            opt.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildFeeCard({
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Row(children: [
            const Text('Fee: ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const Text('₹',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.feeGreen2)),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.feeGreen2,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildIntervalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Call Interval',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _intervalCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: _onUpdate,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.greenBtn2,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenBtn2.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Text(
          'Update',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: _summaryItems.asMap().entries.map((entry) {
          final isLast = entry.key == _summaryItems.length - 1;
          final item   = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(item.icon,
                        size: 18, color: AppColors.textDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.valueGetter(_savedData),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  color: AppColors.dividerColor,
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}


