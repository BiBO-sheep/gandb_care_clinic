import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../data/providers/api_service.dart';
import '../../../routes/app_pages.dart';
import 'dart:convert';

class CompleteProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final bloodTypes = ['A', 'B', 'AB', 'O'].obs;
  var selectedBloodType = Rxn<String>();

  var isLoading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }

  Future<void> submitProfile() async {
    if (phoneController.text.isEmpty || addressController.text.isEmpty) {
      AppSnackbar.warning(
        'Data Belum Lengkap',
        'Nomor Handphone dan Alamat wajib diisi.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        // Karena ini endpoint /profile/update, dan nama/email required di validation backend,
        // Tapi kita anggap saja backend sudah mengabaikan validation rule tersebut jika field tidak dikirim.
        // Wait, di backend: 'name' => 'required', 'email' => 'required'.
        // Oh, ProfileController meminta 'name' dan 'email' selalu ada.
        // Mari kita panggil get profile dulu, lalu kirim kembali name dan emailnya.
      };

      // Get current profile
      final userResponse = await _apiService.get('profile');
      final userData = jsonDecode(userResponse.body)['data'];

      body['name'] = userData['name'];
      body['email'] = userData['email'];
      body['phone'] = phoneController.text;
      body['address'] = addressController.text;

      if (selectedBloodType.value != null)
        body['blood_type'] = selectedBloodType.value!;
      if (heightController.text.isNotEmpty)
        body['height'] = heightController.text;
      if (weightController.text.isNotEmpty)
        body['weight'] = weightController.text;

      final response = await _apiService.put('profile/update', body: body);

      if (response.statusCode == 200) {
        AppSnackbar.success('Berhasil', 'Profil Anda telah lengkap!');
        Get.offAllNamed(Routes.HOME);
      } else {
        final data = jsonDecode(response.body);
        AppSnackbar.error(
          'Gagal',
          data['message'] ?? 'Gagal menyimpan profil.',
        );
      }
    } catch (e) {
      AppSnackbar.error('Error', 'Terjadi kesalahan saat menyimpan profil.');
    } finally {
      isLoading.value = false;
    }
  }
}
