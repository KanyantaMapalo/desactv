import 'dart:io';

import 'package:desactvapp3/services/notification_service_firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future initialize() async {
    if (Platform.isIOS) {
      // Request permission for iOS devices
      await _firebaseMessaging.requestPermission();
    }

    // Configure Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Configure Firebase Messaging foreground callbacks
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages here
      _handleMessage(message);
    });

    // Configure Firebase Messaging when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background or terminated messages here
      _handleMessage(message);
    });
  }

  // Handle messages received in the background or when the app is terminated
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    _handleMessage(message);
  }

  // Handle foreground messages
  void _handleMessage(RemoteMessage message) {
    // Display the notification using the NotificationService
    NotificationServiceFirebase().showNotification(message);
  }
}
