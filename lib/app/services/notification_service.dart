import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/providers/api_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer(); // Inisialisasi AudioPlayer

  static const String channelId = 'hospital_call_channel_v2';
  static const String channelName = 'Panggilan Antrean';
  static const String channelDescription = 'Notifikasi saat antrean dipanggil';
  static const String customSound = 'tingtung'; 

  Future<NotificationService> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Request permission without blocking init
    _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    ).then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      }
    });

    // Ambil FCM Token dan coba kirim ke backend (akan berhasil jika user sudah login)
    _fcm.getToken().then((token) {
      debugPrint("FCM Token: $token");
      sendFcmToken(); // Sync token at startup
    });

    _initLocalNotifications();

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
        
        // Memainkan audio dari assets menggunakan AudioPlayer (Sesuai logic asli Anda)
        try {
          await _audioPlayer.play(AssetSource('audio/tingtung.mp3'));
        } catch (e) {
          debugPrint('Error playing audio: $e');
        }
      }
    });

    return this;
  }

  void _initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _localNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Create custom channel
    _createNotificationChannel();
  }

  void _createNotificationChannel() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(customSound),
      playSound: true,
      enableVibration: true,
    );

    _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(customSound),
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    _localNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: notificationDetails,
    );
  }

  /// Dipanggil setelah user login berhasil agar Bearer token sudah tersedia
  Future<void> sendFcmToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        final apiService = ApiService();
        await apiService.post('profile/update-fcm-token', body: {
          'fcm_token': token,
        });
        debugPrint("FCM Token berhasil dikirim ke backend: $token");
      }
    } catch (e) {
      debugPrint("Gagal mengirim FCM token: $e");
    }
  }
}
