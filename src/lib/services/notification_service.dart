import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static int timeForNotification = 20; // Horário padrão para lembrete diário (20h)

  static Future<void> initialize() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _notificationsPlugin.initialize(initializationSettings);
      tz.initializeTimeZones();
    } catch (e, s) {
      debugPrint('Erro ao inicializar notificações: $e\n$s');
    }
  }

  static Future<void> showLimitWarning(double amount, double limit) async {
    try {
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
    } catch (e, s) {
      debugPrint('Erro ao exibir notificação de limite: $e\n$s');
    }
  }

  static Future<void> showDailyReminder() async {
    try {
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
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    } catch (e, s) {
      debugPrint('Erro ao agendar lembrete diário: $e\n$s');
    }
  }

  static tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> showNotification({required String title, required String body}) async {
    try {
      await _notificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e, s) {
      debugPrint('Erro ao exibir notificação: $e\n$s');
    }
  }
}
