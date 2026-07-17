import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/doctor_theme.dart';
import 'dummy_data_1.dart';

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


  late final TextEditingController textFeeCtrl;
  late final TextEditingController videoFeeCtrl;
  late final TextEditingController intervalCtrl;
  late ConsultationScheduleData _savedData;

  @override
  void initState() {
    super.initState();
    textFeeCtrl  = TextEditingController(text: data.textFee.toString());
    videoFeeCtrl = TextEditingController(text: data.videoFee.toString());
    intervalCtrl = TextEditingController(text: data.callInterval.toString());
    _savedData = ConsultationScheduleData(
      type:         ConsultationType.both,
      textFee:      200,
      videoFee:     550,
      callInterval: 6,
    );
  }

  @override
  void dispose() {
    textFeeCtrl.dispose();
    videoFeeCtrl.dispose();
    intervalCtrl.dispose();
    super.dispose();
  }

  // ── Update action ─────────────────────────────────────
  void _onUpdate() {
    final textFee  = int.tryParse(textFeeCtrl.text)  ?? 0;
    final videoFee = int.tryParse(videoFeeCtrl.text) ?? 0;
    final interval = int.tryParse(intervalCtrl.text) ?? 0;

    if (interval <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Call interval must be greater than 0'),
          backgroundColor: DoctorColors.error,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      data.textFee      = textFee;
      data.videoFee     = videoFee;
      data.callInterval = interval;

      // Snapshot new data to summary
      _savedData = ConsultationScheduleData(
        type:         data.type,
        textFee:      textFee,
        videoFee:     videoFee,
        callInterval: interval,
      );
    });

    // Return the saved data to caller so parent can persist it
    Navigator.pop(context, _savedData);
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
                    color: DoctorColors.primaryBrand,
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
                            controller: textFeeCtrl,
                          ),
                          const SizedBox(height: 10),
                          _buildFeeCard(
                            title: 'Video Consultation Charge',
                            controller: videoFeeCtrl,
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
                  color: DoctorColors.error,
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
        color: DoctorColors.cardWhite,
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
              color: DoctorColors.primaryBrand,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          // Iterated from _consultationOptions
          ...consultationOptions.map((opt) => _buildRadioRow(opt)),
        ],
      ),
    );
  }

  Widget _buildRadioRow(ConsultationOption opt) {
    final selected = data.type == opt.type;
    return GestureDetector(
      onTap: () => setState(() => data.type = opt.type),
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
                    ? DoctorColors.success
                    : DoctorColors.avatarGrey,
                width: 1.5,
              ),
              color: selected ? DoctorColors.success : Colors.transparent,
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
              color: DoctorColors.textDark,
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
        color: DoctorColors.cardWhite,
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
              color: DoctorColors.primaryBrand,
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
                    color: DoctorColors.textDark)),
            const Text('₹',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: DoctorColors.successDeep)),
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
                  color: DoctorColors.successDeep,
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
        color: DoctorColors.cardWhite,
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
              color: DoctorColors.primaryBrand,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: intervalCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: DoctorColors.textDark,
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
          color: DoctorColors.success,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: DoctorColors.success.withOpacity(0.3),
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
        color: DoctorColors.cardWhite,
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
        children: summaryItems.asMap().entries.map((entry) {
          final isLast = entry.key == summaryItems.length - 1;
          final item   = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(item.icon,
                        size: 18, color: DoctorColors.textDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              color: DoctorColors.primaryBrand,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.valueGetter(_savedData),
                            style: const TextStyle(
                              fontSize: 12,
                              color: DoctorColors.textDark,
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
                  color: DoctorColors.divider,
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


