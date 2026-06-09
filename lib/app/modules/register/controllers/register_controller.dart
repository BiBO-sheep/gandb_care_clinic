import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/providers/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  var selectedBloodType = ''.obs;
  var isTermsAccepted = false.obs;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isGoogleLoading = false.obs;

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
    passwordController.dispose();
    super.onClose();
  }

  void selectBloodType(String type) {
    selectedBloodType.value = type;
  }

  void toggleTerms(bool? value) {
    if (value != null) isTermsAccepted.value = value;
  }

  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isGoogleLoading.value = false;
        return;
      }

      final response = await _apiService.post(
        'auth/google',
        body: {
          'email': googleUser.email,
          'name': googleUser.displayName ?? '',
          'google_id': googleUser.id,
        },
      );

      final data = jsonDecode(response.body);
      String token = data['access_token'];

      await _storage.write(key: 'token', value: token);

      AppSnackbar.success('Login Berhasil', 'Selamat datang.');

      final userData = data['data'];
      if (userData['phone'] == null ||
          userData['phone'].toString().isEmpty ||
          userData['address'] == null ||
          userData['address'].toString().isEmpty) {
        Get.offAllNamed(Routes.COMPLETE_PROFILE);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> register() async {
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

    try {
      final response = await _apiService.post(
        'register',
        body: {
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'blood_type': selectedBloodType.value,
          'password': passwordController.text,
        },
      );

      final data = jsonDecode(response.body);
      String token = data['access_token'] ?? data['token'];

      await _storage.write(key: 'token', value: token);

      AppSnackbar.success(
        'Pendaftaran Berhasil',
        'Akun pasien Anda telah dibuat.',
      );

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    AppSnackbar.error('Terjadi Kesalahan', message);
  }
}
