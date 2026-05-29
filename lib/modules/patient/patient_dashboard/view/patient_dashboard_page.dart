import 'package:flutter/material.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      {
        "title": "Doctor Appointment",
        "count": "12",
        "icon": Icons.person,
        "color": const Color(0xffC8921E), // Dark Gold
      },
      {
        "title": "Online Consultation",
        "count": "08",
        "icon": Icons.video_call,
        "color": const Color(0xff2F8DB5), // Dark Sky Blue
      },
      {
        "title": "Health Package",
        "count": "05",
        "icon": Icons.favorite,
        "color": const Color(0xffB83349), // Dark Rose Red
      },
      {
        "title": "Health Records",
        "count": "26",
        "icon": Icons.folder_copy,
        "color": const Color(0xff249D7F), // Dark Mint Green
      },
      {
        "title": "Emergency Details",
        "count": "03",
        "icon": Icons.warning_amber_rounded,
        "color": const Color(0xff3F8D55), // Dark Green
      },
      {
        "title": "Lab Request",
        "count": "14",
        "icon": Icons.science,
        "color": const Color(0xff266A96), // Dark Blue
      },
      {
        "title": "Pharma Orders",
        "count": "19",
        "icon": Icons.medication,
        "color": const Color(0xff2496C7), // Dark Cyan Blue
      },
      {
        "title": "Home Care",
        "count": "07",
        "icon": Icons.home,
        "color": const Color(0xff2C6E96), // Steel Blue
      },
      {
        "title": "Wallet",
        "count": "₹ 4,500",
        "icon": Icons.account_balance_wallet,
        "color": const Color(0xff3F5058), // Dark Slate
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: CommonAppBar(title: "Patient Dashboard"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: item['color'] as Color,

                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['count'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    item['icon'] as IconData,
                    size: 48,
                    color: Colors.white.withOpacity(.9),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}