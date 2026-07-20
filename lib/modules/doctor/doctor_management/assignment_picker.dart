import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';

/// A single selectable row in the assignment picker.
class PickerItem {
  final String id;
  final String title;
  final String? subtitle;
  const PickerItem({required this.id, required this.title, this.subtitle});
}

/// Generic multi-select dialog used for both:
///  • assigning hospitals to a doctor, and
///  • assigning doctors to a hospital.
///
/// Returns the new set of selected ids, or null if cancelled.
Future<Set<String>?> showAssignmentPicker({
  required BuildContext context,
  required String heading,
  required IconData icon,
  required List<PickerItem> items,
  required Set<String> selected,
  Color accent = DoctorColors.primaryVivid,
  String emptyMessage = 'Nothing to assign yet.',
}) {
  final working = <String>{...selected};

  return showDialog<Set<String>>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: accent),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            heading,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Flexible(
                    child: items.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              emptyMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: DoctorColors.textSecondary),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const Divider(
                                height: 1, color: DoctorColors.dividerSoft),
                            itemBuilder: (_, i) {
                              final it = items[i];
                              final checked = working.contains(it.id);
                              return InkWell(
                                onTap: () => setLocal(() {
                                  if (checked) {
                                    working.remove(it.id);
                                  } else {
                                    working.add(it.id);
                                  }
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: checked
                                              ? accent
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: checked
                                                ? accent
                                                : DoctorColors.dividerNeutral,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: checked
                                            ? const Icon(Icons.check,
                                                color: Colors.white, size: 15)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              it.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    DoctorColors.textPrimary,
                                              ),
                                            ),
                                            if (it.subtitle != null &&
                                                it.subtitle!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  it.subtitle!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 11.5,
                                                    color: DoctorColors
                                                        .textSecondary,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const Divider(height: 1, color: DoctorColors.dividerSoft),

                  // Actions
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(
                                  color: DoctorColors.dividerCool),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel',
                                style: TextStyle(
                                    color: DoctorColors.textSecondary,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(ctx, working),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
