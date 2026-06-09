import 'package:flutter/material.dart';
import 'package:gandb_care_clinic/app/data/models/appointment_model.dart';
import 'package:gandb_care_clinic/app/data/models/health_tip_model.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_service.dart';
import '../../../data/providers/unauthorized_exception.dart';
import 'package:intl/intl.dart';

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

  Future<void> refreshData({bool showLoading = true}) async {
    if (isClosed) return;
    if (showLoading && listPoli.isEmpty) isLoading.value = true;
    await Future.wait([fetchUser(), fetchDashboardData(), fetchPoliAPI()]);
    if (!isClosed) {
      isLoading.value = false;
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await _apiService.get('user');
      final data = jsonDecode(response.body);
      patientName.value = data['data']['name'] ?? 'Pasien';
    } on UnauthorizedException {
      logout();
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await _apiService.get('dashboard');
      final data = jsonDecode(response.body);

      if (data['upcoming_appointment'] != null) {
        final apt = AppointmentModel.fromJson(data['upcoming_appointment']);
        bool isValid = true;

        final status = apt.status.toLowerCase();
        if (['completed', 'selesai', 'cancelled', 'batal'].contains(status)) {
          isValid = false;
        }

        try {
          // Format expected: "May 30, 2026" (M d, Y from Laravel)
          final aptDate = DateFormat('MMM d, yyyy', 'en_US').parse(apt.tanggal);
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          if (aptDate.isBefore(today)) {
            isValid = false;
          }
        } catch (e) {
          debugPrint("Failed to parse date: ${apt.tanggal}");
        }

        if (isValid) {
          upcomingAppointment.value = apt;
        } else {
          upcomingAppointment.value = null;
        }
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
    if (Get.isRegistered<MainLayoutController>()) {
      Get.find<MainLayoutController>().changePage(index);
      Get.until((route) => route.settings.name == '/home' || route.isFirst);
    } else {
      Get.offAllNamed('/home');
    }
  }

  void openQRScanner() => Get.toNamed('/scanner');

  void onQuickActionTapped(String action) {
    if (action == 'My History') {
      Get.toNamed('/exam-results');
    } else if (action == 'Book Appointment') {
      Get.toNamed('/select-clinic');
    } else if (action == 'Poli Info') {
      Get.snackbar(
        'Informasi',
        'Geser ke bawah untuk melihat daftar ${listPoli.length} poli kami.',
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: Icon(Icons.info_outline, color: Get.theme.colorScheme.primary),
        borderRadius: 16,
      );
    } else {
      Get.snackbar(
        'Info',
        'Membuka $action...',
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        borderRadius: 16,
      );
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    Get.offAllNamed('/login');
  }
}
