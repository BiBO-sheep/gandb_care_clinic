import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/providers/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  var isLoading = false.obs;
  var isGoogleLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isGoogleLoading.value = false;
        return;
      }

      final response = await _apiService.post('auth/google', body: {
        'email': googleUser.email,
        'name': googleUser.displayName ?? '',
        'google_id': googleUser.id,
      });

      final data = jsonDecode(response.body);
      String token = data['access_token'];

      await _storage.write(key: 'token', value: token);

      AppSnackbar.success('Login Berhasil', 'Selamat datang kembali.');

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      AppSnackbar.error('Login Gagal', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppSnackbar.warning('Form Tidak Lengkap', 'Email dan kata sandi tidak boleh kosong.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiService.post('login', body: {
        'email': emailController.text,
        'password': passwordController.text,
      });

      final data = jsonDecode(response.body);
      String token = data['access_token'];

      await _storage.write(key: 'token', value: token);

      AppSnackbar.success('Login Berhasil', 'Selamat datang kembali.');

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      AppSnackbar.error('Login Gagal', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
