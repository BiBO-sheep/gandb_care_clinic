import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DigitalPrescriptionController extends GetxController {
  // Tab History yang aktif (Index 1)
  var currentIndex = 1.obs;
  var isRequesting = false.obs;

  void requestMedication() async {
    isRequesting.value = true;

    // Simulasi proses request
    await Future.delayed(const Duration(seconds: 2));

    isRequesting.value = false;

    Get.snackbar(
      'Permintaan Terkirim!',
      'Resep Anda sedang disiapkan oleh Farmasi. Kami akan mengabari jika sudah siap diambil/dikirim.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    } else if (index == 1) {
      Get.offAllNamed('/exam-results'); // Bisa disesuaikan
    }
  }
}
