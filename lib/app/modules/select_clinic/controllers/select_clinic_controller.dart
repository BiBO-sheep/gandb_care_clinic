import 'dart:ui';

import 'package:get/get.dart';

class SelectClinicController extends GetxController {
  // Fungsi ketika salah satu Poli dipilih
  void onClinicSelected(String clinicName) {
    Get.snackbar(
      'Poli Dipilih',
      'Anda memilih $clinicName. Mengarahkan ke jadwal dokter...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006A6A),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 2),
    );
    // TODO: Navigasi ke halaman pemilihan Jadwal/Dokter
    Get.toNamed('/select-time', arguments: clinicName);
  }

  // Fungsi untuk tombol Call Center
  void callCenter() {
    Get.snackbar(
      'Menghubungi...',
      'Membuka aplikasi telepon untuk menghubungi Call Center.',
      snackPosition: SnackPosition.TOP,
    );
  }
}
