import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class VideoSchedulePage extends StatefulWidget {
  const VideoSchedulePage({super.key});

  @override
  State<VideoSchedulePage> createState() => _VideoSchedulePageState();
}

class _VideoSchedulePageState extends State<VideoSchedulePage> {
  DateTime selectedDate = DateTime(2026, 2, 16);
  int selectedDay = 1; // Mon

  final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  void changeDate(int diff) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: diff));
      selectedDay = selectedDate.weekday % 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: AppBar(title: const Text("Schedule Appointment")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    /// 🔹 DOCTOR INFO
                    Row(
                      children: [
                        Icon(
                          Icons.person_2_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Mr. Mariappan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text("MBBS"),
                            ],
                          ),
                        ),
                        Column(
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text("1/7/2026"),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_clock,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text("10:00 AM"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Dr. Mariappan is a board-certified Child Specialist with over 3 years of experience in providing comprehensive healthcare to patients of all ages.",
                      style: TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: const [
                        Icon(Icons.person, size: 16, color: AppColors.button),
                        SizedBox(width: 4),
                        Text("Male"),
                        SizedBox(width: 12),
                        Icon(Icons.star, size: 16, color: AppColors.button),
                        SizedBox(width: 4),
                        Text("+3 Years"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "₹550",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.push(AppRoutes.videoPayment);
                          },
                          child: const Text("Book Appointment"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(top: 16),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    /// 🔹 DATE SWITCH
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => changeDate(-1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          "${_month(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => changeDate(1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),

                    /// 🔹 DAYS (UNDERLINE STYLE)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(days.length, (index) {
                        bool isSelected = selectedDay == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedDay = index);
                          },
                          child: Column(
                            children: [
                              Text(
                                days[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (isSelected)
                                Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    /// 🔥 TIME GRID (ROW STYLE)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _timeColumn("Morning", Icons.wb_sunny, _morning()),
                        _timeColumn("Afternoon", Icons.sunny, _afternoon()),
                        _timeColumn("Evening", Icons.wb_twilight, _evening()),
                        _timeColumn("Night", Icons.nightlight, _night()),
                      ],
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

  /// 🔥 COLUMN UI
  Widget _timeColumn(String title, IconData icon, List<Map> slots) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 8),

            ...slots.map((slot) {
              bool available = slot["available"];

              return GestureDetector(
                onTap: available ? () => context.push('/video-payment') : null,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: available
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text(
                      slot["time"],
                      style: TextStyle(
                        fontSize: 11,
                        color: available ? Colors.green : Colors.grey,
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

  /// 🔥 SLOT DATA
  List<Map> _morning() =>
      _gen(["09:00 AM", "09:15 AM", "09:30 AM", "09:45 AM", "10:00 AM"]);

  List<Map> _afternoon() =>
      _gen(["12:00 PM", "12:15 PM", "12:30 PM", "12:45 PM"]);

  List<Map> _evening() =>
      _gen(["04:15 PM", "04:30 PM", "04:45 PM", "05:00 PM"]);

  List<Map> _night() => _gen(["08:30 PM", "08:45 PM", "09:00 PM", "09:15 PM"]);

  List<Map> _gen(List<String> times) {
    return times
        .map(
          (t) => {"time": t, "available": DateTime.now().millisecond % 2 == 0},
        )
        .toList();
  }

  String _month(int m) {
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
    return months[m];
  }
}
