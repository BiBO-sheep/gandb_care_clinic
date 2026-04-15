import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Controller untuk input teks
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // State reaktif
  var selectedBloodType = ''.obs;
  var isTermsAccepted = false.obs;
  var isLoading = false.obs;

  final List<String> bloodTypes = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-',
  ];

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void selectBloodType(String type) {
    selectedBloodType.value = type;
  }

  void toggleTerms(bool? value) {
    if (value != null) isTermsAccepted.value = value;
  }

  void register() async {
    // Validasi Sederhana
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      _showError('Semua kolom teks harus diisi.');
      return;
    }
    if (selectedBloodType.value.isEmpty) {
      _showError('Pilih golongan darah Anda.');
      return;
    }
    if (!isTermsAccepted.value) {
      _showError('Anda harus menyetujui Kebijakan Privasi.');
      return;
    }

    isLoading.value = true;

    // MOCK LOGIC: Simulasi API Request ke Laravel
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'Pendaftaran Berhasil',
      'Akun pasien Anda telah dibuat!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );

    // TODO: Navigasi ke halaman Home/Dashboard
    // Get.offAllNamed(Routes.HOME);
  }

  void _showError(String message) {
    Get.snackbar(
      'Oops!',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}
