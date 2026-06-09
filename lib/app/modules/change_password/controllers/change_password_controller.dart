import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();

  void toggleOldPassword() => isOldPasswordVisible.value = !isOldPasswordVisible.value;
  void toggleNewPassword() => isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPassword() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> submitChangePassword() async {
    if (oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      AppSnackbar.error('Error', 'Semua kolom wajib diisi.');
      return;
    }

    if (newPasswordController.text.length < 8) {
      AppSnackbar.error('Error', 'Kata sandi baru minimal 8 karakter.');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      AppSnackbar.error('Error', 'Konfirmasi kata sandi tidak cocok.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.post('profile/change-password', body: {
        'old_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
        'new_password_confirmation': confirmPasswordController.text,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppSnackbar.success('Berhasil', data['message'] ?? 'Kata sandi berhasil diperbarui.');
        Get.back();
      } else {
        AppSnackbar.error('Gagal', data['message'] ?? 'Kata sandi lama salah atau gagal memperbarui.');
      }
    } catch (e) {
      AppSnackbar.error('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
