import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DigitalTicketController extends GetxController {
  // State Bottom Nav (Di desain ini, tab 'History' yang menyala)
  var currentIndex = 1.obs;

  // Data Mock Tiket
  final String queueNumber = 'A-15';
  final String patientName = 'Robert J. Wilson';
  final String service = 'General Consultation';
  final String dateTime = 'Tomorrow, 09:30 AM';
  final String location =
      'G&B Care Central\n4th Floor, Suite 400, Medical Plaza';

  void addToCalendar() {
    Get.snackbar(
      'Added to Calendar',
      'Jadwal berhasil ditambahkan ke kalender HP Anda.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF93F2F2),
      colorText: const Color(0xFF004F54),
    );
  }

  void shareTicket() {
    Get.snackbar(
      'Share Ticket',
      'Membuka menu bagikan...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );
  }

  void backToDashboard() {
    // Menghapus semua history halaman dan kembali ke Home
    Get.offAllNamed('/home');
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    }
    // Tambahkan rute lain jika tab lain sudah ada halamannya
  }
}
