import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_service.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../services/theme_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final profileCtrl = Get.find<ProfileController>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  var appointmentReminders = true.obs;
  var labResultAlerts = true.obs;
  var wellnessTips = false.obs;
  var biometricLogin = true.obs;
  var isLoading = false.obs;

  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = profileCtrl.userName.value;
    emailController.text = profileCtrl.userEmail.value;
    phoneController.text = profileCtrl.userPhone.value;
    isDarkMode.value = ThemeService.to.theme == ThemeMode.dark;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    Get.find<ThemeService>().switchTheme();
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final response = await _apiService.put('profile/update', body: {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      });

      if (response.statusCode == 200) {
        await profileCtrl.fetchUserProfile();
        AppSnackbar.success('Profil Diperbarui', 'Data profil Anda berhasil disimpan.');
      } else {
        final data = jsonDecode(response.body);
        AppSnackbar.error('Pembaruan Gagal', data['message'] ?? 'Terjadi kesalahan.');
      }
    } catch (e) {
      AppSnackbar.error('Terjadi Kesalahan', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAppointment(bool value) => appointmentReminders.value = value;
  void toggleLabResults(bool value) => labResultAlerts.value = value;
  void toggleWellnessTips(bool value) => wellnessTips.value = value;
  void toggleBiometric(bool value) => biometricLogin.value = value;

  void changePassword() => AppSnackbar.info('Keamanan', 'Fitur ubah kata sandi segera hadir.');
  void openPrivacyPolicy() => AppSnackbar.info('Legal', 'Membuka Kebijakan Privasi...');
  void openTerms() => AppSnackbar.info('Legal', 'Membuka Syarat & Ketentuan...');

  void signOut() {
    Get.defaultDialog(
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      textConfirm: 'Yes, Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A),
      onConfirm: () async {
        await _storage.delete(key: 'token');
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}

