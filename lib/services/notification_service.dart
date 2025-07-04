// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern: Bu sınıfın sadece bir örneği olmasını sağlar.
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Timezone veritabanını başlat
    tz.initializeTimeZones();
    // Cihazın yerel saat dilimini alıp ayarla
    // Bu satırın çalışması için main.dart'ta bir ekleme yapacağız.
    // tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    // 2. Android için başlatma ayarları
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // 3. iOS için başlatma ayarları
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 4. Ayarları birleştir
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 5. Eklentiyi başlat
    await _notificationsPlugin.initialize(settings);
  }

  // İzin isteme metodu (Android 13+ için çok önemli)
  Future<void> requestPermissions() async {
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  // Bildirim planlama metodu
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Android için bildirim detayları
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'activity_channel', // Kanal ID'si
      'Aktivite Hatırlatıcıları', // Kanal Adı
      channelDescription: 'Aktivite başlangıç zamanları için hatırlatıcılar.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // iOS için bildirim detayları
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Bildirimi planla
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
          scheduledTime, tz.local), // Cihazın saat dilimine göre ayarla
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Belirli bir bildirimi iptal etme metodu
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Tüm bildirimleri iptal etme metodu
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
