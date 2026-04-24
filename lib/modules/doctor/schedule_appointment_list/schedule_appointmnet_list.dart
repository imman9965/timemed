import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../widgets/vitals.dart';

// ════════════════════════════════════════════════════════
//  CONSTANTS
// ════════════════════════════════════════════════════════

class AppColors {
  static const primary     = Color(0xFF1A6BF5);
  static const scaffoldBg  = Color(0xFFFAF5EC);
  static const cardBg      = Colors.white;
  static const textDark    = Color(0xFF1A1A2E);
  static const textSecond  = Color(0xFF6B7280);
  static const green       = Color(0xFF4CAF50);
  static const paidGreen   = Color(0xFF2E7D32);
  static const unpaidRed   = Color(0xFFE53935);
  static const divider     = Color(0xFFE0E0E0);
  static const unknownGrey = Color(0xFFCFD8DC);
}



enum PaymentStatus { paid, unpaid }
enum VitalStatus   { unknown, collected }

class AppointmentListItem {
  final String        hospitalName;
  final int           confirmedCount;
  final int           missedCount;
  final String        visitId;
  final String        tokenNo;
  final VitalStatus   vitalStatus;
  final PaymentStatus paymentStatus;
  // Optional patient info (second card style)
  final String?       patientName;
  final String?       patientId;
  final String?       date;
  final String?       time;
  final String?       symptoms;

  const AppointmentListItem({
    required this.hospitalName,
    required this.confirmedCount,
    required this.missedCount,
    required this.visitId,
    required this.tokenNo,
    required this.vitalStatus,
    required this.paymentStatus,
    this.patientName,
    this.patientId,
    this.date,
    this.time,
    this.symptoms,
  });
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

final List<AppointmentListItem> _appointmentList = [
  const AppointmentListItem(
    hospitalName:   'Sangamithra Hospital',
    confirmedCount: 0,
    missedCount:    0,
    visitId:        '244477',
    tokenNo:        '02',
    vitalStatus:    VitalStatus.unknown,
    paymentStatus:  PaymentStatus.paid,
  ),
  const AppointmentListItem(
    hospitalName:   'Sangamithra Hospital',
    confirmedCount: 0,
    missedCount:    0,
    visitId:        '244477',
    tokenNo:        '01',
    vitalStatus:    VitalStatus.unknown,
    paymentStatus:  PaymentStatus.unpaid,
    patientName:    'Vignesh',
    patientId:      '313311',
    date:           '1/7/2026',
    time:           '12:20 PM',
    symptoms:       'No Symtoms',
  ),
];

// ════════════════════════════════════════════════════════
//  REUSABLE — CURVED HEADER
// ════════════════════════════════════════════════════════

class CurvedHeader extends StatelessWidget {
  final String title;
  const CurvedHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft:  Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 18,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          height: 1.2,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — BARCODE (accurate rendering)
// ════════════════════════════════════════════════════════

class BarcodeWidget extends StatelessWidget {
  final double width;
  final double height;
  const BarcodeWidget({Key? key, this.width = 120, this.height = 42})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _BarcodePainter()),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  // Bar widths pattern (width, gap, width, gap, ...)
  // Thick = 3px, Medium = 2px, Thin = 1px, gaps = 1-2px
  static const _pattern = [
    3, 1, 1, 2, 2, 1, 1, 1, 3, 2, 1, 1, 2, 1, 1, 2, 3, 1, 2, 1,
    1, 2, 3, 1, 1, 1, 2, 2, 1, 1, 3, 1, 2, 1, 1, 3, 1, 2, 2, 1,
    1, 2, 3, 1, 1, 1, 2, 3,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    double x = 0;
    final totalUnits = _pattern.fold<int>(0, (a, b) => a + b);
    final unit = size.width / totalUnits;

    for (int i = 0; i < _pattern.length; i++) {
      final w = _pattern[i] * unit;
      if (i.isEven) {
        // Draw bar
        canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      }
      x += w;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════
//  REUSABLE — QR CODE (accurate grid pattern)
// ════════════════════════════════════════════════════════

class QrCodeWidget extends StatelessWidget {
  final double size;
  const QrCodeWidget({Key? key, this.size = 42}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _QrPainter()),
    );
  }
}

class _QrPainter extends CustomPainter {
  // 11×11 pattern — 1 = black, 0 = white
  static const _grid = [
    [1,1,1,1,1,1,1,0,1,0,1],
    [1,0,0,0,0,0,1,0,0,1,1],
    [1,0,1,1,1,0,1,0,1,0,1],
    [1,0,1,1,1,0,1,0,1,1,0],
    [1,0,1,1,1,0,1,0,0,0,1],
    [1,0,0,0,0,0,1,0,1,1,1],
    [1,1,1,1,1,1,1,0,1,0,1],
    [0,0,0,0,0,0,0,0,1,1,0],
    [1,0,1,1,0,1,1,0,1,0,1],
    [0,1,0,0,1,0,0,1,0,1,1],
    [1,1,1,0,1,1,1,0,1,0,1],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final cell = size.width / 11;

    for (int r = 0; r < 11; r++) {
      for (int c = 0; c < 11; c++) {
        if (_grid[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell, r * cell, cell + 0.5, cell + 0.5),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════
//  REUSABLE — PILL BUTTON (Print / Vital Sign)
// ════════════════════════════════════════════════════════

class PillButton extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final VoidCallback onTap;

  const PillButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — APPOINTMENT CARD
// ════════════════════════════════════════════════════════

class AppointmentCard extends StatelessWidget {
  final AppointmentListItem item;
  final VoidCallback onPrint;
  final VoidCallback onVitalSign;

  const AppointmentCard({
    Key? key,
    required this.item,
    required this.onPrint,
    required this.onVitalSign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPaid    = item.paymentStatus == PaymentStatus.paid;
    final isUnknown = item.vitalStatus   == VitalStatus.unknown;
    final hasPatient = item.patientName != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Patient header (only if has patient) ────────
          if (hasPatient) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.calendar_month,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(item.date!,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.access_time,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(item.time!,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark)),
                    ]),
                  ],
                ),
                const Spacer(),
                Row(children: [
                  Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.patientName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      Text('Patient ID: ${item.patientId}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecond)),
                    ],
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Symptoms: ',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                Text(item.symptoms!,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 4),
          ],

          // ── Hospital name ──────────────────────────────
          Row(children: [
            const Text('Hospital Name: ',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            Text(item.hospitalName,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          // ── Confirmed + Missed ─────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Confirmed',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Row(children: [
                      const Text('Appointments: ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      Text('${item.confirmedCount}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.green,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Missed',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Row(children: [
                      const Text('Appointments: ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      Text('${item.missedCount}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.unpaidRed,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          // ── Visit ID + Token + Unknown badge ──────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('Visit ID: ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      Text(item.visitId,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Text('Token No.  :  ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      Text(item.tokenNo,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.unknownGrey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isUnknown ? 'UNKNOWN: Y' : 'KNOWN: Y',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('VITAL COLLECTED',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),

          // ── Patient ID + Barcode + PAID + QR ─────────
          Row(
            children: [
              const Text('Patient ID:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const Spacer(),
              const Text('Bar Code:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barcode
              const BarcodeWidget(width: 130, height: 46),
              const Spacer(),
              // PAID / UNPAID
              Row(
                children: [
                  Text(isPaid ? '💰' : '❌',
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 4),
                  Text(
                    isPaid ? 'PAID' : 'UNPAID',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isPaid
                          ? AppColors.paidGreen
                          : AppColors.unpaidRed,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // QR
              const QrCodeWidget(size: 46),
            ],
          ),
          const SizedBox(height: 14),

          // ── Print + Vital Sign ────────────────────────
          Row(
            children: [
              PillButton(
                icon:  Icons.print,
                label: 'Print',
                onTap: onPrint,
              ),
              const SizedBox(width: 14),
              PillButton(
                icon:  Icons.monitor_heart_outlined,
                label: 'Vital Sign',
                onTap: onVitalSign,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class ScheduledAppointmentListScreen extends StatelessWidget {
  const ScheduledAppointmentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const CurvedHeader(title: 'Scheduled Appointment\nList'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                children: _appointmentList.map((item) {
                  return AppointmentCard(
                    item: item,
                    onPrint: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text('Printing…'),
                      duration: Duration(seconds: 1),
                    )),
                    onVitalSign: () {
                      VitalSignDialog.show(context);

                    }

                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}