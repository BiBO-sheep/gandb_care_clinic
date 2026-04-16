import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // --- STATE UNTUK TOGGLES (SWITCH) ---
  var appointmentReminders = true.obs;
  var labResultAlerts = true.obs;
  var wellnessTips = false.obs;
  var biometricLogin = true.obs;

  // --- FUNGSI KLIK ---
  void toggleAppointment(bool value) => appointmentReminders.value = value;
  void toggleLabResults(bool value) => labResultAlerts.value = value;
  void toggleWellnessTips(bool value) => wellnessTips.value = value;
  void toggleBiometric(bool value) => biometricLogin.value = value;

  void changePassword() {
    Get.snackbar(
      'Security',
      'Membuka halaman ubah password...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openPrivacyPolicy() {
    Get.snackbar(
      'Legal',
      'Membuka Kebijakan Privasi...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openTerms() {
    Get.snackbar(
      'Legal',
      'Membuka Syarat & Ketentuan...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signOut() {
    Get.defaultDialog(
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      textConfirm: 'Yes, Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A), // Error color
      onConfirm: () {
        Get.offAllNamed('/login'); // Kembali ke halaman Login
      },
    );
  }
}
