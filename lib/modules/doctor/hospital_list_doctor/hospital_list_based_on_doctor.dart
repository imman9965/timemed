import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../add_online_consultant_list/add_online_consultant_schedule_list.dart';
import '../add_online_consultant_list/dummy_data_1.dart';
import '../medical_records/dummy_data_7.dart';
import '../widgets/add_online_schedule_list.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  // Local data — references the shared lists so added hospitals,
  // schedules and online schedules persist across screen visits
  late final List<Hospital> _hospitals;
  late final List<HospitalSchedule> _schedules;
  late final List<OnlineSchedule> _onlineSchedules;

  // Consultation details per online schedule (keyed by schedule id)
  final Map<String, ConsultationScheduleData> _consultationData = {};

  @override
  void initState() {
    super.initState();
    _hospitals = initialHospitals;
    _schedules = initialSchedules;
    _onlineSchedules = initialOnlineSchedules;
  }

  // Day key → display label (order matters)
  static const List<MapEntry<String, String>> _dayLabels = [
    MapEntry('sun', 'Sun'),
    MapEntry('mon', 'Mon'),
    MapEntry('tue', 'Tue'),
    MapEntry('wed', 'Wed'),
    MapEntry('thu', 'Thu'),
    MapEntry('fri', 'Fri'),
    MapEntry('sat', 'Sat'),
  ];

  // ════════════════════════════════════════════════════
  //  HELPERS
  // ════════════════════════════════════════════════════

  void _snack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  ACTIONS
  // ════════════════════════════════════════════════════

  // Adding a hospital also creates its Hospital Schedule entry and an
  // Online Consultation schedule for that particular hospital
  void _onAddNewHospital() {
    showDialog(
      context: context,
      builder: (_) => _HospitalDialog(
        onSave: (h, fee, interval, from, to, consultation) =>
            setState(() {
          _hospitals.add(h);
          _schedules.add(HospitalSchedule(
            id: 'sch_${h.id}',
            hospitalName: h.name,
            fee: '₹$fee',
            intervalMins: interval,
          ));
          _onlineSchedules.add(OnlineSchedule(
            id: 'onl_${h.id}',
            hospitalId: h.id,
            hospitalName: h.name,
            fromTime: from,
            toTime: to,
          ));
          // Consultation details from the form → shown on the online card
          _consultationData['onl_${h.id}'] = consultation;
        }),
      ),
    );
  }

  void _onEditHospital(Hospital h) {
    final schedIdx = _schedules.indexWhere(
        (s) => s.id == 'sch_${h.id}' || s.hospitalName == h.name);
    final existingSched = schedIdx >= 0 ? _schedules[schedIdx] : null;
    final onlineIdx =
        _onlineSchedules.indexWhere((o) => o.hospitalId == h.id);
    final existingOnline =
        onlineIdx >= 0 ? _onlineSchedules[onlineIdx] : null;
    showDialog(
      context: context,
      builder: (_) => _HospitalDialog(
        existing: h,
        existingFee: existingSched?.fee.replaceAll('₹', ''),
        existingInterval: existingSched?.intervalMins,
        existingFrom: existingOnline?.fromTime,
        existingTo: existingOnline?.toTime,
        existingConsultation: existingOnline != null
            ? _consultationData[existingOnline.id]
            : null,
        onSave: (updated, fee, interval, from, to, consultation) {
          setState(() {
            final idx = _hospitals.indexWhere((x) => x.id == h.id);
            if (idx >= 0) _hospitals[idx] = updated;
            if (schedIdx >= 0) {
              _schedules[schedIdx]
                ..hospitalName = updated.name
                ..fee = '₹$fee'
                ..intervalMins = interval;
            } else {
              _schedules.add(HospitalSchedule(
                id: 'sch_${updated.id}',
                hospitalName: updated.name,
                fee: '₹$fee',
                intervalMins: interval,
              ));
            }
            // Update (or recreate) the linked online schedule
            if (existingOnline != null) {
              existingOnline
                ..hospitalName = updated.name
                ..fromTime = from
                ..toTime = to;
              _consultationData[existingOnline.id] = consultation;
            } else {
              _onlineSchedules.add(OnlineSchedule(
                id: 'onl_${updated.id}',
                hospitalId: updated.id,
                hospitalName: updated.name,
                fromTime: from,
                toTime: to,
              ));
              _consultationData['onl_${updated.id}'] = consultation;
            }
          });
        },
      ),
    );
  }

  // Delete hospital + its schedule + its online schedule together
  void _onDeleteHospital(Hospital h) {
    _confirmDelete(
      message: 'This will remove ${h.name}, its hospital schedule '
          'and its online consultation schedule.',
      onConfirm: () => setState(() {
        _hospitals.removeWhere((x) => x.id == h.id);
        _schedules.removeWhere(
            (s) => s.id == 'sch_${h.id}' || s.hospitalName == h.name);
        for (final o
            in _onlineSchedules.where((o) => o.hospitalId == h.id)) {
          _consultationData.remove(o.id);
        }
        _onlineSchedules.removeWhere((o) => o.hospitalId == h.id);
      }),
    );
  }

  void _onEditSchedule(HospitalSchedule s) {
    showDialog(
      context: context,
      builder: (_) => _ScheduleDialog(
        existing: s,
        onSave: (updated) {
          setState(() {
            final idx = _schedules.indexWhere((x) => x.id == s.id);
            if (idx >= 0) _schedules[idx] = updated;
          });
        },
      ),
    );
  }

  void _onDeleteSchedule(HospitalSchedule s) {
    _confirmDelete(
      message:
          'This will remove the hospital schedule for ${s.hospitalName}.',
      onConfirm: () =>
          setState(() => _schedules.removeWhere((x) => x.id == s.id)),
    );
  }

  // Directly pick From/To time for an online schedule (tap on time chip)
  Future<void> _pickOnlineTime(OnlineSchedule os, bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          (isFrom ? os.fromTime : os.toTime) ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: DoctorColors.primaryBrand,
            onPrimary: Colors.white,
            onSurface: DoctorColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;

    // Validate: From must be earlier than To
    final other = isFrom ? os.toTime : os.fromTime;
    if (other != null) {
      final pickedMins = picked.hour * 60 + picked.minute;
      final otherMins = other.hour * 60 + other.minute;
      final valid =
          isFrom ? pickedMins < otherMins : pickedMins > otherMins;
      if (!valid) {
        _snack('From time must be earlier than To time',
            DoctorColors.error);
        return;
      }
    }

    setState(() {
      if (isFrom) {
        os.fromTime = picked;
      } else {
        os.toTime = picked;
      }
    });
  }

  // Opens dialog pre-filled with the given hospital's online schedule
  // (available days + times) and saves the result back into state
  Future<void> _onEditOnlineSchedule(OnlineSchedule os) async {
    final result = await AddOnlineConsultationDialog.show(
      context,
      initialData: os,
    );

    if (result != null && mounted) {
      setState(() {
        final idx = _onlineSchedules.indexWhere((x) => x.id == os.id);
        if (idx >= 0) _onlineSchedules[idx] = result;
      });

      if (result.fromTime != null && result.toTime != null) {
        _snack(
          '${os.hospitalName ?? 'Schedule'} saved: '
          '${result.fromTime!.format(context)} → '
          '${result.toTime!.format(context)}',
          DoctorColors.successDeep,
        );
      }
    }
  }

  Future<void> _updateData(OnlineSchedule os) async {
    final result = await AddOnlineConsultationScheduleDialog.show(context);

    if (result != null && mounted) {
      setState(() => _consultationData[os.id] = result);
      _snack(
        'Updated: ${result.typeLabel} — Text ₹${result.textFee}, '
        'Video ₹${result.videoFee}, Interval ${result.callInterval} mins',
        DoctorColors.successDeep,
      );
    }
  }

  void _onDeleteOnlineSchedule(OnlineSchedule os) {
    _confirmDelete(
      message: 'This will remove the online consultation schedule'
          '${os.hospitalName != null ? ' for ${os.hospitalName}' : ''}.',
      onConfirm: () => setState(() {
        _onlineSchedules.removeWhere((x) => x.id == os.id);
        _consultationData.remove(os.id);
      }),
    );
  }

  // Shared delete confirmation
  void _confirmDelete({
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: DoctorColors.errorSoftBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline,
                  color: DoctorColors.error, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Delete?',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
              fontSize: 14, color: DoctorColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: DoctorColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: DoctorColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
              _snack('Deleted', DoctorColors.error);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundCream,
      body: Column(
        children: [
          CurvedHeader(title: "HOSPITAL LIST - BASED ON DOCTOR"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hospitals ─────────────────────────
                  _sectionHeader(
                    icon: Icons.local_hospital_rounded,
                    title: 'Hospitals',
                    count: _hospitals.length,
                    trailing: _addNewButton(),
                  ),
                  const SizedBox(height: 12),
                  if (_hospitals.isEmpty)
                    _emptyState('No hospitals yet',
                        'Tap "Add New" to add your first hospital')
                  else
                    ..._hospitals.map(_hospitalCard),

                  const SizedBox(height: 24),

                  // ── Hospital Schedules ────────────────
                  _sectionHeader(
                    icon: Icons.event_note_rounded,
                    title: 'Hospital Schedule List',
                    count: _schedules.length,
                  ),
                  const SizedBox(height: 12),
                  if (_schedules.isEmpty)
                    _emptyState('No schedules',
                        'Schedules appear when you add a hospital')
                  else
                    ..._schedules.map(_scheduleCard),

                  const SizedBox(height: 24),

                  // ── Online Consultation ───────────────
                  _sectionHeader(
                    icon: Icons.videocam_rounded,
                    title: 'Online Consultation Schedule List',
                    count: _onlineSchedules.length,
                  ),
                  const SizedBox(height: 12),
                  if (_onlineSchedules.isEmpty)
                    _emptyState('No online schedules',
                        'Online schedules appear when you add a hospital')
                  else
                    ..._onlineSchedules.map(_onlineScheduleCard),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header — accent bar + title + count chip ──
  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required int count,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: DoctorColors.primaryVivid,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: DoctorColors.textPrimary,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: DoctorColors.primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: DoctorColors.primaryBrand,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _addNewButton() {
    return GestureDetector(
      onTap: _onAddNewHospital,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: DoctorColors.primaryVivid,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: DoctorColors.primaryVivid.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text('Add New',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ── Hospital card ─────────────────────────────────────
  Widget _hospitalCard(Hospital h) {
    final isOwn = h.type == 'Own';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Gradient avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: DoctorColors.primaryVivid,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_hospital_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(h.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                        color: DoctorColors.textPrimary)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.phone_rounded,
                      size: 12, color: DoctorColors.primaryBrand),
                  const SizedBox(width: 4),
                  Text(h.phone,
                      style: const TextStyle(
                          fontSize: 12.5,
                          color: DoctorColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: DoctorColors.badgeIndigo,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      h.type,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: DoctorColors.textDark,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          _iconAction(Icons.edit_rounded, DoctorColors.primaryBrand,
              DoctorColors.primarySoft, () => _onEditHospital(h)),
          const SizedBox(width: 6),
          _iconAction(Icons.delete_rounded, DoctorColors.error,
              DoctorColors.errorSoftBg, () => _onDeleteHospital(h)),
        ],
      ),
    );
  }

  // ── Hospital schedule card ────────────────────────────
  Widget _scheduleCard(HospitalSchedule s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: DoctorColors.primaryVivid,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.event_available_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.hospitalName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                        color: DoctorColors.textPrimary)),
                const SizedBox(height: 6),
                Row(children: [
                  _miniChip(Icons.currency_rupee_rounded,
                      'Fee: ${s.fee.replaceAll('₹', '')}',
                      DoctorColors.badgeGreen,
                      DoctorColors.badgeGreenText),
                  const SizedBox(width: 6),
                  _miniChip(Icons.timer_outlined,
                      'Interval: ${s.intervalMins} mins',
                      DoctorColors.badgeBlue,
                      DoctorColors.badgeBlueText),
                ]),
              ],
            ),
          ),
          _iconAction(Icons.edit_rounded, DoctorColors.primaryBrand,
              DoctorColors.primarySoft, () => _onEditSchedule(s)),
          const SizedBox(width: 6),
          _iconAction(Icons.delete_rounded, DoctorColors.error,
              DoctorColors.errorSoftBg, () => _onDeleteSchedule(s)),
        ],
      ),
    );
  }

  // ── Online consultation card ──────────────────────────
  Widget _onlineScheduleCard(OnlineSchedule os) {
    final details = _consultationData[os.id];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: _cardDecoration(radius: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header strip — hospital name + actions
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration:
                  const BoxDecoration(color: DoctorColors.primaryVivid),
              child: Row(
                children: [
                  const Icon(Icons.videocam_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      os.hospitalName ?? 'Online Consultation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Edit available days + times (full schedule dialog)
                  _headerIcon(Icons.edit_calendar_rounded,
                      () => _onEditOnlineSchedule(os)),
                  const SizedBox(width: 6),
                  _headerIcon(Icons.delete_rounded,
                      () => _onDeleteOnlineSchedule(os)),
                ],
              ),
            ),

            // Available days — set from the schedule dialog, tap to edit
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: GestureDetector(
                onTap: () => _onEditOnlineSchedule(os),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.calendar_today_rounded,
                          size: 14, color: DoctorColors.primaryBrand),
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text('Days:',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: DoctorColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: os.selectedDays.contains('all')
                            ? [_dayPill('All Days')]
                            : _dayLabels
                                .where((d) =>
                                    os.selectedDays.contains(d.key))
                                .map((d) => _dayPill(d.value))
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // From → To time chips
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Row(
                children: [
                  // Tap opens the time picker directly
                  Expanded(
                      child: _timeChip('From', os.fromTime,
                          () => _pickOnlineTime(os, true))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 18, color: DoctorColors.primaryBrand),
                  ),
                  Expanded(
                      child: _timeChip('To', os.toTime,
                          () => _pickOnlineTime(os, false))),
                ],
              ),
            ),

            // Consultation details (all info from the Edit dialog)
            if (details != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: DoctorColors.backgroundFrost,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: DoctorColors.dividerSoft),
                  ),
                  child: Column(
                    children:
                        summaryItems.asMap().entries.map((entry) {
                      final isLast =
                          entry.key == summaryItems.length - 1;
                      final item = entry.value;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7),
                            child: Row(
                              children: [
                                Icon(item.icon,
                                    size: 15,
                                    color: DoctorColors.primaryBrand),
                                const SizedBox(width: 8),
                                Text(
                                  item.label,
                                  style: const TextStyle(
                                    color: DoctorColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.5,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.valueGetter(details),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: DoctorColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            const Divider(
                                height: 1,
                                color: DoctorColors.dividerSoft),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            // Always available — set or edit the consultation details
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            //   child: GestureDetector(
            //     onTap: () => _updateData(os),
            //     child: Container(
            //       width: double.infinity,
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //       decoration: BoxDecoration(
            //         color: DoctorColors.primarySoft,
            //         borderRadius: BorderRadius.circular(12),
            //         border: Border.all(
            //             color: DoctorColors.dividerSoft, width: 1.2),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Icon(Icons.tune_rounded,
            //               size: 16, color: DoctorColors.primaryBrand),
            //           const SizedBox(width: 6),
            //           Text(
            //             details == null
            //                 ? 'Set Consultation Details'
            //                 : 'Edit Consultation Details',
            //             style: const TextStyle(
            //               fontSize: 12.5,
            //               fontWeight: FontWeight.w800,
            //               color: DoctorColors.primaryBrand,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  // ── Small building blocks ─────────────────────────────

  BoxDecoration _cardDecoration({double radius = 16}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: DoctorColors.dividerCool),
      boxShadow: [
        BoxShadow(
          color: DoctorColors.primaryBrand.withOpacity(0.06),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _iconAction(
      IconData icon, Color color, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 15, color: Colors.white),
      ),
    );
  }

  Widget _dayPill(String label) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: DoctorColors.primaryVivid,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _miniChip(
      IconData icon, String label, Color bg, Color fg) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: fg)),
        ],
      ),
    );
  }

  Widget _timeChip(String label, TimeOfDay? time, VoidCallback onTap) {
    final hasTime = time != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: hasTime
              ? DoctorColors.backgroundFrost
              : DoctorColors.inputBgSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasTime
                ? DoctorColors.primaryAccent
                : DoctorColors.dividerNeutral,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 15,
                color: hasTime
                    ? DoctorColors.primaryBrand
                    : DoctorColors.textMuted),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: DoctorColors.textSecondary)),
                Text(
                  hasTime ? time.format(context) : 'Set time',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: hasTime
                        ? DoctorColors.textPrimary
                        : DoctorColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DoctorColors.dividerCool),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_rounded,
              size: 34, color: DoctorColors.avatarGrey),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: DoctorColors.textPrimary)),
          const SizedBox(height: 3),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12,
                  color: DoctorColors.textSecondary)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  ADD / EDIT HOSPITAL DIALOG
//  Collects hospital info + schedule fee/interval + online
//  consultation From/To times — everything in one form
// ════════════════════════════════════════════════════════

class _HospitalDialog extends StatefulWidget {
  final Hospital? existing;
  final String? existingFee;
  final int? existingInterval;
  final TimeOfDay? existingFrom;
  final TimeOfDay? existingTo;
  final ConsultationScheduleData? existingConsultation;

  /// Returns the hospital plus its schedule info (fee + interval),
  /// online consultation times AND consultation details (type + text/video
  /// charges) so the caller can create/update everything at the same time
  final void Function(
      Hospital,
      String fee,
      int intervalMins,
      TimeOfDay? from,
      TimeOfDay? to,
      ConsultationScheduleData consultation) onSave;

  const _HospitalDialog({
    this.existing,
    this.existingFee,
    this.existingInterval,
    this.existingFrom,
    this.existingTo,
    this.existingConsultation,
    required this.onSave,
  });

  @override
  State<_HospitalDialog> createState() => _HospitalDialogState();
}

class _HospitalDialogState extends State<_HospitalDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _feeCtrl;
  late final TextEditingController _intervalCtrl;
  late final TextEditingController _textFeeCtrl;
  late final TextEditingController _videoFeeCtrl;
  String _type = 'Own';
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  ConsultationType _consultType = ConsultationType.both;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _phoneCtrl =
        TextEditingController(text: widget.existing?.phone ?? '');
    _feeCtrl = TextEditingController(text: widget.existingFee ?? '');
    _intervalCtrl = TextEditingController(
        text: widget.existingInterval?.toString() ?? '');
    _textFeeCtrl = TextEditingController(
        text: widget.existingConsultation?.textFee.toString() ?? '');
    _videoFeeCtrl = TextEditingController(
        text: widget.existingConsultation?.videoFee.toString() ?? '');
    _type = widget.existing?.type ?? 'Own';
    _fromTime = widget.existingFrom;
    _toTime = widget.existingTo;
    _consultType =
        widget.existingConsultation?.type ?? ConsultationType.both;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _feeCtrl.dispose();
    _intervalCtrl.dispose();
    _textFeeCtrl.dispose();
    _videoFeeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isFrom ? _fromTime : _toTime) ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: DoctorColors.primaryBrand,
            onPrimary: Colors.white,
            onSurface: DoctorColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
    }
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _feeCtrl.text.trim().isEmpty ||
        _intervalCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1)),
      );
      return;
    }
    final h = Hospital(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      type: _type,
    );
    widget.onSave(
      h,
      _feeCtrl.text.trim(),
      int.tryParse(_intervalCtrl.text.trim()) ?? 0,
      _fromTime,
      _toTime,
      ConsultationScheduleData(
        type: _consultType,
        // Only the charges relevant to the selected type are saved
        textFee: _consultType == ConsultationType.videoOnly
            ? 0
            : int.tryParse(_textFeeCtrl.text.trim()) ?? 0,
        videoFee: _consultType == ConsultationType.textOnly
            ? 0
            : int.tryParse(_videoFeeCtrl.text.trim()) ?? 0,
        callInterval: int.tryParse(_intervalCtrl.text.trim()) ?? 0,
      ),
    );
    Navigator.pop(context);
  }

  // Radio row for consultation type (Text / Video / Both)
  Widget _consultTypeRow(ConsultationOption opt) {
    final selected = _consultType == opt.type;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _consultType = opt.type),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? DoctorColors.success
                    : DoctorColors.avatarGrey,
                width: 1.5,
              ),
              color:
                  selected ? DoctorColors.success : Colors.transparent,
            ),
            child: selected
                ? const Center(
                    child: Icon(Icons.circle,
                        color: Colors.white, size: 6))
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              opt.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DoctorColors.textDark,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
          color: DoctorColors.textSecondary, fontSize: 13.5),
      prefixIcon:
          Icon(icon, size: 18, color: DoctorColors.primaryBrand),
      filled: true,
      fillColor: DoctorColors.backgroundFrost,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: DoctorColors.dividerSoft),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: DoctorColors.primaryBrand, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: DoctorColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _formTimeBox(String label, TimeOfDay? time, bool isFrom) {
    final hasTime = time != null;
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickTime(isFrom),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: DoctorColors.backgroundFrost,
            border: Border.all(
              color: hasTime
                  ? DoctorColors.primaryAccent
                  : DoctorColors.dividerSoft,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 16,
                  color: hasTime
                      ? DoctorColors.primaryBrand
                      : DoctorColors.textMuted),
              const SizedBox(width: 8),
              Text(
                hasTime ? time.format(context) : label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      hasTime ? FontWeight.w700 : FontWeight.w500,
                  color: hasTime
                      ? DoctorColors.textPrimary
                      : DoctorColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String value) {
    final selected = _type == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? DoctorColors.primary
                : DoctorColors.backgroundFrost,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : DoctorColors.dividerSoft,
            ),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color:
                  selected ? Colors.white : DoctorColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Gradient header ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration:
                    const BoxDecoration(color: DoctorColors.blue700),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                          isEdit
                              ? Icons.edit_rounded
                              : Icons.add_business_rounded,
                          color: Colors.white,
                          size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Hospital' : 'Add New Hospital',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              // ── Body ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _sectionLabel('HOSPITAL DETAILS'),
                    TextField(
                      controller: _nameCtrl,
                      decoration: _fieldDecoration('Hospital name',
                          Icons.local_hospital_rounded),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: _fieldDecoration(
                          'Phone', Icons.phone_rounded),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      _typeChip('Own'),
                      const SizedBox(width: 10),
                      _typeChip('Partner'),
                    ]),

                    const SizedBox(height: 18),
                    _sectionLabel('HOSPITAL SCHEDULE'),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _feeCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: _fieldDecoration('Fee (₹)',
                                Icons.currency_rupee_rounded),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _intervalCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            decoration: _fieldDecoration(
                                'Interval', Icons.timer_outlined),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    _sectionLabel('ONLINE CONSULTATION'),
                    Row(
                      children: [
                        _formTimeBox('From Time', _fromTime, true),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 16,
                              color: DoctorColors.primaryBrand),
                        ),
                        _formTimeBox('To Time', _toTime, false),
                      ],
                    ),

                    const SizedBox(height: 18),
                    _sectionLabel('CONSULTATION'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: DoctorColors.backgroundFrost,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: DoctorColors.dividerSoft),
                      ),
                      child: Column(
                        children: consultationOptions
                            .map(_consultTypeRow)
                            .toList(),
                      ),
                    ),
                    // Charge fields follow the selected consultation type:
                    // Text only → text charge, Video only → video charge,
                    // Both → both fields. Digits only.
                    if (_consultType == ConsultationType.textOnly ||
                        _consultType == ConsultationType.both) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _textFeeCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: _fieldDecoration(
                            'Text Consultation Charge (₹)',
                            Icons.chat_bubble_outline_rounded),
                      ),
                    ],
                    if (_consultType == ConsultationType.videoOnly ||
                        _consultType == ConsultationType.both) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _videoFeeCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: _fieldDecoration(
                            'Video Consultation Charge (₹)',
                            Icons.videocam_outlined),
                      ),
                    ],

                    const SizedBox(height: 22),

                    // ── Actions ─────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                              side: const BorderSide(
                                  color: DoctorColors.dividerCool),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel',
                                style: TextStyle(
                                    color:
                                        DoctorColors.textSecondary,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: _save,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                              decoration: BoxDecoration(
                                color: DoctorColors.blue700,
                                borderRadius:
                                    BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: DoctorColors.blue700
                                        .withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                isEdit
                                    ? 'Update Hospital'
                                    : 'Add Hospital',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  EDIT SCHEDULE DIALOG
// ════════════════════════════════════════════════════════

class _ScheduleDialog extends StatefulWidget {
  final HospitalSchedule existing;
  final void Function(HospitalSchedule) onSave;

  const _ScheduleDialog({
    required this.existing,
    required this.onSave,
  });

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _feeCtrl;
  late final TextEditingController _intervalCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.existing.hospitalName);
    _feeCtrl = TextEditingController(
        text: widget.existing.fee.replaceAll('₹', ''));
    _intervalCtrl = TextEditingController(
        text: widget.existing.intervalMins.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _feeCtrl.dispose();
    _intervalCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(HospitalSchedule(
      id: widget.existing.id,
      hospitalName: _nameCtrl.text.trim(),
      fee: '₹${_feeCtrl.text.trim()}',
      intervalMins: int.tryParse(_intervalCtrl.text) ??
          widget.existing.intervalMins,
    ));
    Navigator.pop(context);
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
          color: DoctorColors.textSecondary, fontSize: 13.5),
      prefixIcon:
          Icon(icon, size: 18, color: DoctorColors.primaryBrand),
      filled: true,
      fillColor: DoctorColors.backgroundFrost,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: DoctorColors.dividerSoft),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: DoctorColors.primaryBrand, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // Gradient header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration:
                  const BoxDecoration(color: DoctorColors.primaryVivid),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.event_note_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Edit Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  TextField(
                    controller: _nameCtrl,
                    decoration: _fieldDecoration('Hospital name',
                        Icons.local_hospital_rounded),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _feeCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: _fieldDecoration(
                              'Fee (₹)', Icons.currency_rupee_rounded),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _intervalCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: _fieldDecoration(
                              'Interval', Icons.timer_outlined),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13),
                            side: const BorderSide(
                                color: DoctorColors.dividerCool),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
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
                          onTap: _save,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13),
                            decoration: BoxDecoration(
                              color: DoctorColors.primaryVivid,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Update',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
