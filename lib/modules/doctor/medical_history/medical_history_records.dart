import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/schedule_appointment/schedule_appointment.dart';
import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';

class medicalRecordHistoryDetails extends StatelessWidget {
  const medicalRecordHistoryDetails({super.key});

  static const Color primaryTeal = DoctorColors.successTeal;
  static const Color amberText   = DoctorColors.warningBronze;
  static const Color amberBg     = DoctorColors.warningSoftBg;
  static const Color notesOrange = DoctorColors.warningPeach;
  static const Color notesBg     = DoctorColors.warningPeachBg;

  @override
  Widget build(BuildContext context) {
    return SafeArea (
      child: Scaffold(
        backgroundColor: DoctorColors.backgroundStone,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPatientCard(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: [
                          _buildPrescriptionSection(),
                          const SizedBox(height: 16),
                          _buildLabTestSection(),
                          const SizedBox(height: 16),
                          _buildHealthRecordsSection(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: DoctorColors.primaryBrand,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Medical Records',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      color: DoctorColors.primaryBrand,
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:  DoctorColors.stoneTan,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 0.5),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: DoctorColors.stoneGrey,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mr. Immanuel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: DoctorColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildMetaChip(
                              Icons.calendar_today_outlined,
                              '4/29/2026',
                            ),
                            const SizedBox(width: 12),
                            _buildMetaChip(
                              Icons.access_time_outlined,
                              '5:09 PM',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DoctorColors.primaryBrand,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'DOCTOR VIEW',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: amberText),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: amberText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Prescription',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DoctorColors.textBlack,
              ),
            ),
            _buildPrintButton(),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notesBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color:  DoctorColors.stonePeachLine, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Doctor Notes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: notesOrange,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Follow the above mentioned drugs for 5 days',
                style: TextStyle(
                  fontSize: 13,
                  color: DoctorColors.textBlack,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabTestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lab test',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DoctorColors.textBlack,
              ),
            ),
            _buildPrintButton(),
          ],
        ),
        const SizedBox(height: 8),
        _buildEmptyCard(
          icon: Icons.receipt_long_outlined,
          title: 'No lab test',
          subtitle: 'No lab test added by doctor',
        ),
      ],
    );
  }

  Widget _buildHealthRecordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health records',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: DoctorColors.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        _buildEmptyCard(
          icon: Icons.folder_open_outlined,
          title: 'No health records',
          subtitle: 'No records uploaded yet',
        ),
      ],
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color:  DoctorColors.stoneLight),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: DoctorColors.stoneGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: DoctorColors.stoneLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPrintButton() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.print_outlined, size: 16, color: amberText),
          SizedBox(width: 4),
          Text(
            'Print',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: amberText,
            ),
          ),
        ],
      ),
    );
  }
}