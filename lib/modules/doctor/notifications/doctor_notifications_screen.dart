import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common/curved_header.dart';

class DoctorNotificationsScreen extends StatefulWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  State<DoctorNotificationsScreen> createState() =>
      _DoctorNotificationsScreenState();
}

class _DoctorNotificationsScreenState
    extends State<DoctorNotificationsScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      title: 'INSTANT CALL REQUEST',
      message:
      'Patient Vignesh (313311) has requested for an instant call. Please approve or reject the request.',
      time: 'Just now',
      icon: Icons.call,
      color: AppColors.primary,
      isRead: false,
      type: NotificationType.callRequest,
    ),
    _NotificationItem(
      title: 'INSTANT CALL REQUEST',
      message:
      'Patient Vignesh (313311) has requested for an instant call. Please approve or reject the request.',
      time: 'Just now',
      icon: Icons.call,
      color: AppColors.primary,
      isRead: false,
      type: NotificationType.callRequest,
    ),
    _NotificationItem(
      title: 'INSTANT CALL REQUEST',
      message:
      'Patient Vignesh (313311) has requested for an instant call. Please approve or reject the request.',
      time: 'Just now',
      icon: Icons.call,
      color: AppColors.primary,
      isRead: false,
      type: NotificationType.callRequest,
    ),
    _NotificationItem(
      title: 'INSTANT CALL REQUEST',
      message:
      'Patient Vignesh (313311) has requested for an instant call. Please approve or reject the request.',
      time: 'Just now',
      icon: Icons.call,
      color: AppColors.primary,
      isRead: false,
      type: NotificationType.callRequest,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const CurvedHeader(title: 'Notifications'),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _notifications[index];

                if (item.type == NotificationType.callRequest) {
                  return _buildCallRequestCard(item);
                } else {
                  return _buildNormalNotification(item);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 CALL REQUEST CARD
  Widget _buildCallRequestCard(_NotificationItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color:  AppColors.primary,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: const Center(
              child: Text(
                "INSTANT CALL REQUEST",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  item.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// ACCEPT
                    ElevatedButton.icon(
                      onPressed: () {
                        _onAccept(item);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("Accept"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    /// REJECT
                    ElevatedButton.icon(
                      onPressed: () {
                        _onReject(item);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("Reject"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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
    );
  }

  /// 🟢 NORMAL NOTIFICATION
  Widget _buildNormalNotification(_NotificationItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isRead
            ? Colors.white
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isRead
              ? Colors.grey.shade200
              : AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight:
                    item.isRead ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  item.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          /// DOT
          if (!item.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  /// ACTIONS
  void _onAccept(_NotificationItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Call Accepted")),
    );
  }

  void _onReject(_NotificationItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Call Rejected")),
    );
  }
}

/// MODEL
enum NotificationType { normal, callRequest }

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final bool isRead;
  final NotificationType type;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.isRead,
    this.type = NotificationType.normal,
  });
}
