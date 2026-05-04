// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Medical Records',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
//         useMaterial3: true,
//       ),
//       home: const MedicalRecordsScreen(),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class MedicalRecord {
  final String name;
  final String date;
  final String time;

  const MedicalRecord({
    required this.name,
    required this.date,
    required this.time,
  });
}

class MedicalRecordsScreenHistory extends StatelessWidget {
  const MedicalRecordsScreenHistory({super.key});

  final List<MedicalRecord> records = const [
    MedicalRecord(name: 'Mr. Immanuel', date: '4/29/2026', time: '5:09 PM'),
    MedicalRecord(name: 'Mr. Vignesh',  date: '4/29/2026', time: '5:05 PM'),
    MedicalRecord(name: 'Mr. Vignesh',  date: '4/22/2026', time: '8:30 PM'),
    MedicalRecord(name: 'Mr. Vignesh',  date: '4/17/2026', time: '4:32 PM'),
    MedicalRecord(name: 'Mr. Vignesh',  date: '4/17/2026', time: '4:31 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) =>
                  _MedicalRecordCard(record: records[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 22),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              const Text(
                'MEDICAL HISTORY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicalRecordCard extends StatelessWidget {
  final MedicalRecord record;

  const _MedicalRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB), width: 0.8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Info Row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF1976D2),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                // Name
                Expanded(
                  child: Text(
                    record.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Date & Time Row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
            child: Row(
              children: [
                _MetaChip(
                  icon: Icons.calendar_today_rounded,
                  label: record.date,
                ),
                const SizedBox(width: 14),
                _MetaChip(
                  icon: Icons.access_time_rounded,
                  label: record.time,
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF90CAF9),
                  size: 22,
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Doctor View Button
          InkWell(
            onTap: () {
              context.push(AppRoutes.medicalRecordHistoryDetails);
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const Text(
                'DOCTOR VIEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF1976D2)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
      ],
    );
  }
}