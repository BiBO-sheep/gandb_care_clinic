import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_service.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';

class ExamResultsController extends GetxController {
  var currentIndex = 1.obs;
  var isLoading = true.obs;
  var resultsList = [].obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchExamResults();
  }

  Future<void> fetchExamResults() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get('exam-results');
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
    } catch (e) {
      if (e.toString().contains('Sesi telah berakhir')) {
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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
    if (Get.isRegistered<MainLayoutController>()) {
      Get.find<MainLayoutController>().changePage(index);
      Get.until((route) => route.settings.name == '/home' || route.isFirst);
    } else {
      Get.offAllNamed('/home');
    }
  }
}

