import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static int timeForNotification = 20; // Horário padrão para lembrete diário (20h)

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  static Future<void> showLimitWarning(double amount, double limit) async {
    await _notificationsPlugin.show(
      0,
      '🚨 Atenção: Limite de gastos!',
      'Você está perto do limite de R\$${limit.toStringAsFixed(2)}. Gasto atual: R\$${amount.toStringAsFixed(2)}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'limit_channel',
          'Limite de Gastos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> showDailyReminder() async {
    await _notificationsPlugin.zonedSchedule(
      1,
      '📒 Lembrete Diário',
      'Não se esqueça de registrar seus gastos hoje!',
      _nextInstanceOfHour(timeForNotification),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Lembrete Diário',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  static tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
