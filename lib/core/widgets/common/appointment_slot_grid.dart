import 'package:flutter/material.dart';

/// ════════════════════════════════════════════════════════
///  REUSABLE — APPOINTMENT SLOT GRID
///  Shared slot-selection design used across every patient
///  "Select Slot" screen. Mirrors the doctor schedule design:
///  column cards with a soft-blue header + session icon,
///  strikethrough for taken slots and a blue-filled selected slot.
/// ════════════════════════════════════════════════════════

class SlotGridColors {
  static const blue       = Color(0xFF1A6BF5);
  static const blueSoft   = Color(0xFFE8F1FC);
  static const strikeGray = Color(0xFFB0B0B0);
  static const cardBorder = Color(0xFFE5EAF2);
}

/// A single time slot.
class AppointmentSlot {
  final String time;
  final bool   available;

  const AppointmentSlot(this.time, {this.available = true});
}

/// A session column (Morning / Afternoon / Evening / Night).
class AppointmentSlotColumn {
  final String title;
  final String icon; // asset path, e.g. "assets/icons/Morning.png"
  final List<AppointmentSlot> slots;

  const AppointmentSlotColumn({
    required this.title,
    required this.icon,
    required this.slots,
  });
}

/// Default 4-column session layout with the standard session icons.
List<AppointmentSlotColumn> buildDefaultSlotColumns({
  required List<AppointmentSlot> morning,
  required List<AppointmentSlot> afternoon,
  required List<AppointmentSlot> evening,
  required List<AppointmentSlot> night,
}) {
  return [
    AppointmentSlotColumn(
      title: 'Morning',
      icon: 'assets/icons/Morning.png',
      slots: morning,
    ),
    AppointmentSlotColumn(
      title: 'Afternoon',
      icon: 'assets/icons/afternoon.png',
      slots: afternoon,
    ),
    AppointmentSlotColumn(
      title: 'Evening',
      icon: 'assets/icons/sun_fog.png',
      slots: evening,
    ),
    AppointmentSlotColumn(
      title: 'Night',
      icon: 'assets/icons/night_cloud.png',
      slots: night,
    ),
  ];
}

/// The full 4-column slot grid.
class AppointmentSlotGrid extends StatelessWidget {
  final List<AppointmentSlotColumn> columns;
  final String? selectedTime;
  final ValueChanged<String> onSlotTap;

  const AppointmentSlotGrid({
    super.key,
    required this.columns,
    required this.selectedTime,
    required this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns
          .map((c) => Expanded(child: _SlotColumn(
                column: c,
                selectedTime: selectedTime,
                onSlotTap: onSlotTap,
              )))
          .toList(),
    );
  }
}

class _SlotColumn extends StatelessWidget {
  final AppointmentSlotColumn column;
  final String? selectedTime;
  final ValueChanged<String> onSlotTap;

  const _SlotColumn({
    required this.column,
    required this.selectedTime,
    required this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: SlotGridColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header — soft blue with session icon + label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: SlotGridColors.blueSoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  column.icon,
                  width: 32,
                  height: 32,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.access_time_rounded,
                    color: SlotGridColors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  column.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: SlotGridColors.blue,
                  ),
                ),
              ],
            ),
          ),
          // Slots
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: column.slots
                  .map((slot) => _SlotTile(
                        slot: slot,
                        isSelected:
                            selectedTime == slot.time && slot.available,
                        onTap: slot.available
                            ? () => onSlotTap(slot.time)
                            : null,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final AppointmentSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SlotTile({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!slot.available) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          slot.time,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SlotGridColors.strikeGray,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SlotGridColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: SlotGridColors.blue.withOpacity(0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            slot.time,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : SlotGridColors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
