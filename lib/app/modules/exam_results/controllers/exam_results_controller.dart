import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class ExamResultsController extends GetxController {
  var currentIndex = 1.obs;

  var isLoading = true.obs;
  var resultsList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExamResults();
  }

  Future<void> fetchExamResults() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Sesi telah habis, silakan login kembali',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/exam-results');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          resultsList.value = data['data'];
        } else {
          Get.snackbar(
            'Gagal',
            data['message'] ?? 'Gagal mengambil data',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat memuat data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToPrescription(dynamic record) {
    Get.toNamed('/digital-prescription', arguments: record);
  }

  void backToHistory() {
    Get.back();
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    }
  }
}
