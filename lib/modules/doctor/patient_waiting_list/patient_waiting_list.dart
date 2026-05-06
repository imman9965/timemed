import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../missed_call_page/missed_call.dart';
import '../widgets/doctor_stamp.dart';
import 'dummy_data_9.dart' hide PaymentStatus;

class SectionHeader extends StatelessWidget {
  final String label;
  final String statusText;
  final Color  statusColor;

  const SectionHeader({
    Key? key,
    required this.label,
    required this.statusText,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecond,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 6),
            Container(
              width: 7, height: 7,
              decoration: BoxDecoration(
                  color: statusColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(statusText,
                style: TextStyle(
                    fontSize: 13,
                    color: statusColor,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
         Divider(color:Colors.grey.shade300, height: 1),
      ],
    );
  }
}

/// Patient waiting card

class PatientWaitingCard extends StatefulWidget {
  final WaitingPatient patient;
  final VoidCallback? onVideoCall;
  final bool showDemo;
  final VoidCallback? onDemoComplete;

  const PatientWaitingCard({
    Key? key,
    required this.patient,
    this.onVideoCall,
    this.showDemo = false,
    this.onDemoComplete,
  }) : super(key: key);

  @override
  State<PatientWaitingCard> createState() => _PatientWaitingCardState();
}

class _PatientWaitingCardState extends State<PatientWaitingCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isRevealed = false;

  // ── Demo animation state ──
  AnimationController? _demoController;
  AnimationController? _handController;
  AnimationController? _pulseController;
  Animation<Offset>? _demoSlideAnimation;
  Animation<double>? _handOpacity;
  Animation<double>? _handTranslateX;
  Animation<double>? _tooltipOpacity;
  Animation<double>? _pulseScale;
  bool _isDemoPlaying = false;

  String get _typeLabel =>
      widget.patient.type == AppointmentType.instant ? 'Instant' : 'Schedule';
  String get _typeIcon =>
      widget.patient.type == AppointmentType.instant ? '⚡' : '📅';

  Color get _statusBg {
    switch (widget.patient.waitingStatus) {
      case WaitingStatus.waiting:
        return AppColors.waitingYellow;
      case WaitingStatus.inProgress:
        return const Color(0xFFE3F2FD);
      case WaitingStatus.done:
        return AppColors.green2;
    }
  }

  Color get _statusTextColor {
    switch (widget.patient.waitingStatus) {
      case WaitingStatus.waiting:
        return AppColors.waitingText;
      case WaitingStatus.inProgress:
        return AppColors.primary;
      case WaitingStatus.done:
        return AppColors.green2;
    }
  }

  String get _statusLabel {
    switch (widget.patient.waitingStatus) {
      case WaitingStatus.waiting:
        return 'Waiting';
      case WaitingStatus.inProgress:
        return 'In Progress';
      case WaitingStatus.done:
        return 'Done';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.22, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.showDemo) {
      _setupDemoAnimation();
    }
  }

  void _setupDemoAnimation() {
    // Main demo slide controller (card slides left then back)
    _demoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Hand icon controller (fade in/out + translate)
    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Pulse animation for video button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Card slide sequence:
    // 0.0-0.1  → wait (card still)
    // 0.1-0.4  → slide left
    // 0.4-0.7  → hold revealed
    // 0.7-1.0  → slide back right
    _demoSlideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: ConstantTween(Offset.zero),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-0.22, 0))
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween(const Offset(-0.22, 0)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.22, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_demoController!);

    // Hand opacity: fade in → visible → fade out
    _handOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_handController!);

    // Hand translateX: starts right, drags left, then back
    _handTranslateX = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -70.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween(-70.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(begin: -70.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_handController!);

    // Tooltip opacity: appears during hold phase
    _tooltipOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
    ]).animate(_demoController!);

    // Pulse for video button
    _pulseScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );

    _demoController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController?.stop();
        if (mounted) {
          setState(() => _isDemoPlaying = false);
          widget.onDemoComplete?.call();
        }
      }
    });

    // Start demo after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isDemoPlaying = true);
        _demoController!.forward();
        _handController!.forward();
        // Start pulse when card is revealed (after ~40% of animation)
        Future.delayed(const Duration(milliseconds: 1120), () {
          if (mounted && _isDemoPlaying) {
            _pulseController?.repeat(reverse: true);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _demoController?.dispose();
    _handController?.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  void _cancelDemo() {
    if (!_isDemoPlaying) return;
    _demoController?.stop();
    _handController?.stop();
    _pulseController?.stop();
    if (mounted) {
      setState(() => _isDemoPlaying = false);
    }
  }

  void _reveal() {
    if (_isDemoPlaying) _cancelDemo();
    if (!_isRevealed) {
      _controller.forward();
      setState(() => _isRevealed = true);
    }
  }

  void _hide() {
    if (_isDemoPlaying) _cancelDemo();
    if (_isRevealed) {
      _controller.reverse();
      setState(() => _isRevealed = false);
    }
  }

  void _onVideoTap() {
    if (widget.onVideoCall != null) {
      context.push(AppRoutes.videoPage);
    } else {
      context.push(AppRoutes.videoPage);
    }
    _hide();
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;
    final isPaid = patient.paymentStatus == PaymentStatus.paid;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: GestureDetector(
                  onTap: _onVideoTap,
                  child: ScaleTransition(
                    scale: (_isDemoPlaying && _pulseScale != null)
                        ? _pulseScale!
                        : const AlwaysStoppedAnimation<double>(1.0),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Swipeable card on top ─────────────────────────
          GestureDetector(
            onHorizontalDragStart: (_) => _cancelDemo(),
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -2) {
                _reveal();
              } else if (details.delta.dx > 2) {
                _hide();
              }
            },
            onTap: () {
              if (_isRevealed) _hide();
            },
            child: SlideTransition(
              position: (_isDemoPlaying && _demoSlideAnimation != null)
                  ? _demoSlideAnimation!
                  : _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Row 1: Avatar + Appointment ID + Type ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 10),

                        // Appointment ID + Type (top-right)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Appointment ID: ${patient.appointmentId}',
                                    style: const TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'Type: $_typeIcon $_typeLabel',
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSecond),
                                ),
                              )


                            ],
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textDark,
                          ),
                        ),
                        Row(
                          children: [
                            Text(!isPaid ? '💰' : '❌',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              isPaid ? 'UNPAID' : 'PAID',
                              style: TextStyle(
                                color: !isPaid
                                    ? AppColors.paidGreen
                                    : Colors.red,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Phone
                    Row(
                      children: [
                        const Icon(Icons.phone,
                            size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(patient.phone,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecond)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Status + Date + Time row ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius:5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Waiting status pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: _statusTextColor,
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _statusLabel,
                                  style: TextStyle(
                                    color: _statusTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Date
                          Row(
                            children: [
                              const Icon(Icons.calendar_month,
                                  size: 13, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(patient.date,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),

                          // Time
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 13, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(patient.time,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Demo coachmark overlay (hand pointer + tooltip) ──
          if (_isDemoPlaying &&
              _handController != null &&
              _demoController != null)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: Listenable.merge(
                      [_handController!, _demoController!]),
                  builder: (context, _) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Tooltip pill at top-center of the card
                        Positioned(
                          top: -10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Opacity(
                              opacity: _tooltipOpacity?.value ?? 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.swipe_left,
                                        color: Colors.white, size: 14),
                                    SizedBox(width: 6),
                                    Text(
                                      'Swipe left to reveal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Animated hand pointer that drags from right → left
                        Positioned(
                          right: 24,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Opacity(
                              opacity: _handOpacity?.value ?? 0,
                              child: Transform.translate(
                                offset: Offset(
                                    _handTranslateX?.value ?? 0, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withOpacity(0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.touch_app,
                                    color: AppColors.primary,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

        ],
      ),
    );
  }
}
/// Add Patient FAB-style button
class AddPatientButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddPatientButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outlined, color: Colors.yellow, size: 23),
            SizedBox(width: 6),
            Text(
              'Add Patient',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PatientWaitingListScreen extends StatefulWidget {
  const PatientWaitingListScreen({Key? key}) : super(key: key);

  @override
  State<PatientWaitingListScreen> createState() =>
      _PatientWaitingListScreenState();
}

class _PatientWaitingListScreenState
    extends State<PatientWaitingListScreen> {

  int _activeNavIndex = 1; // patients tab active by default

  void _onAddPatient() {
    context.push(AppRoutes.addPatientScreen);
  }

  @override
  Widget build(BuildContext context) {
    var doctor =  'Dr.Mariappan';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // ── Main scrollable content ────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                const CurvedHeader(title: 'Patient Waiting List'),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Doctor badge ───────────────────────
                        DoctorBadge(doctor: doctor),
                        const SizedBox(height: 14),

                        // ── Online patients section ────────────
                        const SectionHeader(
                          label:       'Patients Available',
                          statusText:  'Online',
                          statusColor: Colors.blue,
                        ),

                        const SizedBox(height: 12),

                        // Iterated from _onlinePatients
                        // ..._onlinePatients.map(
                        //       (p) => PatientWaitingCard(patient: p),
                        // ),

                        // const SizedBox(height: 8),

                        // ── In-person patients section ─────────
                        // const SectionHeader(
                        //   label:       'Patients in',
                        //   statusText:  'Online',
                        //   statusColor: Colors.orange,
                        // ),
                        // const SizedBox(height: 12),

                        // Iterated from _inPersonPatients.
                        // The very first card plays a one-time swipe demo
                        // so users discover the hidden video-call action.
                        ...inPersonPatients.asMap().entries.map(
                              (e) => PatientWaitingCard(
                                patient: e.value,
                                showDemo: e.key == 0,
                              ),
                        ),
                        const SectionHeader(
                          label:       'Patients in',
                          statusText:  'Online',
                          statusColor: Colors.red,
                        ),

                         SizedBox(height:MediaQuery.of(context).size.height/5),

                        // ── Add Patient button (right-aligned) ──
                        Align(
                          alignment: Alignment.bottomRight,
                          child: AddPatientButton(onTap: _onAddPatient),
                        ),

                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: AddPatientButton(onTap: _onAddPatient),
                        // ),


                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Pinned bottom nav ──────────────────────────────
          // Positioned(
          //   left: 0, right: 0, bottom: 0,
          //   child: AppBottomNav(
          //     activeIndex: _activeNavIndex,
          //     onTap: (i) => setState(() => _activeNavIndex = i),
          //   ),x
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: () {
      //     context.push(AppRoutes.videoPage);
      //   },
      //   child:const Icon(Icons.video_call, color: Colors.blue),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,    );
  }
}