import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
     AndroidInitializationSettings initializationSettingsAndroid =
     const   AndroidInitializationSettings('@mipmap/balony');

    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            //    iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    ); // onSelectNotification: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
    const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> scheduleNotifications(int id, String names, DateTime now) async {
    int days = id % 100;
    days-=now.day;

    int hours = 10 - now.hour;
    if (hours < 0) {
      days -=1;
      hours += 24;
    }
    
    int minutes = 60-now.minute;
    if(minutes<0){
      minutes-=60;
      hours-=1;
    }


    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "Dziś imieniny ma",
        names,
        tz.TZDateTime.now(tz.local).add(Duration(days: days,hours: hours,minutes: minutes)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

Future selectNotification(String payload) async {
  //handle your logic here
}
