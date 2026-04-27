import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../../../core/constants/app_colors.dart';
import '../missed_call_page/missed_call.dart';
import '../widgets/doctor_stamp.dart';
import 'dummy_data_9.dart' hide PaymentStatus;

class SectionHeader extends StatelessWidget {
  final String label;
  final String statusText;
  final Color  statusColor;

  const SectionHeader({
    Key? key,
    required this.label,
    required this.statusText,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecond,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 6),
            Container(
              width: 7, height: 7,
              decoration: BoxDecoration(
                  color: statusColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(statusText,
                style: TextStyle(
                    fontSize: 13,
                    color: statusColor,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        const Divider(color: AppColors.divider, height: 1),
      ],
    );
  }
}

/// Patient waiting card
class PatientWaitingCard extends StatelessWidget {
  final WaitingPatient patient;
  const PatientWaitingCard({Key? key, required this.patient}) : super(key: key);

  String get _typeLabel =>
      patient.type == AppointmentType.instant ? 'Instant' : 'Schedule';
  String get _typeIcon =>
      patient.type == AppointmentType.instant ? '⚡' : '📅';

  Color get _statusBg {
    switch (patient.waitingStatus) {
      case WaitingStatus.waiting:    return AppColors.waitingYellow;
      case WaitingStatus.inProgress: return const Color(0xFFE3F2FD);
      case WaitingStatus.done:       return AppColors.green2;
    }
  }

  Color get _statusTextColor {
    switch (patient.waitingStatus) {
      case WaitingStatus.waiting:    return AppColors.waitingText;
      case WaitingStatus.inProgress: return AppColors.primary;
      case WaitingStatus.done:       return AppColors.green2;
    }
  }

  String get _statusLabel {
    switch (patient.waitingStatus) {
      case WaitingStatus.waiting:    return 'Waiting';
      case WaitingStatus.inProgress: return 'In Progress';
      case WaitingStatus.done:       return 'Done';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = patient.paymentStatus == PaymentStatus.paid;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Avatar + Appointment ID + Type ──────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.person,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 10),

              // Name + Phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appointment ID top-right
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Appointment ID: ${patient.appointmentId}',
                        style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Type top-right
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Type: $_typeIcon $_typeLabel',
                        style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecond),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Row 2: Name + PAID badge ────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                patient.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
              // PAID / UNPAID badge
              Row(
                children: [
                  Text(isPaid ? '💰' : '❌', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    isPaid ? 'PAID' : 'UNPAID',
                    style: TextStyle(
                      color: isPaid ? AppColors.paidGreen : Colors.red,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Phone
          Row(
            children: [
              const Icon(Icons.phone, size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(patient.phone,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecond)),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Waiting status pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                            color: _statusTextColor,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _statusLabel,
                        style: TextStyle(
                          color: _statusTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(patient.date,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500)),
                  ],
                ),

                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(patient.time,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Add Patient FAB-style button
class AddPatientButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddPatientButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'Add Patient',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom navigation bar
// class AppBottomNav extends StatelessWidget {
//   final int activeIndex;
//   final void Function(int) onTap;
//
//   const AppBottomNav({
//     Key? key,
//     required this.activeIndex,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.circular(50),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.4),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: _navItems.asMap().entries.map((entry) {
//           final index  = entry.key;
//           final item   = entry.value;
//           final active = index == activeIndex;
//
//           return GestureDetector(
//             onTap: () => onTap(index),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: active
//                     ? Colors.white.withOpacity(0.25)
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: item.hasAvatar
//                   ? Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Icon(item.icon, color: Colors.white, size: 22),
//                   Positioned(
//                     bottom: 6,
//                     right: 6,
//                     child: Container(
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                         color: AppColors.green,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                             color: AppColors.primary, width: 1.5),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//                   : Icon(item.icon, color: Colors.white, size: 24),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class PatientWaitingListScreen extends StatefulWidget {
  const PatientWaitingListScreen({Key? key}) : super(key: key);

  @override
  State<PatientWaitingListScreen> createState() =>
      _PatientWaitingListScreenState();
}

class _PatientWaitingListScreenState
    extends State<PatientWaitingListScreen> {

  int _activeNavIndex = 1; // patients tab active by default

  void _onAddPatient() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Patient tapped'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var doctor =  'Dr.Mariappan';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // ── Main scrollable content ────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                const CurvedHeader(title: 'Patient Waiting List'),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Doctor badge ───────────────────────
                        DoctorBadge(doctor: doctor),
                        const SizedBox(height: 14),

                        // ── Online patients section ────────────
                        const SectionHeader(
                          label:       'Patients Available',
                          statusText:  'Online',
                          statusColor: Colors.blue,
                        ),

                        const SizedBox(height: 12),

                        // Iterated from _onlinePatients
                        // ..._onlinePatients.map(
                        //       (p) => PatientWaitingCard(patient: p),
                        // ),

                        const SizedBox(height: 8),

                        // ── In-person patients section ─────────
                        // const SectionHeader(
                        //   label:       'Patients in',
                        //   statusText:  'Online',
                        //   statusColor: Colors.orange,
                        // ),
                        const SizedBox(height: 12),

                        // Iterated from _inPersonPatients
                        ...inPersonPatients.map(
                              (p) => PatientWaitingCard(patient: p),
                        ),

                        const SizedBox(height: 16),

                        // ── Add Patient button (right-aligned) ──
                        Align(
                          alignment: Alignment.centerRight,
                          child: AddPatientButton(onTap: _onAddPatient),
                        ),

                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: AddPatientButton(onTap: _onAddPatient),
                        // ),


                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Pinned bottom nav ──────────────────────────────
          // Positioned(
          //   left: 0, right: 0, bottom: 0,
          //   child: AppBottomNav(
          //     activeIndex: _activeNavIndex,
          //     onTap: (i) => setState(() => _activeNavIndex = i),
          //   ),x
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.videoPage);
        },

        child:const Icon(Icons.video_call, color: Colors.blue),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,    );
  }
}