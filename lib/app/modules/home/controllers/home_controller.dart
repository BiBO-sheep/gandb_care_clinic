import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gandb_care_clinic/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan path-nya benar menuju file api_config.dart
import '../../../../api_config.dart';

class HomeController extends GetxController {
  // ==========================================
  // 1. VARIABEL UI BAWAAN LU (Biar Gak Error)
  // ==========================================
  var patientName = 'Pasien'.obs;
  var heartRate = 82.obs;
  var currentIndex = 0.obs;

  // ==========================================
  // 2. VARIABEL API DARI LARAVEL
  // ==========================================
  var isLoading = true.obs;
  var listPoli = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPoliAPI(); // Tarik data pas halaman dibuka
  }

  // ==========================================
  // 3. FUNGSI KLIK TOMBOL BAWAAN LU
  // ==========================================
  void changePage(int index) {
    currentIndex.value = index;
  }

  void openQRScanner() {
    Get.snackbar(
      'Info',
      'Membuka Scanner...',
      snackPosition: SnackPosition.TOP,
    );
  }

  void onQuickActionTapped(String action) {
    if (action == 'Book Appointment') {
      // Pindah ke halaman Pilih Poli/Dokter
      Get.toNamed('/select-clinic');
    } else if (action == 'Poli Info') {
      Get.snackbar(
        'Informasi',
        'Geser ke bawah untuk melihat ${listPoli.length} Poli yang tersedia!',
        backgroundColor: Colors.white,
        colorText: AppColors.primary,
      );
    } else {
      Get.snackbar('Aksi', 'Membuka menu $action...');
    }
  }

  // ==========================================
  // 4. FUNGSI TARIK DATA DARI LARAVEL
  // ==========================================
  Future<void> fetchPoliAPI() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/poli'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        listPoli.value = data['data']; // Simpan data poli ke variabel
      }
    } catch (e) {
      print("Error ambil data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi Logout kalau butuh nanti
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAllNamed('/login');
  }
}
