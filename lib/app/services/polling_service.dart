import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/providers/api_service.dart';

class PollingService extends GetxService {
  static PollingService get to => Get.find<PollingService>();

  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  var currentQueue = '-'.obs;
  var currentStatus = ''.obs;
  var lastUpdatedAt = ''.obs;
  var doctorName = '...'.obs;
  var clinicName = '...'.obs;
  var roomName = '...'.obs;
  var isHasActiveSession = false.obs;
  var previousQueueStatus = ''.obs;

  bool _isFirstFetch = true;

  final ApiService _apiService = ApiService();

  Future<PollingService> init() async {
    debugPrint('[PollingService] Initializing...');
    startPolling();
    return this;
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      fetchActiveQueue();
    });
    debugPrint('[PollingService] Global polling started.');
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
    debugPrint('[PollingService] Global polling stopped.');
  }

  Future<void> fetchActiveQueue() async {
    if (isClosed) return;

    try {
      final response = await _apiService.get('active-queue');
      if (isClosed) return;

      final responseData = jsonDecode(response.body);
      debugPrint("Polling API dijalankan...");
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final data = responseData['data'];

        String newStatus = data['status'] ?? '';
        String newUpdatedAt = data['updated_at'] ?? '';

        debugPrint("Status API saat ini: $newStatus");
        debugPrint("Status di HP sebelumnya: ${previousQueueStatus.value}");

        bool isCheckIn = newStatus == 'check_in';
        bool isStatusChanged = previousQueueStatus.value != 'check_in';
        bool isUpdatedPanggilUlang = previousQueueStatus.value == 'check_in' &&
            newUpdatedAt != lastUpdatedAt.value;

        if (isCheckIn && (isStatusChanged || isUpdatedPanggilUlang)) {
          if (!_isFirstFetch && !isClosed) {
            debugPrint('[PollingService] TRIGGERING AUDIO!');
            playNotificationSound();

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
              debugPrint('[PollingService] Snackbar error: $e');
            }
          }
        }

        if (isClosed) return;

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
    } catch (e) {
      debugPrint('[PollingService] Error: $e');
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
      debugPrint("[PollingService] Error Audio: $e");
    }
  }

  @override
  void onClose() {
    stopPolling();
    _audioPlayer.dispose();
    super.onClose();
  }
}

