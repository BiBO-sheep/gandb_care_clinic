import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controller untuk input teks
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State reaktif
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // MOCK LOGIC: Simulasi API Request ke Laravel
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'Login Berhasil',
      'Selamat datang kembali!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );

    // TODO: Navigasi ke halaman Home/Dashboard
    // Get.offAllNamed(Routes.HOME);
  }

  void loginWithGoogle() {
    Get.snackbar(
      'Info',
      'Fitur Google Sign-In segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
