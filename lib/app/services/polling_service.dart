import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_config.dart';

class PollingService extends GetxService {
  static PollingService get to => Get.find<PollingService>();

  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Reactive variables shared across the app
  var currentQueue = '-'.obs;
  var currentStatus = ''.obs;
  var lastUpdatedAt = ''.obs;
  var doctorName = '...'.obs;
  var clinicName = '...'.obs;
  var roomName = '...'.obs;
  var isHasActiveSession = false.obs;
  var previousQueueStatus = ''.obs;

  bool _isFirstFetch = true;

  Future<PollingService> init() async {
    print('[PollingService] Initializing...');
    startPolling();
    return this;
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Jangan fetch kalau service sudah di-close (hot restart)
      if (isClosed) {
        timer.cancel();
        return;
      }
      fetchActiveQueue();
    });
    print('[PollingService] Global polling started.');
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
    print('[PollingService] Global polling stopped.');
  }

  Future<void> fetchActiveQueue() async {
    // Keluar lebih awal kalau service sudah di-dispose
    if (isClosed) return;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (isClosed) return; // cek lagi setelah await

      String? token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/active-queue'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (isClosed) return; // cek lagi setelah HTTP selesai

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Polling API dijalankan...");
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final data = responseData['data'];

          String newStatus = data['status'] ?? '';
          String newUpdatedAt = data['updated_at'] ?? '';

          print("Status API saat ini: $newStatus");
          print("Status di HP sebelumnya: ${previousQueueStatus.value}");

          // LOGIKA AUDIO GLOBAL
          bool isCheckIn = newStatus == 'check_in';
          bool isStatusChanged = previousQueueStatus.value != 'check_in';
          bool isUpdatedPanggilUlang = previousQueueStatus.value == 'check_in' &&
              newUpdatedAt != lastUpdatedAt.value;

          if (isCheckIn && (isStatusChanged || isUpdatedPanggilUlang)) {
            if (!_isFirstFetch && !isClosed) {
              print('[PollingService] TRIGGERING AUDIO!');
              playNotificationSound();

              // Cek overlayContext sebelum tampil snackbar
              try {
                if (!isClosed && Get.overlayContext != null) {
                  Get.snackbar(
                    '🔔 PANGGILAN ANTREAN',
                    'Nomor ${data['queue_number']} silakan menuju ke ${data['poli']?['ruangan'] ?? 'ruangan'}.',
                    backgroundColor: Colors.teal,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 6),
                    snackPosition: SnackPosition.TOP,
                    icon: const Icon(Icons.campaign, color: Colors.white),
                    margin: const EdgeInsets.all(12),
                  );
                }
              } catch (e) {
                print('[PollingService] Snackbar error: $e');
              }
            }
          }

          if (isClosed) return; // guard sebelum update state

          // Update reactive variables
          currentQueue.value = data['queue_number'] ?? '-';
          currentStatus.value = newStatus;
          lastUpdatedAt.value = newUpdatedAt;
          doctorName.value = data['dokter']?['name'] ?? 'Dokter';
          clinicName.value = data['poli']?['name'] ?? 'Klinik';
          roomName.value = data['poli']?['ruangan'] ?? '-';
          isHasActiveSession.value = true;

          previousQueueStatus.value = newStatus;
          _isFirstFetch = false;
        } else {
          if (!isClosed) isHasActiveSession.value = false;
        }
      }
    } catch (e) {
      print('[PollingService] Error: $e');
    }
  }

  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource('audio/tingtung.mp3'),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      print("[PollingService] Error Audio: $e");
    }
  }

  @override
  void onClose() {
    stopPolling();
    _audioPlayer.dispose();
    super.onClose();
  }
}
