import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class NotificationsController extends GetxController {
  var currentIndex = 2.obs;

  // State API
  var isLoading = true.obs;
  var allNotifs = [].obs;

  // State yang dikelompokkan
  var todayNotifs = [].obs;
  var earlierNotifs = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // --- FUNGSI TARIK DATA NOTIF DARI API ---
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Asumsi data array ada di data['data'] atau langsung di root
        final List fetchedData = data['data'] ?? data;

        allNotifs.value = fetchedData;
        _groupNotifications(fetchedData);
      }
    } catch (e) {
      print("🚨 ERROR AMBIL NOTIF: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIKA PENGELOMPOKAN TANGGAL ---
  void _groupNotifications(List data) {
    todayNotifs.clear();
    earlierNotifs.clear();

    DateTime now = DateTime.now();

    for (var notif in data) {
      // Ambil tanggal dari Laravel (created_at)
      DateTime notifDate = DateTime.parse(notif['created_at']).toLocal();

      // Data yang disimpen di kolom 'data' JSON Laravel
      var notifData = notif['data'];

      // Cek apakah notif ini dibuat hari ini
      bool isToday =
          notifDate.year == now.year &&
          notifDate.month == now.month &&
          notifDate.day == now.day;

      var formattedNotif = {
        'id': notif['id'],
        'title': notifData['title'] ?? 'Pemberitahuan',
        'desc': notifData['message'] ?? 'Anda memiliki pesan baru.',
        'time':
            '${notifDate.hour.toString().padLeft(2, '0')}:${notifDate.minute.toString().padLeft(2, '0')}',
        'type': notifData['type'] ?? 'info', // 'appointment', 'invoice', dll
        'isRead': notif['read_at'] != null,
      };

      if (isToday) {
        todayNotifs.add(formattedNotif);
      } else {
        earlierNotifs.add(formattedNotif);
      }
    }
  }

  // --- FUNGSI MARK ALL AS READ (TEMBAK API) ---
  Future<void> markAllAsRead() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Update UI langsung biar keliatan cepet (Optimistic UI)
      for (var i = 0; i < todayNotifs.length; i++) {
        todayNotifs[i]['isRead'] = true;
      }
      for (var i = 0; i < earlierNotifs.length; i++) {
        earlierNotifs[i]['isRead'] = true;
      }
      todayNotifs.refresh();
      earlierNotifs.refresh();

      // Tembak server buat update database
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/notifications/mark-read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      Get.snackbar(
        'Success',
        'Semua notifikasi telah ditandai sudah dibaca.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("🚨 ERROR MARK AS READ: $e");
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) Get.offAllNamed('/home');
    if (index == 1) Get.offAllNamed('/payment-history');
    if (index == 3) Get.offAllNamed('/profile'); // Pastikan profile lu nyambung
  }
}
