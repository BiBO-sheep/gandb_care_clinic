import 'package:flutter/material.dart';
import 'package:gandb_care_clinic/app/data/models/appointment_model.dart';
import 'package:gandb_care_clinic/app/data/models/health_tip_model.dart';
import 'package:gandb_care_clinic/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_service.dart';

class HomeController extends GetxController {
  var patientName = 'Pasien'.obs;
  var currentIndex = 0.obs;
  var isLoading = true.obs;
  
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  var listPoli = [].obs;
  var upcomingAppointment = Rxn<AppointmentModel>();
  var healthTips = <HealthTipModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  Future<void> refreshData() async {
    if (isClosed) return;
    await fetchUser();
    if (isClosed) return;
    await fetchDashboardData();
    if (isClosed) return;
    await fetchPoliAPI();
  }

  Future<void> fetchUser() async {
    try {
      final response = await _apiService.get('user');
      final data = jsonDecode(response.body);
      patientName.value = data['data']['name'] ?? 'Pasien';
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('dashboard');
      final data = jsonDecode(response.body);
      
      if (data['upcoming_appointment'] != null) {
        upcomingAppointment.value = AppointmentModel.fromJson(data['upcoming_appointment']);
      } else {
        upcomingAppointment.value = null;
      }

      if (data['health_tips'] != null) {
        healthTips.value = (data['health_tips'] as List)
            .map((e) => HealthTipModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPoliAPI() async {
    try {
      final response = await _apiService.get('poli');
      final data = jsonDecode(response.body);
      listPoli.value = data['data'] ?? [];
    } catch (e) {
      debugPrint("Error fetching poli: $e");
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 1) {
      Get.offAllNamed('/payment-history');
    } else if (index == 2) {
      Get.offAllNamed('/notifications');
    } else if (index == 3) {
      Get.offAllNamed('/profile');
    }
  }

  void openQRScanner() => Get.snackbar('Info', 'Membuka Scanner...');

  void onQuickActionTapped(String action) {
    if (action == 'My History') {
      Get.toNamed('/exam-results');
    } else if (action == 'Book Appointment') {
      Get.toNamed('/select-clinic');
    } else if (action == 'Poli Info') {
      Get.snackbar('Informasi', 'Geser ke bawah untuk melihat ${listPoli.length} Poli!', backgroundColor: Colors.white, colorText: AppColors.primary);
    } else {
      Get.snackbar('Aksi', 'Membuka menu $action...');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    Get.offAllNamed('/login');
  }
}
