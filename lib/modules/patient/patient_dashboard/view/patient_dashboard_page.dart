import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      {
        "title": "Doctor Appointment",
        "count": "12",
        "icon": Icons.person,
        "color": const Color(0xff24BFA5), // Scheduled Green
        "route": AppRoutes.clinicalFilter,
      },
      {
        "title": "Online Consultation",
        "count": "08",
        "icon": Icons.video_call,
        "color": const Color(0xffF39C12), // Missed Orange
        "route": AppRoutes.videoFilter,
      },
      {
        "title": "Health Package",
        "count": "05",
        "icon": Icons.favorite,
        "color": const Color(0xffE14343), // Check Out Red
        "route": AppRoutes.patientServices,
      },
      {
        "title": "Health Records",
        "count": "26",
        "icon": Icons.folder_copy,
        "color": const Color(0xff98C23A), // OT Request Light Green
        "route": AppRoutes.patientPreviousAppointments,
      },
      {
        "title": "Emergency Details",
        "count": "03",
        "icon": Icons.warning_amber_rounded,
        "color": const Color(0xff2C3A4B), // Dark Grey
        "route": null,
      },
      {
        "title": "Lab Request",
        "count": "14",
        "icon": Icons.science,
        "color": const Color(0xff24BFA5), // Reusing Green
        "route": AppRoutes.patientNearbyLabsPage,
      },
      {
        "title": "Pharma Orders",
        "count": "19",
        "icon": Icons.medication,
        "color": const Color(0xff2C3A4B), // Reusing Dark Grey
        "route": AppRoutes.patientOrder,
      },
      {
        "title": "Home Care",
        "count": "07",
        "icon": Icons.home,
        "color": const Color(0xff98C23A), // Reusing Light Green
        "route": null,
      },
      {
        "title": "Wallet",
        "count": "₹ 4,500",
        "icon": Icons.account_balance_wallet,
        "color": const Color(0xffF39C12), // Reusing Orange
        "route": null,
      },
    ];


    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: const CommonAppBar(showBack: false, title: "Patient Dashboard"),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// 📅 TOP DATE PICKERS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _datePickerBox(
                      "Start Date",
                      startDate,
                      (date) => setState(() => startDate = date),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 24,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                      ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _datePickerBox(
                      "End Date",
                      endDate,
                      (date) => setState(() => endDate = date),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          /// 🔹 FIRST 4 ITEMS (2x2 Grid)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildDashboardCard(context, dashboardItems[index]),
                childCount: 4,
              ),
            ),
          ),

          /// 🔹 5th ITEM (Full Width - BLACK)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildDashboardCard(context, dashboardItems[4], isFullWidth: true),
            ),
          ),

          /// 🔹 LAST 4 ITEMS (2x2 Grid)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildDashboardCard(context, dashboardItems[index + 5]),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePickerBox(String label, DateTime? date, Function(DateTime) onSelected) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.white)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   label ,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight:FontWeight.w600,
                    ),
                  ),
                  Text(
                    date == null
                        ? label
                        : DateFormat('dd MMMM yyyy').format(date),
                    style: TextStyle(
                      fontSize: 14,
                      color: date == null ? Colors.grey : Colors.black87,
                      fontWeight: date == null ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ), Icon(Icons.keyboard_arrow_down_sharp, size: 20, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, Map<String, dynamic> item, {bool isFullWidth = false}) {
    final bool isBlack = (item['color'] as Color).toARGB32() == 0xff000000;

    return InkWell(
      onTap: () {
        if (item['route'] != null) {
          context.push(item['route'] as String);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item['color'] as Color,
          borderRadius: BorderRadius.circular(6),
          // boxShadow: [
          //   BoxShadow(
          //     color: isBlack ? Colors.black.withValues(alpha: 0.2) : (item['color'] as Color).withValues(alpha: 0.3),
          //     blurRadius: 6,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['count'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              item['icon'] as IconData,
              size: isFullWidth ? 48 : 36,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
