import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class DigitalTicketController extends GetxController {
  var currentIndex = 1.obs;
  var isSimulating = false.obs;
  var status = 'confirmed'.obs; // Tambahan state status

  // Variabel penampung data asli
  var queueNumber = '...'.obs;
  var patientName = '...'.obs;
  var service = '...'.obs;
  var dateTime = '...'.obs;
  var appointmentId = '0'.obs; // Untuk isi QR Code
  final String location =
      'G&B Care Central\n4th Floor, Suite 400, Medical Plaza';

  @override
  void onInit() {
    super.onInit();
    // TANGKAP DATA DARI HALAMAN KONFIRMASI
    if (Get.arguments != null) {
      var data = Get.arguments;
      queueNumber.value = data['queue_number'] ?? 'A-00';
      patientName.value = data['patient_name'] ?? 'Patient';
      service.value = data['service'] ?? 'Clinic';
      dateTime.value = "${data['date']}, ${data['time']}";
      appointmentId.value = data['id'].toString();
      status.value = data['status'] ?? 'confirmed'; // Ambil status asli
    }
  }

  Future<void> simulateDoctorExamination() async {
    isSimulating.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Sesi tidak valid, silakan login ulang',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/simulate-examination/${appointmentId.value}');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Simulasi Berhasil: Dokter telah memeriksa pasien dan memberikan resep!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        
        // Update status agar UI langsung memunculkan tombol "Lanjut ke Pembayaran"
        status.value = 'completed';
      } else {
        final data = json.decode(response.body);
        Get.snackbar(
          'Error',
          data['message'] ?? 'Gagal melakukan simulasi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal terhubung ke server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSimulating.value = false;
    }
  }

  void backToDashboard() => Get.offAllNamed('/home');

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    } else if (index == 1) {
      // 👇 INI HARUS ADA SUPAYA BISA PINDAH KE HALAMAN HISTORY
      Get.toNamed('/payment-history');
    }
  }

  // Fungsi dummy tambahan
  void addToCalendar() => Get.snackbar('Success', 'Added to calendar');
  void shareTicket() => Get.snackbar('Share', 'Opening share menu...');
}
