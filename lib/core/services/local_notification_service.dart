import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';

/// Handles a notification tap that arrives while the app process is in the
/// background. Must be a top-level / static function annotated with
/// `vm:entry-point` so the plugin can invoke it from a background isolate.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Navigation is performed when the app returns to the foreground via
  // [getNotificationAppLaunchDetails] / the foreground tap handler, so there is
  // nothing UI-related to do here.
}

/// Thin wrapper around [flutter_local_notifications].
///
/// Simulates a notification system **without Firebase or any backend**.
/// Every call to [showNotification] posts a brand-new system notification to
/// the device tray using a unique id, so previous notifications are never
/// replaced and they remain visible even after the app is closed. Tapping a
/// tray notification opens the in-app notifications screen.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'doctor_notifications';
  static const String _channelName = 'Doctor Notifications';
  static const String _channelDescription =
      'Simulated in-app notifications for the doctor module.';

  /// Payload that tells the tap handler which screen to open.
  static const String _notificationsPayload = AppRoutes.doctorNotifications;

  bool _initialized = false;

  /// Initializes the plugin, requests runtime permission, and wires up tap
  /// handling. Safe to call multiple times — it only runs once.
  Future<void> init() async {
    if (_initialized) return;

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Create the Android notification channel up front.
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    // Android 13+ requires asking the user at runtime.
    await androidImpl?.requestNotificationsPermission();

    _initialized = true;

    // If the app was launched (from a terminated state) by tapping a
    // notification, navigate to the notifications screen once the first frame
    // is ready.
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _navigateToNotifications();
    }
  }

  /// Called when a tray notification is tapped while the app is alive.
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload == _notificationsPayload) {
      _navigateToNotifications();
    }
  }

  /// Opens the notifications screen via the global router. Deferred to the next
  /// frame so it works whether the app is foreground, backgrounded, or just
  /// launched.
  void _navigateToNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        AppRouter.router.push(AppRoutes.doctorNotifications);
      } catch (e) {
        debugPrint('Notification navigation failed: $e');
      }
    });
  }

  /// Posts a single notification to the system tray.
  ///
  /// [id] must be unique per notification so the tray stacks them instead of
  /// overwriting the previous one.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Make sure we are ready even if init() was skipped somewhere.
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      // Light-blue accent on the notification (icon tint + colorized header).
      color: Color(0xFF4FC3F7),
      colorized: true,
      // A non-grouped, uniquely-id'd notification stays on its own in the tray.
      ticker: 'New notification',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.show(
        id,
        title,
        body,
        details,
        payload: _notificationsPayload,
      );
    } catch (e) {
      // Never let a notification failure crash the UI flow.
      debugPrint('LocalNotificationService.showNotification failed: $e');
    }
  }

  /// Clears all notifications this app posted to the system tray.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
