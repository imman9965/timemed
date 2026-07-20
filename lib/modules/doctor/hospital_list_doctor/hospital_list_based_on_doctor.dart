import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../add_online_consultant_list/add_online_consultant_schedule_list.dart';
import '../add_online_consultant_list/dummy_data_1.dart';
import '../medical_records/dummy_data_7.dart';
import '../widgets/add_online_schedule_list.dart';
import '../doctor_management/doctor_registry.dart';
import '../doctor_management/assignment_picker.dart';

// Screen theme: blue primary, green secondary
const Color kPrimaryBlue = DoctorColors.primaryVivid;
const Color kSecondaryGreen = DoctorColors.successTeal;

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

  // Consultation details per online schedule (keyed by schedule id).
  // References the shared store so details persist across screen visits.
  late final Map<String, ConsultationScheduleData> _consultationData;

  // Hospitals whose grouped card is currently expanded.
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _hospitals = initialHospitals;
    _schedules = initialSchedules;
    _onlineSchedules = initialOnlineSchedules;
    _consultationData = initialConsultationData;
    // Load doctor <-> hospital assignments so the "Assign Doctors" action and
    // the assigned-doctor chips are populated.
    DoctorRegistry.instance.load().then((_) {
      if (mounted) setState(() {});
    });
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
  void _onAddNewHospital({String category = 'Clinic'}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _HospitalDialog(
        initialCategory: category,
        onSave: (h, fee, interval, visitDays, visitFrom, visitTo, from,
                to, consultation) =>
            setState(() {
          _hospitals.add(h);
          _schedules.add(HospitalSchedule(
            id: 'sch_${h.id}',
            hospitalName: h.name,
            fee: '₹$fee',
            intervalMins: interval,
            visitDays: visitDays,
            fromTime: visitFrom,
            toTime: visitTo,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _HospitalDialog(
        existing: h,
        existingFee: existingSched?.fee.replaceAll('₹', ''),
        existingInterval: existingSched?.intervalMins,
        existingVisitDays: existingSched?.visitDays,
        existingVisitFrom: existingSched?.fromTime,
        existingVisitTo: existingSched?.toTime,
        existingFrom: existingOnline?.fromTime,
        existingTo: existingOnline?.toTime,
        existingConsultation: existingOnline != null
            ? _consultationData[existingOnline.id]
            : null,
        onSave: (updated, fee, interval, visitDays, visitFrom, visitTo,
            from, to, consultation) {
          setState(() {
            final idx = _hospitals.indexWhere((x) => x.id == h.id);
            if (idx >= 0) _hospitals[idx] = updated;
            if (schedIdx >= 0) {
              _schedules[schedIdx]
                ..hospitalName = updated.name
                ..fee = '₹$fee'
                ..intervalMins = interval
                ..visitDays = visitDays
                ..fromTime = visitFrom
                ..toTime = visitTo;
            } else {
              _schedules.add(HospitalSchedule(
                id: 'sch_${updated.id}',
                hospitalName: updated.name,
                fee: '₹$fee',
                intervalMins: interval,
                visitDays: visitDays,
                fromTime: visitFrom,
                toTime: visitTo,
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
        // Drop this hospital from every doctor's assignment list.
        DoctorRegistry.instance.removeHospital(h.id);
      }),
    );
  }

  // Assign doctors to this hospital (many-to-many, from the hospital side).
  Future<void> _assignDoctors(Hospital h) async {
    final registry = DoctorRegistry.instance;
    if (registry.doctors.isEmpty) {
      _snack('Add doctors first from the Doctors screen',
          DoctorColors.warningOrange);
      return;
    }
    final selected =
        registry.doctorsForHospital(h.id).map((d) => d.id).toSet();
    final result = await showAssignmentPicker(
      context: context,
      heading: 'Assign Doctors — ${h.name}',
      icon: Icons.groups_rounded,
      accent: kPrimaryBlue,
      items: registry.doctors
          .map((d) => PickerItem(
                id: d.id,
                title: d.displayName + (d.isMain ? '  (Main)' : ''),
                subtitle: d.subtitle,
              ))
          .toList(),
      selected: selected,
      emptyMessage: 'No doctors yet. Add them from the Doctors screen.',
    );
    if (result != null && mounted) {
      registry.setDoctorsForHospital(h.id, result);
      setState(() {});
      _snack('Doctors updated for ${h.name}', DoctorColors.successDeep);
    }
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
    final clinics = _hospitals.where((h) => h.isClinic).toList();
    final hospitals = _hospitals.where((h) => !h.isClinic).toList();
    return Scaffold(
      backgroundColor: DoctorColors.backgroundCream,
      body: Column(
        children: [
          CurvedHeader(title: "MY FACILITIES"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Clinics ──
                  _sectionHeader(
                    icon: Icons.storefront_rounded,
                    title: 'Clinics',
                    count: clinics.length,
                    trailing: _addNewButton('Clinic'),
                  ),
                  const SizedBox(height: 12),
                  if (clinics.isEmpty)
                    _emptyState('No clinics yet',
                        'Tap "Add New" to add a clinic')
                  else
                    ...clinics.map(_hospitalGroupCard),

                  const SizedBox(height: 24),

                  // ── Hospitals ──
                  _sectionHeader(
                    icon: Icons.local_hospital_rounded,
                    title: 'Hospitals',
                    count: hospitals.length,
                    trailing: _addNewButton('Hospital'),
                  ),
                  const SizedBox(height: 12),
                  if (hospitals.isEmpty)
                    _emptyState('No hospitals yet',
                        'Tap "Add New" to add a hospital')
                  else
                    ...hospitals.map(_hospitalGroupCard),
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
            color: kPrimaryBlue,
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

  Widget _addNewButton(String category) {
    return GestureDetector(
      onTap: () => _onAddNewHospital(category: category),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: kSecondaryGreen,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kSecondaryGreen.withOpacity(0.35),
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

  // ── Grouped hospital card ─────────────────────────────
  //  One expandable card per hospital holding its schedule, online
  //  consultation and assigned doctors together.
  Widget _hospitalGroupCard(Hospital h) {
    final schedIdx = _schedules.indexWhere(
        (s) => s.id == 'sch_${h.id}' || s.hospitalName == h.name);
    final sched = schedIdx >= 0 ? _schedules[schedIdx] : null;
    final onlineIdx =
        _onlineSchedules.indexWhere((o) => o.hospitalId == h.id);
    final online = onlineIdx >= 0 ? _onlineSchedules[onlineIdx] : null;
    final assignedDoctors = DoctorRegistry.instance.doctorsForHospital(h.id);
    final expanded = _expanded.contains(h.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(radius: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupHeader(h, expanded),
            if (!expanded)
              _collapsedSummary(sched, online, assignedDoctors.length)
            else
              _expandedBody(h, sched, online, assignedDoctors),
          ],
        ),
      ),
    );
  }

  void _toggle(String id) => setState(() {
        if (_expanded.contains(id)) {
          _expanded.remove(id);
        } else {
          _expanded.add(id);
        }
      });

  // Blue header strip — tap toggles expand; edit/delete act on the hospital.
  Widget _groupHeader(Hospital h, bool expanded) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _toggle(h.id),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
        decoration: const BoxDecoration(color: kPrimaryBlue),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                  h.isClinic
                      ? Icons.storefront_rounded
                      : Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 22),
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
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.phone_rounded,
                        size: 11, color: Colors.white70),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(h.phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 8),
                    _hdrBadge(h.category),
                    if (h.isClinic && h.type.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      _hdrBadge(h.type),
                    ],
                  ]),
                  if (h.address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on_rounded,
                          size: 11, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(h.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11.5, color: Colors.white70)),
                      ),
                    ]),
                  ],
                ],
              ),
            ),
            _headerIcon(Icons.edit_rounded, () => _onEditHospital(h)),
            const SizedBox(width: 6),
            _headerIcon(Icons.delete_rounded, () => _onDeleteHospital(h)),
            const SizedBox(width: 4),
            Icon(
                expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: Colors.white,
                size: 24),
          ],
        ),
      ),
    );
  }

  // Compact one-line summary shown when the card is collapsed.
  Widget _collapsedSummary(
      HospitalSchedule? sched, OnlineSchedule? online, int docCount) {
    final chips = <Widget>[];
    if (sched != null) {
      chips.add(_miniChip(
          Icons.currency_rupee_rounded,
          'Fee ${sched.fee.replaceAll('₹', '')}',
          DoctorColors.badgeGreen,
          DoctorColors.badgeGreenText));
      chips.add(_miniChip(Icons.timer_outlined, '${sched.intervalMins} mins',
          DoctorColors.badgeBlue, DoctorColors.badgeBlueText));
    }
    if (online != null) {
      final days = online.selectedDays.contains('all')
          ? 'All days'
          : '${online.selectedDays.length} days';
      chips.add(_miniChip(Icons.calendar_today_rounded, days,
          DoctorColors.primarySoft, DoctorColors.primaryBrand));
    }
    chips.add(_miniChip(
        Icons.groups_rounded,
        '$docCount doctor${docCount == 1 ? '' : 's'}',
        DoctorColors.badgeIndigo,
        DoctorColors.textDark));
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Wrap(spacing: 6, runSpacing: 6, children: chips),
    );
  }

  // Full details shown when the card is expanded.
  Widget _expandedBody(Hospital h, HospitalSchedule? sched,
      OnlineSchedule? online, List<HiredDoctor> assignedDoctors) {
    final details = online != null ? _consultationData[online.id] : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Clinical Visit card ──
          _subCard(
            icon: Icons.event_available_rounded,
            title: 'Clinical Visit',
            accent: kSecondaryGreen,
            actions: sched != null
                ? [_smallAction(Icons.edit_rounded, () => _onEditSchedule(sched))]
                : const [],
            child: sched == null
                ? const Text('No clinical visit set',
                    style:
                        TextStyle(fontSize: 12, color: DoctorColors.textMuted))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(spacing: 6, runSpacing: 6, children: [
                        _miniChip(
                            Icons.currency_rupee_rounded,
                            'Fee: ${sched.fee.replaceAll('₹', '')}',
                            DoctorColors.badgeGreen,
                            DoctorColors.badgeGreenText),
                        _miniChip(Icons.timer_outlined,
                            'Interval: ${sched.intervalMins} mins',
                            DoctorColors.badgeBlue,
                            DoctorColors.badgeBlueText),
                      ]),
                      const SizedBox(height: 10),
                      _labeledRow('Days', _daysWrap(sched.visitDays)),
                      const SizedBox(height: 10),
                      _labeledRow('Timing',
                          _timingText(sched.fromTime, sched.toTime)),
                    ],
                  ),
          ),

          // ── Online Consultation card ──
          _subCard(
            icon: Icons.videocam_rounded,
            title: 'Online Consultation',
            accent: kPrimaryBlue,
            actions: online != null
                ? [
                    _smallAction(Icons.edit_calendar_rounded,
                        () => _onEditOnlineSchedule(online)),
                    _smallAction(Icons.delete_rounded,
                        () => _onDeleteOnlineSchedule(online),
                        color: DoctorColors.error),
                  ]
                : const [],
            child: online == null
                ? const Text('No online consultation set',
                    style:
                        TextStyle(fontSize: 12, color: DoctorColors.textMuted))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labeledRow(
                          'Days',
                          GestureDetector(
                            onTap: () => _onEditOnlineSchedule(online),
                            child: _daysWrap(online.selectedDays),
                          )),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                            child: _timeChip('From', online.fromTime,
                                () => _pickOnlineTime(online, true))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 18, color: DoctorColors.primaryBrand),
                        ),
                        Expanded(
                            child: _timeChip('To', online.toTime,
                                () => _pickOnlineTime(online, false))),
                      ]),
                      if (details != null) ...[
                        const SizedBox(height: 12),
                        _consultationTable(details),
                      ],
                    ],
                  ),
          ),

          // ── Assigned doctors card ──
          _subCard(
            icon: Icons.groups_rounded,
            title: 'Assigned Doctors',
            accent: DoctorColors.primaryBrand,
            actions: [_assignPill(h)],
            child: assignedDoctors.isEmpty
                ? const Text('No doctors assigned',
                    style: TextStyle(
                        fontSize: 12,
                        color: DoctorColors.textMuted,
                        fontWeight: FontWeight.w600))
                : Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: assignedDoctors
                        .map((d) => _doctorChip(d.displayName))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // Bordered sub-card with a tinted title bar — used for the Clinical Visit,
  // Online Consultation and Assigned Doctors sections inside a hospital.
  Widget _subCard({
    required IconData icon,
    required String title,
    required Color accent,
    required Widget child,
    List<Widget> actions = const [],
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DoctorColors.dividerCool),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(children: [
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: accent)),
              ),
              ...actions,
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _labeledRow(String label, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Text('$label:',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: DoctorColors.textSecondary)),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _daysWrap(Set<String> days) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: days.contains('all')
          ? [_dayPill('All Days')]
          : _dayLabels
              .where((d) => days.contains(d.key))
              .map((d) => _dayPill(d.value))
              .toList(),
    );
  }

  Widget _timingText(TimeOfDay? from, TimeOfDay? to) {
    final has = from != null && to != null;
    return Text(
      has ? '${from.format(context)}  →  ${to.format(context)}' : 'Not set',
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: has ? DoctorColors.textPrimary : DoctorColors.textMuted,
      ),
    );
  }

  Widget _smallAction(IconData icon, VoidCallback onTap,
      {Color color = DoctorColors.primaryBrand}) {
    final isError = color == DoctorColors.error;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isError ? DoctorColors.errorSoftBg : DoctorColors.primarySoft,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _assignPill(Hospital h) {
    return GestureDetector(
      onTap: () => _assignDoctors(h),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: DoctorColors.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_add_alt_1_rounded,
                size: 14, color: DoctorColors.primaryBrand),
            SizedBox(width: 4),
            Text('Assign',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: DoctorColors.primaryBrand)),
          ],
        ),
      ),
    );
  }

  Widget _consultationTable(ConsultationScheduleData details) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: DoctorColors.backgroundFrost,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DoctorColors.dividerSoft),
      ),
      child: Column(
        children: summaryItems.asMap().entries.map((entry) {
          final isLast = entry.key == summaryItems.length - 1;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Icon(item.icon, size: 15, color: DoctorColors.primaryBrand),
                    const SizedBox(width: 8),
                    Text(item.label,
                        style: const TextStyle(
                            color: DoctorColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(item.valueGetter(details),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 11.5,
                              color: DoctorColors.textPrimary,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, color: DoctorColors.dividerSoft),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _doctorChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: kPrimaryBlue,
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

  // Small translucent badge shown on the blue hospital header.
  Widget _hdrBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.white)),
    );
  }

  Widget _dayPill(String label) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: kSecondaryGreen,
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
  final String? initialCategory;
  final String? existingFee;
  final int? existingInterval;
  final Set<String>? existingVisitDays;
  final TimeOfDay? existingVisitFrom;
  final TimeOfDay? existingVisitTo;
  final TimeOfDay? existingFrom;
  final TimeOfDay? existingTo;
  final ConsultationScheduleData? existingConsultation;

  /// Returns the hospital plus its clinical-visit schedule (fee + interval +
  /// available days + timings), the online consultation times AND consultation
  /// details (type + text/video charges) so the caller can create/update
  /// everything at once.
  final void Function(
      Hospital,
      String fee,
      int intervalMins,
      Set<String> visitDays,
      TimeOfDay? visitFrom,
      TimeOfDay? visitTo,
      TimeOfDay? from,
      TimeOfDay? to,
      ConsultationScheduleData consultation) onSave;

  const _HospitalDialog({
    this.existing,
    this.initialCategory,
    this.existingFee,
    this.existingInterval,
    this.existingVisitDays,
    this.existingVisitFrom,
    this.existingVisitTo,
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
  late final TextEditingController _addressCtrl;
  String _category = 'Clinic';
  String _type = 'Own';
  Set<String> _visitDays = {'all'};
  TimeOfDay? _visitFrom;
  TimeOfDay? _visitTo;
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
    _addressCtrl =
        TextEditingController(text: widget.existing?.address ?? '');
    _category =
        widget.existing?.category ?? widget.initialCategory ?? 'Clinic';
    _type = widget.existing?.type.isNotEmpty == true
        ? widget.existing!.type
        : 'Own';
    _visitDays = widget.existingVisitDays != null
        ? {...widget.existingVisitDays!}
        : {'all'};
    _visitFrom = widget.existingVisitFrom;
    _visitTo = widget.existingVisitTo;
    _fromTime = widget.existingFrom;
    _toTime = widget.existingTo;
    _consultType =
        widget.existingConsultation?.type ?? ConsultationType.both;
  }

  // Clinical-visit day toggle. 'all' is mutually exclusive with specific days.
  void _toggleVisitDay(String key) {
    setState(() {
      if (key == 'all') {
        _visitDays = {'all'};
        return;
      }
      _visitDays.remove('all');
      if (_visitDays.contains(key)) {
        _visitDays.remove(key);
      } else {
        _visitDays.add(key);
      }
      if (_visitDays.isEmpty) _visitDays = {'all'};
    });
  }

  Future<void> _pickVisitTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isFrom ? _visitFrom : _visitTo) ?? TimeOfDay.now(),
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
          _visitFrom = picked;
        } else {
          _visitTo = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _feeCtrl.dispose();
    _intervalCtrl.dispose();
    _textFeeCtrl.dispose();
    _videoFeeCtrl.dispose();
    _addressCtrl.dispose();
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
      // Ownership only applies to clinics.
      type: _category == 'Clinic' ? _type : '',
      category: _category,
      address: _addressCtrl.text.trim(),
    );
    widget.onSave(
      h,
      _feeCtrl.text.trim(),
      int.tryParse(_intervalCtrl.text.trim()) ?? 0,
      {..._visitDays},
      _visitFrom,
      _visitTo,
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

  // Available-days selector (All + Sun..Sat) used by the clinical visit form.
  Widget _daysSelector(Set<String> selected, void Function(String) onToggle) {
    const opts = [
      MapEntry('all', 'All'),
      MapEntry('sun', 'Sun'),
      MapEntry('mon', 'Mon'),
      MapEntry('tue', 'Tue'),
      MapEntry('wed', 'Wed'),
      MapEntry('thu', 'Thu'),
      MapEntry('fri', 'Fri'),
      MapEntry('sat', 'Sat'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available Days',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: DoctorColors.textSecondary.withOpacity(0.9))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: opts.map((o) {
            final on = selected.contains(o.key);
            return GestureDetector(
              onTap: () => onToggle(o.key),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: on ? kSecondaryGreen : DoctorColors.backgroundFrost,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: on ? Colors.transparent : DoctorColors.dividerSoft,
                  ),
                ),
                child: Text(o.value,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color:
                            on ? Colors.white : DoctorColors.textSecondary)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _formTimeBox(String label, TimeOfDay? time, VoidCallback onTap) {
    final hasTime = time != null;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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

  // Facility category selector: Clinic vs Hospital.
  Widget _categoryChip(String value, IconData icon) {
    final selected = _category == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _category = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kPrimaryBlue : DoctorColors.backgroundFrost,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.transparent : kPrimaryBlue,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? Colors.white : DoctorColors.primaryBrand),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color:
                      selected ? Colors.white : DoctorColors.textSecondary,
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
                ? kSecondaryGreen
                : DoctorColors.backgroundFrost,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : kSecondaryGreen,
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
    return Scaffold(
      backgroundColor: DoctorColors.backgroundCream,
      body: Column(
        children: [
          CurvedHeader(
              title: isEdit ? 'Edit $_category' : 'Add $_category'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _sectionLabel('FACILITY TYPE'),
                    Row(children: [
                      _categoryChip('Clinic', Icons.storefront_rounded),
                      const SizedBox(width: 10),
                      _categoryChip(
                          'Hospital', Icons.local_hospital_rounded),
                    ]),
                    const SizedBox(height: 18),
                    _sectionLabel(_category == 'Clinic'
                        ? 'CLINIC DETAILS'
                        : 'HOSPITAL DETAILS'),
                    TextField(
                      controller: _nameCtrl,
                      decoration: _fieldDecoration(
                          _category == 'Clinic'
                              ? 'Clinic name'
                              : 'Hospital name',
                          Icons.badge_rounded),
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
                    TextField(
                      controller: _addressCtrl,
                      maxLines: 4,
                      decoration: _fieldDecoration(
                          'Address', Icons.location_on_rounded),
                    ),
                    if (_category == 'Clinic') ...[
                      const SizedBox(height: 14),
                      _sectionLabel('OWNERSHIP'),
                      Row(children: [
                        _typeChip('Own'),
                        const SizedBox(width: 10),
                        _typeChip('Partner'),
                      ]),
                    ],

                    const SizedBox(height: 18),
                    _sectionLabel('CLINICAL VISIT'),
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
                    const SizedBox(height: 12),
                    _daysSelector(_visitDays, _toggleVisitDay),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _formTimeBox('From Time', _visitFrom,
                            () => _pickVisitTime(true)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 16, color: DoctorColors.primaryBrand),
                        ),
                        _formTimeBox('To Time', _visitTo,
                            () => _pickVisitTime(false)),
                      ],
                    ),

                    const SizedBox(height: 18),
                    _sectionLabel('ONLINE CONSULTATION'),
                    Row(
                      children: [
                        _formTimeBox('From Time', _fromTime,
                            () => _pickTime(true)),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 16,
                              color: DoctorColors.primaryBrand),
                        ),
                        _formTimeBox('To Time', _toTime,
                            () => _pickTime(false)),
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
                    if (_consultType == ConsultationType.textOnly ) ...[
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
                    if (_consultType == ConsultationType.both ) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _textFeeCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: _fieldDecoration(
                            'Both Consultation Charge (₹)',
                            Icons.chat_bubble_outline_rounded),
                      ),
                    ],
                    if (_consultType == ConsultationType.videoOnly ) ...[
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
                                color: kPrimaryBlue,
                                borderRadius:
                                    BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryBlue
                                        .withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                isEdit ? 'Update $_category' : 'Add $_category',
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
            ),
          ),
        ],
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
  late Set<String> _days;
  TimeOfDay? _from;
  TimeOfDay? _to;

  static const List<MapEntry<String, String>> _dayOpts = [
    MapEntry('all', 'All'),
    MapEntry('sun', 'Sun'),
    MapEntry('mon', 'Mon'),
    MapEntry('tue', 'Tue'),
    MapEntry('wed', 'Wed'),
    MapEntry('thu', 'Thu'),
    MapEntry('fri', 'Fri'),
    MapEntry('sat', 'Sat'),
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.existing.hospitalName);
    _feeCtrl = TextEditingController(
        text: widget.existing.fee.replaceAll('₹', ''));
    _intervalCtrl = TextEditingController(
        text: widget.existing.intervalMins.toString());
    _days = {...widget.existing.visitDays};
    if (_days.isEmpty) _days = {'all'};
    _from = widget.existing.fromTime;
    _to = widget.existing.toTime;
  }

  void _toggleDay(String key) {
    setState(() {
      if (key == 'all') {
        _days = {'all'};
        return;
      }
      _days.remove('all');
      if (_days.contains(key)) {
        _days.remove(key);
      } else {
        _days.add(key);
      }
      if (_days.isEmpty) _days = {'all'};
    });
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isFrom ? _from : _to) ?? TimeOfDay.now(),
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
          _from = picked;
        } else {
          _to = picked;
        }
      });
    }
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
      visitDays: {..._days},
      fromTime: _from,
      toTime: _to,
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

  Widget _timeBox(String label, TimeOfDay? time, bool isFrom) {
    final has = time != null;
    return GestureDetector(
      onTap: () => _pickTime(isFrom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: DoctorColors.backgroundFrost,
          border: Border.all(
            color: has ? DoctorColors.primaryAccent : DoctorColors.dividerSoft,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 16,
                color:
                    has ? DoctorColors.primaryBrand : DoctorColors.textMuted),
            const SizedBox(width: 8),
            Text(
              has ? time.format(context) : label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: has ? FontWeight.w700 : FontWeight.w500,
                color:
                    has ? DoctorColors.textPrimary : DoctorColors.textMuted,
              ),
            ),
          ],
        ),
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
        child: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(color: kSecondaryGreen),
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
                      'Edit Clinical Visit',
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
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Available Days',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                DoctorColors.textSecondary.withOpacity(0.9))),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _dayOpts.map((o) {
                      final on = _days.contains(o.key);
                      return GestureDetector(
                        onTap: () => _toggleDay(o.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: on
                                ? kSecondaryGreen
                                : DoctorColors.backgroundFrost,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: on
                                  ? Colors.transparent
                                  : DoctorColors.dividerSoft,
                            ),
                          ),
                          child: Text(o.value,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: on
                                      ? Colors.white
                                      : DoctorColors.textSecondary)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _timeBox('From', _from, true)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 16, color: DoctorColors.primaryBrand),
                      ),
                      Expanded(child: _timeBox('To', _to, false)),
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
                              color: kSecondaryGreen,
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
      ),
    );
  }
}
