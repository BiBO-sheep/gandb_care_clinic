import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../data/providers/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';

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
      AppSnackbar.info('Mohon Tunggu', 'Sedang memuat data klinik...');
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
      AppSnackbar.warning('Belum Tersedia', 'Poli $uiClinicName belum tersedia di klinik saat ini.');
    }
  }

  void callCenter() {
    AppSnackbar.info('Layanan Pelanggan', 'Menyambungkan ke layanan pelanggan...');
  }
}

