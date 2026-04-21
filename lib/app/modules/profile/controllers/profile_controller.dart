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
  var userBloodType = ''.obs; // Tambahan untuk Golongan Darah
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // CATATAN BOS: Pastikan key ini sama dengan yang lu pakai pas nyimpen token di Login/Register
      String? token = prefs.getString('token');

      // Keamanan: Kalau token nggak ada di HP, tendang ke halaman login
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

      print(
        'Status Code API Profile: ${response.statusCode}',
      ); // Buat ngecek di terminal
      print(
        'Response API Profile: ${response.body}',
      ); // Buat ngintip balasan Laravel

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sesuaikan dengan format Laravel lu. Biasanya langsung data mentah.
        final userData = data['data'] ?? data;

        userName.value = userData['name'] ?? 'User';
        userEmail.value = userData['email'] ?? '-';
        userPhone.value = userData['phone'] ?? '-';
        userBloodType.value = userData['blood_type'] ?? '-';
      } else if (response.statusCode == 401) {
        // 401 artinya token ditolak/expired
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
      print('Profile Fetch Error Bos: $e');
      Get.snackbar(
        'Error Koneksi',
        'Tidak bisa terhubung ke server. Cek internet/IP.',
      );
    } finally {
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
      buttonColor: const Color(0xFFBA1A1A), // Warna merah elegan
      onConfirm: () async {
        Get.back(); // Tutup pop-up dialognya

        // 1. Hapus token dari memori HP biar gak nyangkut
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        // 2. Tendang balik ke halaman Login
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
