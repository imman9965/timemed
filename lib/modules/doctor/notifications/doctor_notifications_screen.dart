import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common/curved_header.dart';
import '../../../routes/app_routes.dart';
import '../theme/doctor_colors.dart';
import 'notification_controller.dart';

/// Light-blue palette for the notification flow.
class _Blue {
  static const Color screenBg = Color(0xFFEAF3FE);
  static const Color card = Color(0xFFF4F9FF);
  static const Color cardBorder = Color(0xFFBBDDF7);
  static const Color headerBg = Color(0xFF234DC5);

  static const Color iconBg = Color(0xFFCDE6FF);

  static const Color accent = Color(0xFF2196F3);
  static const Color accentDeep = Color(0xFF1565C0);
  static const Color titleDark = Color(0xFF0D47A1);
  static const Color bodyText = Color(0xFF335A86);
  static const Color timeText = Color(0xFF7FA6CC);
  static const Color success = Color(0xFF2E9E5B);
  static const Color danger = Color(0xFFE05656);

  // Detail (paid) card tones.
  static const Color detailCard = Colors.white;
  static const Color avatarGrey = Color(0xFFE4E6EB);
  static const Color chipGrey = Color(0xFFEDEDED);
  static const Color barGrey = Color(0xFFF1F2F6);
  static const Color waitingOrange = Color(0xFFF5A623);
  static const Color nameBlack = Color(0xFF1A1A1A);
}

/// Notification screen.
///
/// Notifications are handled **one at a time**. The current request flows
/// through: Incoming (Accept / Reject) → Waiting for Payment (Payment Complete)
/// → Ready for Video Call (appointment detail card + Initiate Video Call). The
/// call button opens [VideoCallScreen]; returning from it removes the tile and
/// surfaces the next queued notification.
class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  NotificationController get _c => NotificationController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CurvedHeader(
            title: 'Notifications',
            trailing: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _c.clearAll,
                child: Icon(Icons.delete_sweep_outlined,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final item = _c.current;
              if (item == null) return _buildEmptyState();
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPendingBanner(_c.pendingCount),
                    const SizedBox(height: 12),
                    if (item.status == NotifStatus.readyForCall)
                      _buildReadyDetailCard(context, item)
                    else
                      _buildCard(context, item),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Pending counter ──────────────────────────────────────
  Widget _buildPendingBanner(int count) {
    final more = count - 1;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:  Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.layers_outlined, size: 18, color:Colors.white),
          const SizedBox(width: 8),
          Text(
            more > 0
                ? 'Showing 1 of $count  •  $more more waiting'
                : 'Showing the only pending notification',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  READY-FOR-CALL DETAIL CARD (after payment)
  // ════════════════════════════════════════════════════════
  Widget _buildReadyDetailCard(BuildContext context, AppNotification item) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _Blue.detailCard,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: DoctorColors.primary, // Border color
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Avatar (left) + Appointment ID / Type (right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: _Blue.avatarGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        size: 32, color: Color(0xFF9AA0A6)),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _Blue.chipGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Appointment ID: ${item.appointmentId}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _Blue.nameBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Type: ',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF6B7280))),
                          const Icon(Icons.event,
                              size: 15, color: _Blue.accent),
                          const SizedBox(width: 4),
                          Text(
                            item.consultType,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _Blue.nameBlack,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Name + PAID badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.patientName,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: _Blue.nameBlack,
                      ),
                    ),
                  ),
                  const Text('💰', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 5),
                  const Text(
                    'PAID',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _Blue.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Phone
              Row(
                children: [
                  const Icon(Icons.call, size: 16, color: _Blue.accent),
                  const SizedBox(width: 6),
                  Text(
                    item.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _Blue.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Status bar: Waiting | date | time
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _Blue.barGrey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: _Blue.waitingOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Waiting',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _Blue.waitingOrange,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 15, color: _Blue.accent),
                        const SizedBox(width: 5),
                        Text(item.dateLabel,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _Blue.nameBlack)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time,
                            size: 15, color: _Blue.accent),
                        const SizedBox(width: 5),
                        Text(item.timeLabel,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _Blue.nameBlack)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _btn(
          label: 'Initiate Video Call',
          icon: Icons.videocam_rounded,
          color: DoctorColors.primary,
          fullWidth: true,
          onTap: () => _initiateVideoCall(context, item),
        ),
      ],
    );
  }

  /// Opens the real [VideoCallScreen]. When the doctor returns from the call,
  /// the tile is removed and the next queued notification appears.
  Future<void> _initiateVideoCall(
      BuildContext context, AppNotification item) async {
    await context.push(AppRoutes.videoPage);
    _c.completeVideoCall(item);
  }

  // ════════════════════════════════════════════════════════
  //  INCOMING / WAITING-FOR-PAYMENT CARD
  // ════════════════════════════════════════════════════════
  Widget _buildCard(BuildContext context, AppNotification item) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DoctorColors.primary),
        boxShadow: [
          BoxShadow(
            color: _Blue.accent.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color:  Colors.green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(_statusIcon(item.status),
                    size: 20, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusTitle(item.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(item.relativeTime,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _Blue.iconBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.person_outline,
                          color: _Blue.accent, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _Blue.titleDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Patient ID: ${item.patientId}',
                            style: const TextStyle(
                                fontSize: 12.5, color: _Blue.bodyText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _Blue.cardBorder),
                  ),
                  child: Text(
                    _statusMessage(item),
                    style: const TextStyle(
                        fontSize: 13, color: _Blue.bodyText, height: 1.35),
                  ),
                ),
                const SizedBox(height: 16),
                _buildActions(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AppNotification item) {
    switch (item.status) {
      case NotifStatus.incoming:
        return Row(
          children: [
            Expanded(
              child: _btn(
                label: 'Reject',
                icon: Icons.close_rounded,
                color: _Blue.danger,
                filled: false,
                onTap: () => _c.reject(item),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _btn(
                label: 'Accept',
                icon: Icons.check_rounded,
                color: DoctorColors.primary,
                onTap: () => _c.accept(item),
              ),
            ),
          ],
        );
      case NotifStatus.waitingPayment:
        return _btn(
          label: 'Payment Complete From Patient',
          icon: Icons.payment_rounded,
          color: DoctorColors.primary,
          fullWidth: true,
          onTap: () => _c.completePayment(item),
        );
      case NotifStatus.readyForCall:
        // Handled by the detail card; never reached here.
        return const SizedBox.shrink();
    }
  }

  // ── Empty state ──────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: _Blue.timeText),
          SizedBox(height: 12),
          Text(
            'No pending notifications',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _Blue.bodyText),
          ),
          SizedBox(height: 4),
          Text(
            'Tap the bell on the calendar to add one.',
            style: TextStyle(fontSize: 13, color: _Blue.timeText),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────
  static IconData _statusIcon(NotifStatus s) {
    switch (s) {
      case NotifStatus.incoming:
        return Icons.call_rounded;
      case NotifStatus.waitingPayment:
        return Icons.hourglass_top_rounded;
      case NotifStatus.readyForCall:
        return Icons.videocam_rounded;
    }
  }

  static String _statusTitle(NotifStatus s) {
    switch (s) {
      case NotifStatus.incoming:
        return 'INSTANT CALL REQUEST';
      case NotifStatus.waitingPayment:
        return 'WAITING FOR PAYMENT';
      case NotifStatus.readyForCall:
        return 'READY FOR VIDEO CALL';
    }
  }

  static String _statusMessage(AppNotification n) {
    switch (n.status) {
      case NotifStatus.incoming:
        return '${n.patientName} (${n.patientId}) has requested an instant '
            'video consultation. Accept to proceed or reject the request.';
      case NotifStatus.waitingPayment:
        return 'Request accepted. Waiting for ${n.patientName} to complete the '
            'consultation payment. Tap "Payment Complete" once it is received.';
      case NotifStatus.readyForCall:
        return 'Payment received. You can now start the video consultation '
            'with ${n.patientName}.';
    }
  }

  Widget _btn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool filled = true,
    bool fullWidth = false,
  }) {
    final child = ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 19),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? color : Colors.white,
        foregroundColor: filled ? Colors.white : color,
        elevation: filled ? 1 : 0,
        side: filled ? null : BorderSide(color: color, width: 1.4),
        padding: const EdgeInsets.symmetric(vertical: 13),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: child) : child;
  }
}
