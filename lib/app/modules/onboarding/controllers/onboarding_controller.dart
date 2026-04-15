import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_service.dart';

class OnboardingController extends GetxController {
  // Observables untuk state loading
  var isLoading = false.obs;

  // Instance API (di-comment sementara sampai backend siap)
  // final ApiService _apiService = ApiService();

  // Fungsi saat tombol "Get Started" ditekan
  void onGetStartedPressed() async {
    isLoading.value = true;

    // MOCK LOGIC: Simulasi loading selama 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));

    isLoading.value = false;

    // Menampilkan pesan sukses
    Get.snackbar(
      'Siap Memulai!',
      'Fitur Get Started berfungsi. Mengarahkan ke halaman registrasi...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006A6A), // Secondary color
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(16),
    );

    // TODO: Buka komentar di bawah ini jika halaman pendaftaran sudah dibuat
    // Get.toNamed(Routes.REGISTER);
  }

  // Fungsi saat "Log In" ditekan
  void goToLogin() {
    Get.toNamed('/login');
    // Get.toNamed(Routes.LOGIN);
  }
}
