import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';

class SelectClinicController extends GetxController {
  var isLoading = true.obs;
  var listPoli = [].obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchPoliAPI();
  }

  Future<void> fetchPoliAPI() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('poli');
      final data = jsonDecode(response.body);
      listPoli.value = data['data'];
    } catch (e) {
      debugPrint("Error ambil data Poli: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onClinicSelected(String uiClinicName) {
    if (isLoading.value) {
      Get.snackbar(
        'Tunggu',
        'Sedang memuat data klinik...',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    var matchedPoli = listPoli.firstWhere(
      (poli) => poli['name'].toString().toLowerCase().contains(
        uiClinicName.toLowerCase(),
      ),
      orElse: () => null,
    );

    if (matchedPoli != null) {
      Get.toNamed(
        '/select-time',
        arguments: {
          'poli_id': matchedPoli['id'],
          'poli_name': matchedPoli['name'],
        },
      );
    } else {
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

