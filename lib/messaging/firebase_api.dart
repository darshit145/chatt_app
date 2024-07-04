import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission();

    // Get the FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    print("Token: $fcmToken");

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Initialize local notifications
    await _initLocalNotification();

    // Set up push notifications
    await _initPushNotification();
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          navigatorKey.currentState?.pushNamed(
            '/notification_page',
            arguments: notificationResponse.payload,
          );
        }
      },
    );
  }

  void handleMessage(RemoteMessage? msg) {
    if (msg == null) return;

    final notification = msg.notification;
    final data = msg.data;

    if (notification != null) {
      _showNotification(notification);
    }

    navigatorKey.currentState?.pushNamed(
      '/notification_page',
      arguments: data,
    );
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    Utils obj=Utils();
    final largIconPath=await obj.downloadFile(
      "https://i.pinimg.com/originals/c3/01/f9/c301f9ecc779f60d0c3c9c8f567b7503.jpg",
      "ok"
    );
    final bigPicturePath= await  obj.downloadFile(
      "https://i.pinimg.com/originals/c3/01/f9/c301f9ecc779f60d0c3c9c8f567b7503.jpg",
      "largicon"
    );
    final styleInfo=BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      contentTitle: "content title",
      largeIcon: FilePathAndroidBitmap(largIconPath)
    );
     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      styleInformation: styleInfo,
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );
     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.body,
    );
  }

  Future<void> _initPushNotification() async {
    // Set notification options for foreground notifications
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle initial message when the app is launched from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen(handleMessage);

    // Handle messages when the app is brought to the foreground from the background
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }
}

// Background message handler
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // You can perform additional tasks here, like updating the UI or showing a notification
}


class Utils{
    Future<String> downloadFile(String url,String fileName) async {
    final directory=await getApplicationDocumentsDirectory();
    final filePath="${directory.path}/${fileName}";
    final response=await http.get(Uri.parse(url));
    final file=File(filePath);
    await file.writeAsBytes(response.bodyBytes);//issue Here
    return filePath;

  }
}

