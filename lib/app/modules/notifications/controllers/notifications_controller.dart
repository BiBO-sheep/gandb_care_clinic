import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';

class NotificationsController extends GetxController {
  var currentIndex = 2.obs;

  var isLoading = true.obs;
  var allNotifs = [].obs;

  var todayNotifs = [].obs;
  var earlierNotifs = [].obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.get('notifications');
      final data = jsonDecode(response.body);
      final List fetchedData = data['data'] ?? data;

      allNotifs.value = fetchedData;
      _groupNotifications(fetchedData);
    } catch (e) {
      debugPrint("🚨 ERROR AMBIL NOTIF: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _groupNotifications(List data) {
    todayNotifs.clear();
    earlierNotifs.clear();

    DateTime now = DateTime.now();

    for (var notif in data) {
      DateTime notifDate = DateTime.parse(notif['created_at']).toLocal();
      var notifData = notif['data'];

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
        'type': notifData['type'] ?? 'info',
        'isRead': notif['read_at'] != null,
      };

      if (isToday) {
        todayNotifs.add(formattedNotif);
      } else {
        earlierNotifs.add(formattedNotif);
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      for (var i = 0; i < todayNotifs.length; i++) {
        todayNotifs[i]['isRead'] = true;
      }
      for (var i = 0; i < earlierNotifs.length; i++) {
        earlierNotifs[i]['isRead'] = true;
      }
      todayNotifs.refresh();
      earlierNotifs.refresh();

      await _apiService.post('notifications/mark-read');

      Get.snackbar(
        'Success',
        'Semua notifikasi telah ditandai sudah dibaca.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint("🚨 ERROR MARK AS READ: $e");
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) Get.offAllNamed('/home');
    if (index == 1) Get.offAllNamed('/payment-history');
    if (index == 3) Get.offAllNamed('/profile');
  }
}

