import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Tab Profile yang aktif (Index 3)
  var currentIndex = 3.obs;

  // --- DATA MOCKUP (Nanti diisi dari response API Laravel/PHP) ---
  var patientName = 'Robert J. Wilson'.obs;
  var patientId = 'GB-10023'.obs;
  var email = 'robert.wilson@email.com'.obs;
  var phone = '+1 (555) 123-4567'.obs;
  var address = '482 Oakwood Drive, Apt 4B\nMaplewood, NJ 07040'.obs;

  var bloodType = 'O+'.obs;
  var emergencyContactName = 'Sarah Wilson (Wife)'.obs;
  var emergencyContactPhone = '+1 (555) 987-6543'.obs;

  // --- FUNGSI TOMBOL ---
  void editProfile() {
    Get.snackbar(
      'Edit Profile',
      'Membuka form edit profil...',
      snackPosition: SnackPosition.TOP,
    );
  }

  void openSettings() {
    Get.snackbar(
      'Settings',
      'Membuka pengaturan aplikasi...',
      snackPosition: SnackPosition.TOP,
    );
    Get.toNamed('/settings');
  }

  void openSecurity() {
    Get.snackbar(
      'Security',
      'Membuka pengaturan keamanan...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openPrivacyPolicy() {
    Get.snackbar(
      'Privacy Policy',
      'Membuka kebijakan privasi...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void logout() {
    // Simulasi proses logout
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to log out?',
      textConfirm: 'Yes, Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A), // Error color
      onConfirm: () {
        // Hapus session/token di sini nantinya
        Get.offAllNamed('/login'); // Kembali ke halaman Login
      },
    );
  }

  // --- NAVIGASI BAWAH ---
  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    } else if (index == 1) {
      Get.offAllNamed('/payment-history');
    } else if (index == 2) {
      Get.offAllNamed('/notifications');
    }
    // Index 3 adalah halaman ini sendiri
  }
}
