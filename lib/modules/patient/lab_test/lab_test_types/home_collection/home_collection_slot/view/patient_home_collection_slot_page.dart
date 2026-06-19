import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientHomeCollectionSlotPage extends StatefulWidget {
  final List<LabTest> labTest;

  const PatientHomeCollectionSlotPage({
    super.key,
    required this.labTest,
  });

  @override
  State<PatientHomeCollectionSlotPage> createState() =>
      _PatientHomeCollectionSlotPageState();
}

class _PatientHomeCollectionSlotPageState
    extends State<PatientHomeCollectionSlotPage> {
  DateTime selectedDate = DateTime.now();

  String? selectedTime;

  final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  Widget build(BuildContext context) {
    final tests = widget.labTest;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Select Collection Slot",
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: selectedTime == null
                  ? null
                  : () {
                context.push(
                  AppRoutes.patientHomeCollectionAddress,
                  extra: {
                    "labTest": tests,
                    "selectedTime": selectedTime,
                    "selectedDate":
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                selectedTime == null
                    ? "Select Slot"
                    : "Continue • $selectedTime",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 TOP CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(.82),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tests.length == 1 
                              ? tests.first.testName 
                              : "${tests.length} Tests Selected",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          tests.length == 1 
                              ? tests.first.category 
                              : tests.map((e) => e.testName).join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.14),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.home_work_outlined,
                                      size: 16,
                                      color: Colors.white,
                                    ),

                                    SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        "Home Sample Collection",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                "₹${550 * tests.length}",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 DATE SECTION
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Select Date",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          "${_month(selectedDate.month)} ${selectedDate.day}",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 78,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 14,
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(
                          Duration(days: index),
                        );

                        final isSelected =
                            date.day == selectedDate.day &&
                                date.month == selectedDate.month;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 62,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  days[date.weekday % 7],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "${date.day}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 SLOT SECTION
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _timeColumn(
                  "Morning",
                  Icons.wb_sunny_outlined,
                  _morning(),
                ),

                _timeColumn(
                  "Afternoon",
                  Icons.sunny,
                  _afternoon(),
                ),

                _timeColumn(
                  "Evening",
                  Icons.wb_twilight_outlined,
                  _evening(),
                ),

                _timeColumn(
                  "Night",
                  Icons.nightlight_round,
                  _night(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeColumn(
      String title,
      IconData icon,
      List<Map<String, dynamic>> slots,
      ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            ...slots.map((slot) {
              bool available = slot["available"];
              bool isSelected =
                  selectedTime == slot["time"];

              return GestureDetector(
                onTap: available
                    ? () {
                  setState(() {
                    selectedTime = slot["time"];
                  });
                }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: !available
                        ? Colors.grey.shade100
                        : isSelected
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(.08),
                  ),
                  child: Center(
                    child: Text(
                      slot["time"],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: !available
                            ? Colors.grey
                            : isSelected
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _morning() => _gen([
    "07:00 AM",
    "07:30 AM",
    "08:00 AM",
    "08:30 AM",
  ]);

  List<Map<String, dynamic>> _afternoon() => _gen([
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
  ]);

  List<Map<String, dynamic>> _evening() => _gen([
    "04:00 PM",
    "04:30 PM",
    "05:00 PM",
  ]);

  List<Map<String, dynamic>> _night() => _gen([
    "07:00 PM",
    "07:30 PM",
    "08:00 PM",
  ]);

  List<Map<String, dynamic>> _gen(List<String> times) {
    return times
        .map(
          (e) => {
        "time": e,
        "available":
        DateTime.now().millisecond % 3 != 0,
      },
    )
        .toList();
  }

  String _month(int month) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[month];
  }
}