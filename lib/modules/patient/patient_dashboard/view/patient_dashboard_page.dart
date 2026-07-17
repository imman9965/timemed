import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) =>
          Transform.scale(scale: 0.9, child: child!),
    );
    if (picked != null) {
      setState(() => isStart ? startDate = picked : endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      {
        "title": "Doctor Appointment",
        "count": "0",
        "icon": Icons.event_available_rounded,
        "color": const Color(0xff1BA098),
        "route": AppRoutes.clinicalFilter,
      },
      {
        "title": "Online Consultation",
        "count": "0",
        "icon": Icons.video_call_rounded,
        "color": const Color(0xff2BA8DD),
        "route": AppRoutes.videoFilter,
      },
      {
        "title": "Health Package",
        "count": "0",
        "icon": Icons.favorite_rounded,
        "color": const Color(0xffE0394C),
        "route": AppRoutes.patientServices,
      },
      {
        "title": "Health Records",
        "count": "0",
        "icon": Icons.folder_copy_rounded,
        "color": const Color(0xff8BB832),
        "route": AppRoutes.patientPreviousAppointments,
      },
      {
        "title": "Emergency Details",
        "count": "0",
        "icon": Icons.warning_amber_rounded,
        "color": const Color(0xff37474F),
        "route": null,
      },
      {
        "title": "Lab Request",
        "count": "0",
        "icon": Icons.science_rounded,
        "color": const Color(0xff1BA098),
        "route": AppRoutes.patientNearbyLabsPage,
      },
      {
        "title": "Pharma Orders",
        "count": "0",
        "icon": Icons.medication_rounded,
        "color": const Color(0xff37474F),
        "route": AppRoutes.patientOrder,
      },
      {
        "title": "Home Care",
        "count": "0",
        "icon": Icons.home_rounded,
        "color": const Color(0xff8BB832),
        "route": null,
      },
      {
        "title": "Wallet",
        "count": "0",
        "icon": Icons.account_balance_wallet_rounded,
        "color": const Color(0xffF5A623),
        "route": null,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CurvedHeader(
            title: "PATIENT DASHBOARD",
            showBackButton: false,
            titleStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📅 DATE RANGE
                  Row(
                    children: [
                      Expanded(
                        child: _dateBox("Start Date", startDate,
                            () => _pickDate(true)),
                      ),
                      Container(
                        width: 1.8,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: AppColors.primary,
                      ),
                      Expanded(
                        child: _dateBox("End Date", endDate,
                            () => _pickDate(false)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  /// 🔹 STAT CARDS (rows of two + one full-width)
                  _cardRow(dashboardItems[0], dashboardItems[1]),
                  const SizedBox(height: 10),
                  _cardRow(dashboardItems[2], dashboardItems[3]),
                  const SizedBox(height: 10),
                  _statCard(dashboardItems[4], fullWidth: true),
                  const SizedBox(height: 10),
                  _cardRow(dashboardItems[5], dashboardItems[6]),
                  const SizedBox(height: 10),
                  _cardRow(dashboardItems[7], dashboardItems[8]),
                  const SizedBox(height: 10),
                  _actionBar(
                    "Book New Appointment",
                    AppColors.primary,
                        () => context.push(AppRoutes.clinicalFilter),
                  ),
                  const SizedBox(height: 88),



                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardRow(Map<String, dynamic> a, Map<String, dynamic> b) {
    return Row(
      children: [
        Expanded(child: _statCard(a)),
        const SizedBox(width: 10),
        Expanded(child: _statCard(b)),
      ],
    );
  }

  /// 🔹 DATE BOX (doctor dashboard style)
  Widget _dateBox(String label, DateTime? date, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date == null
                          ? "Select"
                          : DateFormat('d MMM yyyy').format(date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: date == null
                            ? Colors.grey
                            : const Color(0xFF212121),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 STAT CARD (doctor dashboard style)
  Widget _statCard(Map<String, dynamic> item, {bool fullWidth = false}) {
    final color = item['color'] as Color;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          final route = item['route'];
          if (route != null) context.push(route as String);
        },
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: 92,
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['count'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      item['title'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                item['icon'] as IconData,
                color: Colors.white.withOpacity(0.92),
                size: 46,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 BOTTOM ACTION BAR (doctor "Hospital Appointment" style)
  Widget _actionBar(String label, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.add, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
