import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common/appointment_slot_grid.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientLabSlotSelectionPage extends StatefulWidget {
  final Map<String, dynamic> selectedLab;
  final List<LabTest> labTest;

  const PatientLabSlotSelectionPage({
    super.key,
    required this.selectedLab,
    required this.labTest,
  });

  @override
  State<PatientLabSlotSelectionPage> createState() =>
      _PatientLabSlotSelectionPageState();
}

class _PatientLabSlotSelectionPageState
    extends State<PatientLabSlotSelectionPage> {
  DateTime selectedDate = DateTime.now();
  int selectedDay = DateTime.now().weekday % 7;

  String? selectedTime;

  final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  void changeDate(int diff) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: diff));
      selectedDay = selectedDate.weekday % 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lab = widget.selectedLab;
    final tests = widget.labTest;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Select Slot",
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
                  AppRoutes.patientLabTestCheckout,
                  extra: {
                    "labTest": tests,
                    "selectedLab": lab,
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
                  fontSize: 14,
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
            /// 🔹 LAB CARD
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
                      Icons.science,
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
                          lab["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          lab["address"],
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
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.biotech,
                                      size: 16,
                                      color: Colors.white,
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        tests.length == 1 
                                            ? tests.first.testName 
                                            : "${tests.length} Tests Selected",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
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
                                "₹${lab["price"] * tests.length}",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
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
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => changeDate(-1),
                        icon: const Icon(Icons.chevron_left),
                      ),

                      Text(
                        "${_month(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),

                      IconButton(
                        onPressed: () => changeDate(1),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: List.generate(days.length, (index) {
                      bool isSelected = selectedDay == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = index;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              days[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.black,
                              ),
                            ),

                            const SizedBox(height: 6),

                            AnimatedContainer(
                              duration:
                              const Duration(milliseconds: 250),
                              height: 3,
                              width: 24,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 SLOT SECTION
            AppointmentSlotGrid(
              selectedTime: selectedTime,
              onSlotTap: (time) {
                setState(() => selectedTime = time);
              },
              columns: buildDefaultSlotColumns(
                morning: _morning(),
                afternoon: _afternoon(),
                evening: _evening(),
                night: _night(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 SLOT DATA
  List<AppointmentSlot> _morning() => _gen([
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
  ]);

  List<AppointmentSlot> _afternoon() => _gen([
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "01:30 PM",
  ]);

  List<AppointmentSlot> _evening() => _gen([
    "04:00 PM",
    "04:30 PM",
    "05:00 PM",
    "05:30 PM",
  ]);

  List<AppointmentSlot> _night() => _gen([
    "07:00 PM",
    "07:30 PM",
    "08:00 PM",
    "08:30 PM",
  ]);

  List<AppointmentSlot> _gen(List<String> times) {
    return times
        .map(
          (e) => AppointmentSlot(
            e,
            available: DateTime.now().millisecond % 3 != 0,
          ),
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