import 'package:flutter/material.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';

/// End-call / Update Call Status screen.
///
/// Layout:
///   • Blue gradient curved header with "UPDATE CALL STATUS" title.
///   • Pill-shaped tab bar (FREE REVIEW / PAID RE-VISIT / COMPLETE CONSULTATION)
///     overlapping the header bottom.
///   • Each tab shows a date selector, day-of-week picker, and a 4-column
///     slot grid (Morning / Afternoon / Evening / Night).
class UpdateCallStatusScreen extends StatefulWidget {
  const UpdateCallStatusScreen({Key? key}) : super(key: key);


  @override
  State<UpdateCallStatusScreen> createState() => _UpdateCallStatusScreenState();
}

class _UpdateCallStatusScreenState extends State<UpdateCallStatusScreen>
    with SingleTickerProviderStateMixin {
  // ── Blue & white palette ──────────────────────────────────────────────
  static const Color _blue = Color(0xFF1A6BF5);
  static const Color _blueSoft = Color(0xFFE8F1FC);
  static const Color _inactiveText = Color(0xFF6B7280);
  static const Color _strikeGray = Color(0xFFB0B0B0);
  static const Color _cardBorder = Color(0xFFE5EAF2);
  static const Color _scaffoldBg = Colors.white;

  static const List<String> _tabs = <String>[
    'FREE REVIEW',
    'PAID RE-VISIT',
    'COMPLETE CONSULTATION',
  ];

  static const List<String> _days = <String>[
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ];

  static const List<String> _months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  late final TabController _tabController;
  late DateTime _currentDate;
  int _selectedDay = 1; // Mon
  String _selectedSlot = '04:15 PM';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 2,
    );
    // Initialize with Feb 16, 2026 (Monday)
    _currentDate = DateTime(2026, 2, 16);
    _updateSelectedDayFromDate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Date navigation helpers ──────────────────────────────────────────
  void _goPreviousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
      _updateSelectedDayFromDate();
    });
  }

  void _goNextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _updateSelectedDayFromDate();
    });
  }

  void _updateSelectedDayFromDate() {
    // DateTime.weekday: Monday = 1 ... Sunday = 7
    final int weekday = _currentDate.weekday;
    // Map to _days index: Sun(7) -> 0, Mon(1) -> 1, Tue(2) -> 2, ... Sat(6) -> 6
    _selectedDay = weekday == 7 ? 0 : weekday;
  }

  String _getFormattedDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _selectDayByIndex(int dayIndex) {
    // Map dayIndex (0=Sun .. 6=Sat) to DateTime weekday (1=Mon .. 7=Sun)
    int targetWeekday;
    if (dayIndex == 0) {
      targetWeekday = 7; // Sunday
    } else {
      targetWeekday = dayIndex; // Mon=1, Tue=2, ..., Sat=6
    }

    final int currentWeekday = _currentDate.weekday;
    int delta = targetWeekday - currentWeekday;

    setState(() {
      _currentDate = _currentDate.add(Duration(days: delta));
      _updateSelectedDayFromDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _buildTabPill(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((_) => _buildSlotTab()).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header (curved blue gradient + overlapping tab pill) ─────────────
  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CurvedHeader(
          title: "UPDATE CALL STATUS",
          titleStyle: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabPill() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          return Row(
            children: List.generate(_tabs.length, (i) {
              final bool active = _tabController.index == i;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => _tabController.animateTo(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _tabs[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: active ? _blue : _inactiveText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 3,
                        width: active ? 100 : 0,
                        decoration: BoxDecoration(
                          color: _blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // ─── Tab body: date + day picker + 4-column slot grid ─────────────────
  Widget _buildSlotTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 2),
          _buildDateRow(),
          const SizedBox(height: 12),
          _buildDayPicker(),
          const SizedBox(height: 16),
          _buildSlotGrid(),
          const SizedBox(height: 24),
          _buildCompleteButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        _arrowBtn(Icons.chevron_left, onTap: _goPreviousDay),
        Expanded(
          child: Center(
            child: Text(
              _getFormattedDate(_currentDate),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
        _arrowBtn(Icons.chevron_right, onTap: _goNextDay),
      ],
    );
  }

  Widget _arrowBtn(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: _blue, size: 26),
      ),
    );
  }

  Widget _buildDayPicker() {
    return Row(
      children: List.generate(_days.length, (i) {
        final bool selected = i == _selectedDay;
        return Expanded(
          child: InkWell(
            onTap: () => _selectDayByIndex(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected ? _blue : _inactiveText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: selected ? 28 : 0,
                    decoration: BoxDecoration(
                      color: _blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── 4-column slot grid ───────────────────────────────────────────────
  Widget _buildSlotGrid() {
    final columns = <_SlotColumn>[
      _SlotColumn(
        title: 'Morning',
        icon: "assets/icons/Morning.png",
        slots: const [
          _Slot('09:00 AM', taken: true),
          _Slot('09:15 AM', taken: true),
          _Slot('09:30 AM', taken: true),
          _Slot('09:45 AM', taken: true),
          _Slot('10:00 AM', taken: true),
          _Slot('10:15 AM', taken: true),
          _Slot('10:30 AM', taken: true),
        ],
      ),
      _SlotColumn(
        title: 'Afternoon',
        icon: "assets/icons/afternoon.png",
        slots: const [
          _Slot('12:00 PM', taken: true),
          _Slot('12:15 PM', taken: true),
          _Slot('12:30 PM', taken: true),
          _Slot('12:45 PM', taken: true),
          _Slot('01:00 PM', taken: true),
          _Slot('01:15 PM', taken: true),
          _Slot('01:30 PM', taken: true),
        ],
      ),
      _SlotColumn(
        title: 'Evening',
        icon: "assets/icons/sun_fog.png",
        slots: const [
          _Slot('04:00 PM', taken: true),
          _Slot('04:15 PM'),
          _Slot('04:30 PM'),
          _Slot('04:45 PM'),
          _Slot('05:00 PM', taken: true),
          _Slot('05:15 PM'),
          _Slot('05:30 PM'),
        ],
      ),
      _SlotColumn(
        title: 'Night',
        icon: "assets/icons/night_cloud.png",
        slots: const [
          _Slot('08:00 PM', taken: true),
          _Slot('08:15 PM', taken: true),
          _Slot('08:30 PM'),
          _Slot('08:45 PM'),
          _Slot('09:00 PM', taken: true),
          _Slot('09:15 PM'),
          _Slot('09:30 PM'),
        ],
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns
          .map((c) => Expanded(child: _buildSlotColumn(c)))
          .toList(),
    );
  }

  Widget _buildSlotColumn(_SlotColumn col) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: _blueSoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  col.icon,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  col.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _blue,
                  ),
                ),
              ],
            ),
          ),
          // Slots
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: col.slots.map(_buildSlot).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(_Slot slot) {
    final bool isSelected = _selectedSlot == slot.time && !slot.taken;

    if (slot.taken) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          slot.time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _strikeGray,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      );
    }
    return InkWell(
      onTap: () => setState(() => _selectedSlot = slot.time),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            slot.time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : _blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Click to Complete',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─── Data models ─────────────────────────────────────────────────────────
class _SlotColumn {
  final String title;
  final String icon;
  final List<_Slot> slots;
  const _SlotColumn({
    required this.title,
    required this.icon,
    required this.slots,
  });
}

class _Slot {
  final String time;
  final bool taken;
  const _Slot(this.time, {this.taken = false});
}
