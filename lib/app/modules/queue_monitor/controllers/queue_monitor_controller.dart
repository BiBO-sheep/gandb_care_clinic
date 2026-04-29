import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../../api_config.dart';

class QueueMonitorController extends GetxController {
  // --- Reactive Variables sesuai request ---
  var currentQueue = '-'.obs;
  var currentStatus = ''.obs; // check-in, pre-screen, waiting, consult
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

  final AudioPlayer _audioPlayer = AudioPlayer();
  Echo? echo;

  @override
  void onInit() {
    super.onInit();
    fetchActiveQueue();
    initWebSocket();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    echo?.disconnect();
    super.onClose();
  }

  // TUGAS 2: Fetch data asli dari API Laravel
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

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final data = responseData['data'];
          
          isHasActiveSession.value = true;
          currentQueue.value = data['queue_number'] ?? '-';
          currentStatus.value = data['status'] ?? 'waiting';
          myQueueNumber.value = data['queue_number'] ?? '-';
          
          // Detail tambahan
          doctorName.value = data['dokter']?['name'] ?? 'Dokter Klinik';
          clinicName.value = data['poli']?['name'] ?? 'Poli Umum';
          roomName.value = data['poli']?['ruangan'] ?? 'Ruang Klinik';
          
          // Hitung estimasi (contoh sederhana)
          int diff = (data['queue_diff'] ?? 0);
          estimatedWait.value = (diff * 10).toString();
        } else {
          isHasActiveSession.value = false;
        }
      } else {
        isHasActiveSession.value = false;
      }
    } catch (e) {
      print("[QueueMonitorController] Error fetch: $e");
      isHasActiveSession.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // TUGAS 3: Implementasi WebSockets & Audio Player
  void initWebSocket() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Konfigurasi Pusher Client
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      
      echo = Echo(
        client: pusher,
        broadcaster: EchoBroadcaster.pusher,
        options: {
          'key': 'GNB_CARE_KEY', // Ganti dengan key Pusher kamu
          'cluster': 'mt1',
          'authEndpoint': '${ApiConfig.baseUrl}/broadcasting/auth',
          'auth': {
            'headers': {
              'Authorization': 'Bearer $token',
            }
          },
        },
      );

      // Listen ke channel public 'antrean'
      echo!.channel('antrean').listen('AntreanDiupdate', (event) async {
        print("[WebSocket] Event Received: $event");
        
        // Cek apakah ini giliran pasien ini (status berubah menjadi check_in)
        if (event['status'] == 'check_in' && event['queue_number'] == currentQueue.value) {
          // Play Sound
          await _audioPlayer.play(AssetSource('audio/tingtung.mp3'));
          
          // Show Snackbar
          Get.snackbar(
            'Giliran Anda!', 
            'Silakan menuju ke ${roomName.value} sekarang.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
          );
        }
        
        // Refresh data
        fetchActiveQueue();
      });

    } catch (e) {
      print("[WebSocket] Error: $e");
    }
  }

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
}
