import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  // Tab Notifications yang aktif (Index 2)
  var currentIndex = 2.obs;

  // Data Notifikasi (Dibuat observable agar reaktif saat di-mark as read)
  var todayNotifs = [
    {
      'title': 'Appointment Reminder',
      'time': '09:12 AM',
      'desc':
          'Your appointment for General Consultation is tomorrow at 09:30 AM.',
      'icon': Icons.calendar_month,
      'color': const Color(0xFFA43C12), // primary
      'bgColor': const Color(0xFFFFDBCF), // primary-fixed
      'isRead': false,
    },
    {
      'title': 'Lab Results Available',
      'time': '08:05 AM',
      'desc':
          'Your blood panel screening results are now available for review in the dashboard.',
      'icon': Icons.description,
      'color': const Color(0xFF006A6A), // secondary
      'bgColor': const Color(
        0xFF90EFEF,
      ).withOpacity(0.5), // secondary-container
      'isRead': false,
    },
  ].obs;

  var yesterdayNotifs = [
    {
      'title': 'Clinic Update',
      'time': 'Yesterday',
      'desc':
          'G&B Care Clinic is now open on Sundays from 10:00 AM to 04:00 PM for urgent care.',
      'icon': Icons.campaign,
      'color': const Color(0xFF006970), // tertiary
      'bgColor': const Color(0xFF7AF4FF).withOpacity(0.3),
      'isRead': true,
    },
  ].obs;

  var earlierNotifs = [
    {
      'title': 'System Maintenance',
      'time': '3 days ago',
      'desc':
          'We have successfully updated our billing portal for a smoother experience.',
      'icon': Icons.notifications,
      'color': const Color(0xFF8B7169), // outline
      'bgColor': const Color(0xFFE9E8E5), // surface-container-high
      'isRead': true,
    },
  ].obs;

  void markAllAsRead() {
    for (var i = 0; i < todayNotifs.length; i++) {
      var notif = todayNotifs[i];
      notif['isRead'] = true;
      todayNotifs[i] = notif; // Trigger update untuk Obx
    }
    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF90EFEF),
      colorText: const Color(0xFF006A6A),
    );
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    } else if (index == 1) {
      Get.offAllNamed('/payment-history');
    }
    // Index 2 adalah halaman ini sendiri, tidak perlu navigasi
  }
}
