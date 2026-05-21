import 'package:flutter/material.dart';
import 'package:gandb_care_clinic/app/data/models/appointment_model.dart';
import 'package:gandb_care_clinic/app/data/models/health_tip_model.dart';
import 'package:gandb_care_clinic/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class HomeController extends GetxController {
  var patientName = 'Pasien'.obs;
  var currentIndex = 0.obs;
  var isLoading = true.obs;
  
  // Data for Dashboard
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        patientName.value = data['data']['name'] ?? 'Pasien';
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Parse Upcoming Appointment
        if (data['upcoming_appointment'] != null) {
          upcomingAppointment.value = AppointmentModel.fromJson(data['upcoming_appointment']);
        } else {
          upcomingAppointment.value = null;
        }

        // Parse Health Tips
        if (data['health_tips'] != null) {
          healthTips.value = (data['health_tips'] as List)
              .map((e) => HealthTipModel.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPoliAPI() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/poli'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        listPoli.value = data['data'] ?? [];
      }
    } catch (e) {
      print("Error fetching poli: $e");
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 1) Get.offAllNamed('/payment-history');
    else if (index == 2) Get.offAllNamed('/notifications');
    else if (index == 3) Get.offAllNamed('/profile');
  }

  void openQRScanner() => Get.snackbar('Info', 'Membuka Scanner...');

  void onQuickActionTapped(String action) {
    if (action == 'My History') Get.toNamed('/exam-results');
    else if (action == 'Book Appointment') Get.toNamed('/select-clinic');
    else if (action == 'Poli Info') {
      Get.snackbar('Informasi', 'Geser ke bawah untuk melihat ${listPoli.length} Poli!', backgroundColor: Colors.white, colorText: AppColors.primary);
    } else Get.snackbar('Aksi', 'Membuka menu $action...');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAllNamed('/login');
  }
}
