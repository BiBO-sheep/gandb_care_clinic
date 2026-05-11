import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../api_config.dart';

/// =========================================================
/// GLOBAL SERVICE — Hidup sepanjang aplikasi berjalan.
/// Mengelola koneksi WebSocket ke Laravel Reverb dan
/// memainkan suara notifikasi di SEMUA halaman.
/// =========================================================
class ReverbService extends GetxService {
  WebSocket? _ws;
  bool _intentionalClose = false;

  // Konfigurasi Reverb (samakan dengan .env Laravel)
  static const String _reverbHost = '172.18.20.13';
  static const int _reverbPort = 8080;
  static const String _reverbKey = 'qawqx0k8yprgskbuciau';
  static const String _channelName = 'antrean-channel';

  // Reactive data yang bisa dibaca dari controller manapun
  var lastQueueNumber = ''.obs;
  var lastStatus = ''.obs;

  // Shortcut akses: ReverbService.to
  static ReverbService get to => Get.find<ReverbService>();

  /// Dipanggil dari main.dart saat inisialisasi
  Future<ReverbService> init() async {
    print('[ReverbService] Inisialisasi...');
    _connectToReverb();
    return this;
  }

  @override
  void onClose() {
    _intentionalClose = true;
    _ws?.close();
    super.onClose();
  }

  // =====================================================
  // KONEKSI KE REVERB
  // =====================================================
  Future<void> _connectToReverb() async {
    if (_intentionalClose) return;

    try {
      final url = 'ws://$_reverbHost:$_reverbPort/app/$_reverbKey';
      print('[Reverb] Menghubungkan ke: $url');

      _ws = await WebSocket.connect(url);
      print('[Reverb] TERHUBUNG!');

      // Subscribe ke channel public
      _ws!.add(jsonEncode({
        'event': 'pusher:subscribe',
        'data': {'channel': _channelName},
      }));
      print('[Reverb] Subscribe ke channel: $_channelName');

      // Dengarkan semua pesan
      _ws!.listen(
        (message) {
          print('[Reverb] RAW MESSAGE: $message');
          _handleMessage(message);
        },
        onError: (error) {
          print('[Reverb] ERROR: $error');
          if (!_intentionalClose) {
            Future.delayed(const Duration(seconds: 3), _connectToReverb);
          }
        },
        onDone: () {
          print('[Reverb] Koneksi terputus.');
          if (!_intentionalClose) {
            print('[Reverb] Reconnecting dalam 3 detik...');
            Future.delayed(const Duration(seconds: 3), _connectToReverb);
          }
        },
      );
    } catch (e) {
      print('[Reverb] GAGAL CONNECT: $e');
      if (!_intentionalClose) {
        Future.delayed(const Duration(seconds: 5), _connectToReverb);
      }
    }
  }

  // =====================================================
  // HANDLER PESAN
  // =====================================================
  void _handleMessage(dynamic rawMessage) {
    try {
      final msg = jsonDecode(rawMessage);
      final String? eventName = msg['event'];
      final String? channel = msg['channel'];

      // Skip event internal Pusher
      if (eventName == 'pusher:connection_established') {
        print('[Reverb] Socket ID: ${jsonDecode(msg['data'])['socket_id']}');
        return;
      }
      if (eventName == 'pusher_internal:subscription_succeeded') {
        print('[Reverb] BERHASIL subscribe ke: $channel');
        return;
      }

      // Event antrean masuk!
      if (channel == _channelName && eventName != null) {
        dynamic data;
        if (msg['data'] is String) {
          data = jsonDecode(msg['data']);
        } else {
          data = msg['data'];
        }

        print('[Reverb] DATA ANTREAN: $data');

        // Update reactive variables
        if (data['queue_number'] != null) {
          lastQueueNumber.value = data['queue_number'].toString();
        }
        if (data['status'] != null) {
          lastStatus.value = data['status'].toString();
        }

        // MAINKAN SUARA NOTIFIKASI (di halaman manapun!)
        _playNotificationSound();

        // Tampilkan snackbar global
        Get.snackbar(
          '🔔 Panggilan Antrean',
          'Nomor ${data['queue_number']} — Status: ${data['status']}',
          backgroundColor: Colors.teal,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.campaign, color: Colors.white),
        );
      }
    } catch (e) {
      print('[Reverb] Error parsing: $e');
    }
  }

  // =====================================================
  // AUDIO PLAYER
  // =====================================================
  Future<void> _playNotificationSound() async {
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

  /// Fungsi publik untuk test audio dari tombol speaker
  Future<void> testAudio() async {
    await _playNotificationSound();
  }
}
