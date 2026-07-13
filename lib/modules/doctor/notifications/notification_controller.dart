import 'package:get/get.dart';

import '../../../core/services/local_notification_service.dart';

/// Lifecycle of a single notification as the doctor works through it.
enum NotifStatus {
  /// Just arrived — doctor can Accept or Reject.
  incoming,

  /// Accepted — waiting for the patient's payment to clear.
  waitingPayment,

  /// Paid — doctor can start the video call.
  readyForCall,
}

/// A single consultation request flowing through the notification pipeline.
class AppNotification {
  final int id;
  final String patientName;
  final String patientId;
  final String appointmentId;
  final String phone;
  final String consultType; // 'Schedule' or 'Instant'
  final String dateLabel;
  final String timeLabel;
  final DateTime createdAt;
  NotifStatus status;

  AppNotification({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.appointmentId,
    required this.phone,
    required this.consultType,
    required this.dateLabel,
    required this.timeLabel,
    required this.createdAt,
    this.status = NotifStatus.incoming,
  });

  /// Human-friendly relative time, e.g. "Just now", "3 min ago".
  String get relativeTime {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day(s) ago';
  }
}

/// Global, reactive store for the simulated notification system.
///
/// Notifications are processed **one at a time**: only the first item in the
/// [queue] is shown. The doctor moves it through Accept → Payment → Video Call,
/// after which it is removed and the next queued notification appears. The
/// calendar bell badge reflects how many notifications are still pending.
class NotificationController extends GetxController {
  /// Find the singleton, creating it on first use if needed.
  static NotificationController get to =>
      Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>()
          : Get.put(NotificationController(), permanent: true);

  /// Pending notifications, FIFO. Only [current] is displayed at a time.
  final RxList<AppNotification> queue = <AppNotification>[].obs;

  /// The notification currently being processed (null when the queue is empty).
  AppNotification? get current => queue.isEmpty ? null : queue.first;

  /// Badge count = how many notifications are still pending.
  int get pendingCount => queue.length;

  /// Monotonic id so every system notification is unique (never replaced).
  int _nextId = 1;

  /// Sample patients cycled through on each new notification.
  /// Keys: name, pid, apt, phone, type, date, time.
  static const List<Map<String, String>> _patients = [
    {
      'name': 'Mr. Raj Kumar', 'pid': '313311', 'apt': '259230',
      'phone': '700XXXXXX9', 'type': 'Schedule', 'date': '1/7/2026',
      'time': '02:30 PM',
    },
    {
      'name': 'Ms. Anitha Rao', 'pid': '220114', 'apt': '259244',
      'phone': '984XXXXXX4', 'type': 'Instant', 'date': '1/7/2026',
      'time': '03:15 PM',
    },
    {
      'name': 'Mr. Suresh Kumar', 'pid': '418502', 'apt': '259261',
      'phone': '900XXXXXX1', 'type': 'Schedule', 'date': '2/7/2026',
      'time': '10:00 AM',
    },
    {
      'name': 'Mrs. Priya Menon', 'pid': '509873', 'apt': '259288',
      'phone': '733XXXXXX7', 'type': 'Instant', 'date': '2/7/2026',
      'time': '11:45 AM',
    },
  ];

  /// Simulates an incoming consultation request: queues it, and posts it to
  /// the system tray so it shows even if the app is closed.
  Future<void> simulateNotification() async {
    final id = _nextId++;
    final p = _patients[(id - 1) % _patients.length];

    queue.add(
      AppNotification(
        id: id,
        patientName: p['name']!,
        patientId: p['pid']!,
        appointmentId: p['apt']!,
        phone: p['phone']!,
        consultType: p['type']!,
        dateLabel: p['date']!,
        timeLabel: p['time']!,
        createdAt: DateTime.now(),
        status: NotifStatus.incoming,
      ),
    );

    await LocalNotificationService.instance.showNotification(
      id: id,
      title: 'Instant Call Request',
      body: '${p['name']} (${p['pid']}) is requesting an instant '
          'video consultation.',
    );
  }

  /// Accept the request → move it to "waiting for payment".
  void accept(AppNotification n) {
    n.status = NotifStatus.waitingPayment;
    queue.refresh();
  }

  /// Reject the request → drop it and surface the next notification.
  void reject(AppNotification n) {
    queue.remove(n);
  }

  /// Payment cleared → the doctor can now start the video call.
  void completePayment(AppNotification n) {
    n.status = NotifStatus.readyForCall;
    queue.refresh();
  }

  /// Video call finished → remove this item; the next notification appears.
  void completeVideoCall(AppNotification n) {
    queue.remove(n);
  }

  /// Clears everything (and the system tray).
  Future<void> clearAll() async {
    queue.clear();
    await LocalNotificationService.instance.cancelAll();
  }
}
