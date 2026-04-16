import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamResultsController extends GetxController {
  // Tab History yang aktif (Index 1)
  var currentIndex = 1.obs;

  void backToHistory() {
    Get.back(); // Kembali ke halaman sebelumnya
  }

  void messageDoctor() {
    Get.snackbar(
      'Membuka Chat',
      'Memulai obrolan aman dengan Dr. Julian Thorne...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );
  }

  void reschedule() {
    Get.snackbar(
      'Reschedule',
      'Mengarahkan ke kalender jadwal dokter...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFF7F50),
      colorText: Colors.white,
    );
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    }
    // Nanti bisa diarahkan ke halaman lain sesuai index
  }
}
