  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class RegisterController extends GetxController {
  // Controller untuk input teks
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State reaktif
  var selectedBloodType = ''.obs;
  var isTermsAccepted = false.obs;
  var isPasswordVisible = false.obs;
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
    passwordController.dispose();
    super.onClose();
  }

  void selectBloodType(String type) {
    selectedBloodType.value = type;
  }

  void toggleTerms(bool? value) {
    if (value != null) isTermsAccepted.value = value;
  }

  Future<void> register() async {
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

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'blood_type': selectedBloodType.value,
          'password': passwordController.text,
        }),
      );

      print('Register Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['access_token'] ?? data['token'];

        // Simpan Token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.snackbar(
          'Pendaftaran Berhasil',
          'Akun pasien Anda telah dibuat!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF006A6A),
          colorText: Colors.white,
        );

        // Ke Home
        Get.offAllNamed('/home');
      } else {
        final data = jsonDecode(response.body);
        _showError(data['message'] ?? 'Gagal melakukan pendaftaran.');
      }
    } catch (e) {
      print('Register Error: $e');
      _showError('Terjadi kesalahan koneksi.');
    } finally {
      isLoading.value = false;
    }
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
