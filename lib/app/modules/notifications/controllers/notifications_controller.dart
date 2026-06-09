import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';
import '../../../data/providers/unauthorized_exception.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';

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
    } on UnauthorizedException {
      Get.offAllNamed('/login');
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
        'Berhasil',
        'Semua notifikasi telah ditandai sudah dibaca.',
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.check_circle, color: Get.theme.colorScheme.primary),
        borderRadius: 16,
      );
    } on UnauthorizedException {
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint("🚨 ERROR MARK AS READ: $e");
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (Get.isRegistered<MainLayoutController>()) {
      Get.find<MainLayoutController>().changePage(index);
      Get.until((route) => route.settings.name == '/home' || route.isFirst);
    } else {
      Get.offAllNamed('/home');
    }
  }
}
