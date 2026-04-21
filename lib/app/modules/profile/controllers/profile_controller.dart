import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class ProfileController extends GetxController {
  // Tab Profile yang aktif (Index 3)
  var currentIndex = 3.obs;

  // --- DATA REAKTIF ---
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userBloodType = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true; // 1. Set loading nyala

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Sesi Habis',
          'Silakan login kembali',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status Code API Profile: ${response.statusCode}');
      print('Response API Profile: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Tameng: Pastikan userData jadi map kosong '{}' kalau server ngirim null
        // Biar nggak error pas dipanggil userData['name']
        final userData = data['data'] ?? {};

        userName.value = userData['name']?.toString() ?? 'User';
        userEmail.value = userData['email']?.toString() ?? '-';
        userPhone.value = userData['phone']?.toString() ?? '-';
        userBloodType.value = userData['blood_type']?.toString() ?? '-';
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Error Autentikasi',
          'Sesi Anda telah berakhir, silakan login ulang.',
        );
        logout();
      } else {
        Get.snackbar(
          'Error Server',
          'Gagal memuat profil (Kode: ${response.statusCode})',
        );
      }
    } catch (e) {
      // 👇 INI PENTING: Biar kalau error, aplikasinya ngasih tau, bukan langsung mati!
      print("🚨 ERROR FATAL PAS AMBIL DATA PROFILE: $e");
      Get.snackbar(
        'Error Koneksi',
        'Tidak bisa terhubung ke server. Cek internet/IP.',
      );
    } finally {
      // 2. WAJIB DI SINI: Apapun yang terjadi, matiin loadingnya!
      isLoading.value = false;
    }
  }

  // --- FUNGSI TOMBOL ---
  void logout() {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
      textConfirm: 'Ya, Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A),
      onConfirm: () async {
        Get.back();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Get.offAllNamed('/login');
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
  }
}
