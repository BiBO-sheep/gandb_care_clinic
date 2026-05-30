import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_service.dart';
import '../../../data/providers/unauthorized_exception.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';

class ProfileController extends GetxController {
  var currentIndex = 3.obs;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userBloodType = ''.obs;
  var isLoading = false.obs;

  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get('profile');
      final data = jsonDecode(response.body);
      final userData = data['data'] ?? {};

      userName.value = userData['name']?.toString() ?? 'User';
      userEmail.value = userData['email']?.toString() ?? '-';
      userPhone.value = userData['phone']?.toString() ?? '-';
      userBloodType.value = userData['blood_type']?.toString() ?? '-';
    } on UnauthorizedException {
      logout(confirm: false);
    } catch (e) {
      debugPrint("ERROR PAS AMBIL DATA PROFILE: $e");
      Get.snackbar(
        'Error Koneksi',
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout({bool confirm = true}) {
    if (!confirm) {
      _executeLogout();
      return;
    }

    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
      textConfirm: 'Ya, Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFBA1A1A),
      onConfirm: () async {
        Get.back();
        await _executeLogout();
      },
    );
  }

  Future<void> _executeLogout() async {
    await _storage.delete(key: 'token');
    Get.offAllNamed('/login');
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

