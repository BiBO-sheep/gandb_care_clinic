import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan file api_config.dart ada di path yang benar
import '../../../../api_config.dart';

class LoginController extends GetxController {
  // Penangkap teks inputan
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variabel loading & hide password pakai .obs (GetX Reactive)
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Fungsi untuk tombol mata (hide/show password) di UI lu
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi untuk tombol Google (dummy sementara)
  void loginWithGoogle() {
    Get.snackbar(
      'Info',
      'Fitur Google Login akan segera hadir!',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // ==== FUNGSI API LOGIN UTAMA ====
  // Namanya 'login' menyesuaikan dengan (controller.login) di tombol UI lu
  Future<void> login() async {
    // Validasi kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Oops',
        'Email dan Password tidak boleh kosong!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true; // Nyalakan efek loading muter-muter

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['access_token'];

        // Simpan Kunci di Brankas HP
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Notif sukses
        Get.snackbar(
          'Sukses',
          'Welcome back! 🎉',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Pindah ke halaman Home
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Gagal',
          'Email atau Password salah!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak bisa terhubung ke Server. Cek IP/Sinyal!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Matikan loading
    }
  }
}
