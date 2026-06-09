import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_service.dart';
import '../../../data/providers/unauthorized_exception.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';

class ProfileController extends GetxController {
  var currentIndex = 3.obs;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userBloodType = ''.obs;
  var userAddress = ''.obs;
  var userHeight = ''.obs;
  var userWeight = ''.obs;
  var isLoading = false.obs;

  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get('profile');
      final data = jsonDecode(response.body);
      final userData = data['data'] ?? {};

      userName.value = userData['name']?.toString() ?? 'User';
      userEmail.value = userData['email']?.toString() ?? '-';
      userPhone.value = userData['phone']?.toString() ?? '-';
      userBloodType.value = userData['blood_type']?.toString() ?? '-';
      userAddress.value = userData['address']?.toString() ?? '-';
      userHeight.value = userData['height']?.toString() ?? '-';
      userWeight.value = userData['weight']?.toString() ?? '-';
    } on UnauthorizedException {
      logout(confirm: false);
    } catch (e) {
      debugPrint("ERROR PAS AMBIL DATA PROFILE: $e");
      Get.snackbar('Error Koneksi', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void logout({bool confirm = true}) {
    if (!confirm) {
      _executeLogout();
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.errorContainer.withValues(
                    alpha: 0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Get.theme.colorScheme.error,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Keluar Akun?',
                style: Get.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Anda harus login kembali untuk mengakses jadwal dan tiket pemeriksaan medis Anda.',
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(
                          color: Get.theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: Get.theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await _executeLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.colorScheme.error,
                        foregroundColor: Get.theme.colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Ya, Keluar',
                        style: Get.theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> _executeLogout() async {
    await _storage.delete(key: 'token');
    Get.offAllNamed('/login');
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (Get.isRegistered<MainLayoutController>()) {
      Get.find<MainLayoutController>().changePage(index);
      Get.until((route) => route.settings.name == '/home' || route.isFirst);
    } else {
      Get.offAllNamed('/home');
    }
  }
}
