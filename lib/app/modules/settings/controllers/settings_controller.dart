import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';
import '../../profile/controllers/profile_controller.dart';

class SettingsController extends GetxController {
  // --- EXPOSE PROFILE CONTROLLER BIAR BISA DIBACA DI VIEW ---
  final profileCtrl = Get.find<ProfileController>();

  // --- FORM CONTROLLERS ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // --- STATE ---
  var appointmentReminders = true.obs;
  var labResultAlerts = true.obs;
  var wellnessTips = false.obs;
  var biometricLogin = true.obs;
  var isLoading = false.obs;

  // 👇 STATE BARU BUAT DARK MODE 👇
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load data awal dari ProfileController
    nameController.text = profileCtrl.userName.value;
    emailController.text = profileCtrl.userEmail.value;
    phoneController.text = profileCtrl.userPhone.value;

    // Cek apakah HP user lagi pake dark mode pas aplikasi dibuka
    isDarkMode.value = Get.isDarkMode;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // --- FUNGSI DARK MODE SAKTI GETX ---
  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    if (value) {
      Get.changeThemeMode(ThemeMode.dark); // Ubah ke Gelap
    } else {
      Get.changeThemeMode(ThemeMode.light); // Ubah ke Terang
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/profile/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh data di ProfileController biar langsung berubah di semua halaman
        await profileCtrl.fetchUserProfile();

        Get.snackbar(
          'Sukses',
          'Profil berhasil diperbarui!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan koneksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI KLIK ---
  void toggleAppointment(bool value) => appointmentReminders.value = value;
  void toggleLabResults(bool value) => labResultAlerts.value = value;
  void toggleWellnessTips(bool value) => wellnessTips.value = value;
  void toggleBiometric(bool value) => biometricLogin.value = value;

  void changePassword() {
    Get.snackbar('Security', 'Membuka halaman ubah password...');
  }

  void openPrivacyPolicy() {
    Get.snackbar('Legal', 'Membuka Kebijakan Privasi...');
  }

  void openTerms() {
    Get.snackbar('Legal', 'Membuka Syarat & Ketentuan...');
  }

  void signOut() {
    Get.defaultDialog(
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      textConfirm: 'Yes, Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A),
      onConfirm: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Get.offAllNamed('/login');
      },
    );
  }
}
