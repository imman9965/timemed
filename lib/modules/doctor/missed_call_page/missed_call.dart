import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../../../routes/app_routes.dart';
import '../widgets/doctor_stamp.dart';

enum PaymentStatus { paid, unpaid }

class Doctor {
  final String name;
  const Doctor({required this.name});
}

class MissedCallPatient {
  final String        name;
  final String        date;
  final String        time;
  final PaymentStatus paymentStatus;

  const MissedCallPatient({
    required this.name,
    required this.date,
    required this.time,
    required this.paymentStatus,
  });
}

class NavItem {
  final IconData icon;
  final bool     isCircle;
  const NavItem({required this.icon, this.isCircle = false});
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

String doctor = 'Dr.Mariappan';

final List<MissedCallPatient> _missedCallPatients = [
  const MissedCallPatient(
    name: 'Vignesh', date: '1/7/2026', time: '12:20 PM',
    paymentStatus: PaymentStatus.paid,
  ),
  const MissedCallPatient(
    name: 'Vimala',  date: '1/7/2026', time: '12:20 PM',
    paymentStatus: PaymentStatus.paid,
  ),
  const MissedCallPatient(
    name: 'Vignesh', date: '1/7/2026', time: '12:20 PM',
    paymentStatus: PaymentStatus.paid,
  ),
  const MissedCallPatient(
    name: 'Vimala',  date: '1/7/2026', time: '12:20 PM',
    paymentStatus: PaymentStatus.paid,
  ),
  const MissedCallPatient(
    name: 'Vignesh', date: '1/7/2026', time: '12:20 PM',
    paymentStatus: PaymentStatus.paid,
  ),
];


// ════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ════════════════════════════════════════════════════════

/// Curved blue header

/// Green pill doctor badge

/// Blue "Missed Call Patient List" tab + Filter button row
class ListTabBar extends StatelessWidget {
  final String  label;
  final VoidCallback onFilter;

  const ListTabBar({
    Key? key,
    required this.label,
    required this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Active tab pill
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: DoctorColors.primaryBrand,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Filter button
        GestureDetector(
          onTap: onFilter,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: DoctorColors.primaryBrand,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('Filter',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Single missed call patient row card
class MissedCallCard extends StatelessWidget {
  final MissedCallPatient patient;
  final VoidCallback      onReschedule;

  const MissedCallCard({
    Key? key,
    required this.patient,
    required this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPaid = patient.paymentStatus == PaymentStatus.paid;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Row 1: Avatar + Name + Date + Time ───────────
          Row(
            children: [
              // Avatar circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: DoctorColors.dividerNeutral,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.person,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),

              // Name
              Expanded(
                child: Text(
                  patient.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: DoctorColors.textDark,
                  ),
                ),
              ),

              // Date
              Row(children: [
                Image.asset(
                  'assets/icons/img_21.png',
                  width: 13,
                  height: 13,
                  color: DoctorColors.primaryBrand,
                ),
                const SizedBox(width: 4),
                Text(patient.date,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: DoctorColors.textDark)),
              ]),
              const SizedBox(width: 12),

              // Time
              Row(children: [
                Image.asset(
                  'assets/icons/img_22.png',
                  width: 14,
                  height: 14,
                  color: DoctorColors.primaryBrand,
                ),
                const SizedBox(width: 4),
                Text(patient.time,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: DoctorColors.textDark)),
              ]),
            ],
          ),

          const SizedBox(height: 10),

          // ── Row 2: PAID badge + RE SCHEDULE button ────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Paid/Unpaid
              Row(
                children: [
                  isPaid
                      ? Image.asset(
                    'assets/icons/img_20.png',
                    width: 18,
                    height: 18,
                  )
                      : const Text(
                    '❌',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isPaid ? 'PAID' : 'UNPAID',
                    style: TextStyle(
                      color: isPaid
                          ? DoctorColors.success
                          : DoctorColors.error,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              // RE SCHEDULE button
              GestureDetector(
                onTap: onReschedule,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: DoctorColors.primaryBrand,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'RE SCHEDULE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class MissedCallPatientListScreen extends StatefulWidget {
  const MissedCallPatientListScreen({Key? key}) : super(key: key);

  @override
  State<MissedCallPatientListScreen> createState() =>
      _MissedCallPatientListScreenState();
}

class _MissedCallPatientListScreenState
    extends State<MissedCallPatientListScreen> {

  int _activeNavIndex = 2;

  // ── Filter bottom sheet ───────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Options',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _filterTile(Icons.check_circle, DoctorColors.success,
                'Paid only', () => _applyFilter('Paid')),
            _filterTile(Icons.cancel, DoctorColors.error,
                'Unpaid only', () => _applyFilter('Unpaid')),
            _filterTile(Icons.sort, DoctorColors.primaryBrand,
                'Sort by date', () => _applyFilter('Date')),
          ],
        ),
      ),
    );
  }

  ListTile _filterTile(
      IconData icon, Color color, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _applyFilter(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filter applied: $type'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ── Reschedule action ─────────────────────────────────
  void _onReschedule(BuildContext context) {
    context.push(
      AppRoutes.rescheduleAppointment,
    );
  }


  String doctor = "Dr.Mariappan";

  // ── Build ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: Stack(
        children: [
          // ── Scrollable content ───────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                CurvedHeader(title: 'MISSED CALL PATIENT LIST', showBackButton: false,
                  leading: DoctorBadge(doctor: doctor),
                  titleStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListTabBar(
                          label:    'Missed Call Patient List',
                          onFilter: _showFilterSheet,
                        ),
                        const SizedBox(height: 14),
                        ..._missedCallPatients.map(
                              (patient) => MissedCallCard(
                            patient:     patient,
                            onReschedule: () => _onReschedule(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}