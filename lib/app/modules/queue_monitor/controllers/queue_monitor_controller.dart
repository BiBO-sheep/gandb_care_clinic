import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class QueueMonitorController extends GetxController {
  // --- Reactive Variables ---
  var currentQueue = '-'.obs;
  var currentStatus = ''.obs;
  var estimatedWait = '0'.obs;
  var isHasActiveSession = false.obs;

  // Data detail tambahan
  var doctorName = 'Loading...'.obs;
  var clinicName = 'Loading...'.obs;
  var roomName = '...'.obs;
  var myQueueNumber = '...'.obs;
  var nowServing = '...'.obs;

  var isLoading = true.obs;
  var currentIndex = 0.obs;

  // --- Polling Variables ---
  Timer? _pollingTimer;
  var previousStatus = ''.obs;
  bool _isFirstFetch = true;

  @override
  void onInit() {
    super.onInit();
    fetchActiveQueue();
    startPolling();
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }

  // =====================================================
  // POLLING
  // =====================================================
  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchActiveQueue();
    });
    print('[QueueMonitor] Polling dimulai setiap 3 detik.');
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    print('[QueueMonitor] Polling dihentikan.');
  }

  // =====================================================
  // FETCH DATA API
  // =====================================================
  Future<void> fetchActiveQueue() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/active-queue'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Response Data: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final data = responseData['data'];

          // ✅ LOGIKA AUDIO: Cek perubahan status ke 'check_in'
          String newStatus = data['status'] ?? '';

          if (newStatus == 'check_in' && previousStatus.value != 'check_in') {
            // Hanya bunyikan audio jika BUKAN fetch pertama kali
            if (!_isFirstFetch) {
              testAudio(); // Panggil fungsi bunyi Ting-Tung
              Get.snackbar(
                'Giliran Anda!',
                'Silakan masuk ke ruangan.',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.all(12),
                borderRadius: 12,
                icon: const Icon(Icons.campaign, color: Colors.white),
              );
            }
          }

          // Setelah fetch pertama selesai, set flag jadi false
          _isFirstFetch = false;

          // Update status UI dan previousStatus
          currentStatus.value = newStatus;
          previousStatus.value = newStatus;
          currentQueue.value = data['queue_number'] ?? '-';

          isHasActiveSession.value = true;
          myQueueNumber.value = data['queue_number'] ?? '-';

          doctorName.value = data['dokter']?['name'] ?? 'Dokter Klinik';
          clinicName.value = data['poli']?['name'] ?? 'Poli Umum';
          roomName.value = data['poli']?['ruangan'] ?? 'Ruang Klinik';

          int diff = (data['queue_diff'] ?? 0);
          estimatedWait.value = (diff * 10).toString();
        } else {
          isHasActiveSession.value = false;
        }
      } else {
        isHasActiveSession.value = false;
      }
    } catch (e) {
      print("[QueueMonitor] Error fetch: $e");
      isHasActiveSession.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // NAVIGASI & UTILITAS
  // =====================================================
  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) Get.offAllNamed('/home');
    else if (index == 1) Get.toNamed('/payment-history');
    else if (index == 2) Get.toNamed('/notifications');
    else if (index == 3) Get.toNamed('/profile');
  }

  void openQRScanner() {
    Get.snackbar('Info', 'Fitur Scan QR dinonaktifkan. Gunakan monitor antrean.');
  }

  // =====================================================
  // AUDIO PLAYER (lokal, tidak bergantung ReverbService)
  // =====================================================
  Future<void> testAudio() async {
    try {
      print("Mencoba memutar audio...");
      final player = AudioPlayer();
      await player.play(AssetSource('audio/tingtung.mp3'));
      print("Audio berhasil diputar!");
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print("ERROR AUDIO: $e");
    }
  }
}
