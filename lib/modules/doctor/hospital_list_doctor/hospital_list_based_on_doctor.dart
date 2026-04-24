import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/add_online_schedule_list.dart';

// void main() => runApp(const MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: HospitalListScreen(),
// ));

// ════════════════════════════════════════════════════════
//  APP COLORS
// ════════════════════════════════════════════════════════

class AppColors {
  static const primaryBlue  = Color(0xFF1A6BF5);
  static const scaffoldBg   = Color(0xFFFAF5EC);
  static const cardBg       = Colors.white;
  static const textDark     = Color(0xFF1A1A2E);
  static const textMuted    = Color(0xFF9E9E9E);
  static const textSecond   = Color(0xFF6B7280);
  static const inputBg      = Color(0xFFF5F5F5);
  static const dividerColor = Color(0xFFE5E5E5);
  static const redDelete    = Color(0xFFE53935);
  static const feeGreen     = Color(0xFF2E7D32);
  static const orangeBadge  = Color(0xFFFFB300);
  static const typeBadgeBg  = Color(0xFFE8EAF6);
}

// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

class Hospital {
  final String id;
  String name;
  String phone;
  String type;

  Hospital({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
  });
}

class HospitalSchedule {
  final String id;
  String hospitalName;
  String fee;
  int    intervalMins;
  HospitalSchedule({
    required this.id,
    required this.hospitalName,
    required this.fee,
    required this.intervalMins,
  });
}

class OnlineSchedule {
  final String   id;
  TimeOfDay?     fromTime;
  TimeOfDay?     toTime;

  OnlineSchedule({
    required this.id,
    this.fromTime,
    this.toTime,
  });
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

final List<Hospital> _initialHospitals = [
  Hospital(
      id: 'h1', name: 'Mariapan Clinic',
      phone: '8056567194', type: 'Own'),
  Hospital(
      id: 'h2', name: 'Mariapan Clinic',
      phone: '8056567194', type: 'Own'),
];

final List<HospitalSchedule> _initialSchedules = [
  HospitalSchedule(
      id: 's1', hospitalName: 'Sangamithra Hospital',
      fee: '₹550', intervalMins: 9),
  HospitalSchedule(
      id: 's2', hospitalName: 'Sangamithra Hospital',
      fee: '₹550', intervalMins: 9),
];



class OnlineScheduleData {
  Set<String> selectedDays;
  TimeOfDay?  fromTime;
  TimeOfDay?  toTime;

  OnlineScheduleData({
    Set<String>? selectedDays,
    this.fromTime,
    this.toTime,
  }) : selectedDays = selectedDays ?? {'all'};

  OnlineScheduleData copy() => OnlineScheduleData(
    selectedDays: Set.from(selectedDays),
    fromTime: fromTime,
    toTime:   toTime,
  );
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {

  late final List<Hospital>         _hospitals;
  late final List<HospitalSchedule> _schedules;
  OnlineScheduleData? initialData;


  // Online consultation schedule
  OnlineSchedule? _onlineSchedule = OnlineSchedule(id: 'o1');

  @override
  void initState() {
    super.initState();
    _hospitals = List.from(_initialHospitals);
    _schedules = List.from(_initialSchedules);
  }

  // ════════════════════════════════════════════════════
  //  ACTIONS
  // ════════════════════════════════════════════════════

  void _onAddNewHospital() {
    showDialog(
      context: context,
      builder: (_) => _HospitalDialog(
        onSave: (h) => setState(() => _hospitals.add(h)),
      ),
    );
  }

  void _onEditHospital(Hospital h) async {
    final result = await AddOnlineConsultationDialog.show(
      context,
      initialData: initialData, // or h.schedule
    );

    if (result != null) {
      setState(() {
        initialData = result;
      });
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

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _onlineSchedule ??= OnlineSchedule(id: 'o1');
        if (isFrom) {
          _onlineSchedule!.fromTime = picked;
        } else {
          _onlineSchedule!.toTime = picked;
        }
      });
    }
  }

  Future<void> _onEditOnlineSchedule() async {
    final result = await AddOnlineConsultationDialog.show(
      context,
      initialData: initialData, // or h.schedule
    );

    if (result != null) {
      setState(() {
        initialData = result;
      });
    }
  }

  // void _onEditHospital(Hospital h) async {
  //
  // }

  void _onDeleteOnlineSchedule() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete schedule?'),
        content: const Text('This will remove the online consultation schedule.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _onlineSchedule = null);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Deleted'),
                  backgroundColor: AppColors.redDelete,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.redDelete)),
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
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHospitalListCard(),
                  const SizedBox(height: 22),
                  _buildSectionPill('Hospital Schedule List'),
                  const SizedBox(height: 14),
                  // Schedules iterated from _schedules
                  ..._schedules.map(_buildScheduleCard),
                  const SizedBox(height: 14),
                  _buildSectionPill('Online Consultation Schedule List'),
                  const SizedBox(height: 14),
                  _buildOnlineScheduleCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft:  Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top:    MediaQuery.of(context).padding.top + 16,
        bottom: 22,
      ),
      child: const Text(
        'HOSPITAL LIST -\nBASED ON DOCTOR',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 22,
          height: 1.3,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ── Hospital List Card ────────────────────────────────
  Widget _buildHospitalListCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hospital List',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              _buildAddNewButton(),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.dividerColor),
          const SizedBox(height: 12),

          // Hospitals iterated
          ..._hospitals.asMap().entries.map((entry) {
            final isLast = entry.key == _hospitals.length - 1;
            return Column(children: [
              _buildHospitalRow(entry.value),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                      height: 1, color: AppColors.dividerColor),
                ),
            ]);
          }),
        ],
      ),
    );
  }

  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: _onAddNewHospital,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14, height: 14,
              decoration: const BoxDecoration(
                color: AppColors.orangeBadge,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add,
                  color: Colors.white, size: 11),
            ),
            const SizedBox(width: 6),
            const Text('Add New',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalRow(Hospital h) {
    return Row(
      children: [
        // Hospital icon
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.local_hospital,
              color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),

        // Name + phone
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(h.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textDark)),
              const SizedBox(height: 3),
              Row(children: [
                const Icon(Icons.phone,
                    size: 12, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                Text(h.phone,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecond,
                        fontWeight: FontWeight.w500)),
              ]),
            ],
          ),
        ),

        // Type badge
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.typeBadgeBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('Type: ',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecond)),
            Text(h.type,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
          ]),
        ),
        const SizedBox(width: 8),

        // Edit button
        _buildEditButton(() => _onEditHospital(h)),
      ],
    );
  }

  // ── Section Pill ─────────────────────────────────────
  Widget _buildSectionPill(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
      ),
    );
  }

  // ── Schedule Card ────────────────────────────────────
  Widget _buildScheduleCard(HospitalSchedule s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.hospitalName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              _buildEditButton(() => _onEditSchedule(s)),
            ],
          ),
          const SizedBox(height: 4),
          Row(children: [
            const Text('Fee: ',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            Text(s.fee,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.feeGreen)),
          ]),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.dividerColor),
          const SizedBox(height: 10),
          Row(children: [
            Container(
              width: 18, height: 18,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time,
                  color: Colors.white, size: 12),
            ),
            const SizedBox(width: 6),
            const Text('Interval In Mins: ',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            Text('${s.intervalMins}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue)),
          ]),
        ],
      ),
    );
  }

// ── Online Schedule Card ─────────────────────────────
  Widget _buildOnlineScheduleCard() {
    return Center(
      child: Container(
        // width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 Blue Header
            // Container(
            //   margin: const EdgeInsets.only(top: 14),
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF1A73FF), // bright blue
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   child: const Text(
            //     "Online Consultation Schedule List",
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14,
            //     ),
            //   ),
            // ),

            const SizedBox(height: 14),

            // 🔥 Inner Card with blue border
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25), // ✅ soft grey
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFD6E4FF), // ✅ light blue border
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // FROM
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "From",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _timeBox(_onlineSchedule?.fromTime, () {
                        _pickTime(true);
                      }),
                    ],
                  ),

                  // ARROW
                  const Padding(
                    padding: EdgeInsets.only(top: 24, left: 8, right: 8),
                    child: Icon(Icons.arrow_forward, size: 22, color: Colors.black),
                  ),

                  // TO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _timeBox(_onlineSchedule?.toTime, () {
                        _pickTime(false);
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 🔥 Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EDIT
                GestureDetector(
                  onTap: _onEditOnlineSchedule,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 14, color: Color(0xFF1A73FF)),
                        SizedBox(width: 4),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // DELETE
                GestureDetector(
                  onTap: _onDeleteOnlineSchedule,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF1744), // bright red
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _timeBox(TimeOfDay? time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF1A73FF), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          time != null ? time.format(context) : "Time",
          style: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ── Shared Edit button ────────────────────────────────
  Widget _buildEditButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined,
                size: 14, color: AppColors.primaryBlue),
            SizedBox(width: 4),
            Text('Edit',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }

  // ── Shared Delete button ──────────────────────────────
  Widget _buildDeleteButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.redDelete,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text('Delete',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  ADD / EDIT HOSPITAL DIALOG
// ════════════════════════════════════════════════════════

class _HospitalDialog extends StatefulWidget {
  final Hospital?                existing;
  final void Function(Hospital)  onSave;

  const _HospitalDialog({
    this.existing,
    required this.onSave,
  });

  @override
  State<_HospitalDialog> createState() => _HospitalDialogState();
}

class _HospitalDialogState extends State<_HospitalDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  String _type = 'Own';

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: widget.existing?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.existing?.phone ?? '');
    _type      = widget.existing?.type ?? 'Own';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields'),
            duration: Duration(seconds: 1)),
      );
      return;
    }
    final h = Hospital(
      id:    widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name:  _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      type:  _type,
    );
    widget.onSave(h);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      title: Text(isEdit ? 'Edit Hospital' : 'Add New Hospital'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'Hospital name',
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(
                labelText: 'Phone', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Type: '),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Own'),
              selected: _type == 'Own',
              onSelected: (_) => setState(() => _type = 'Own'),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Partner'),
              selected: _type == 'Partner',
              onSelected: (_) => setState(() => _type = 'Partner'),
            ),
          ]),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue),
          child: Text(isEdit ? 'Update' : 'Add',
              style: const TextStyle(color: Colors.white)),
        ),
      ],
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
    _nameCtrl     = TextEditingController(text: widget.existing.hospitalName);
    _feeCtrl      = TextEditingController(
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
      id:           widget.existing.id,
      hospitalName: _nameCtrl.text.trim(),
      fee:          '₹${_feeCtrl.text.trim()}',
      intervalMins: int.tryParse(_intervalCtrl.text) ??
          widget.existing.intervalMins,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit Schedule'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'Hospital name',
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _feeCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                labelText: 'Fee (₹)',
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _intervalCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                labelText: 'Interval (mins)',
                border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue),
          child: const Text('Update',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}