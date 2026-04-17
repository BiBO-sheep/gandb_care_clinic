import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan path-nya benar menuju file api_config.dart
import '../../../../api_config.dart';

class SelectClinicController extends GetxController {
  // Variabel untuk menampung data dari Laravel
  var isLoading = true.obs;
  var listPoli = [].obs;

  @override
  void onInit() {
    super.onInit();
    // Langsung tarik data Poli dari Laravel pas halaman dibuka
    fetchPoliAPI();
  }

  // ==========================================
  // 1. FUNGSI TARIK DATA DARI LARAVEL
  // ==========================================
  Future<void> fetchPoliAPI() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/poli'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        listPoli.value = data['data']; // Simpan semua data poli ke memori
      }
    } catch (e) {
      print("Error ambil data Poli: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 2. FUNGSI LOGIKA KLIK KARTU POLI
  // ==========================================
  void onClinicSelected(String uiClinicName) {
    // Kalau API masih muter, suruh user sabar bentar
    if (isLoading.value) {
      Get.snackbar(
        'Tunggu',
        'Sedang memuat data klinik...',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Trik Rahasia: Cari ID poli di database yang namanya mengandung kata dari tombol UI
    // Contoh: UI tulisannya "Gigi", dia bakal nyari "Poli Gigi" di database
    var matchedPoli = listPoli.firstWhere(
      (poli) => poli['name'].toString().toLowerCase().contains(
        uiClinicName.toLowerCase(),
      ),
      orElse: () => null, // Kalau nggak ketemu, kembaliin null
    );

    if (matchedPoli != null) {
      // KALAU KETEMU DI DATABASE: Lanjut ke Halaman Pilih Waktu!
      // Kita bawa ID Poli dan Nama Poli ke halaman selanjutnya pakai "arguments"
      Get.toNamed(
        '/select-time',
        arguments: {
          'poli_id': matchedPoli['id'],
          'poli_name': matchedPoli['name'],
        },
      );
    } else {
      // KALAU ADMIN BELUM BIKIN POLI-NYA DI WEBSITE LARAVEL:
      Get.snackbar(
        'Mohon Maaf',
        'Poli $uiClinicName belum tersedia di klinik saat ini.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // ==========================================
  // 3. FUNGSI TOMBOL CALL CENTER
  // ==========================================
  void callCenter() {
    Get.snackbar(
      'Menghubungi',
      'Menyambungkan ke layanan pelanggan...',
      backgroundColor: const Color(0xFF006970),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
