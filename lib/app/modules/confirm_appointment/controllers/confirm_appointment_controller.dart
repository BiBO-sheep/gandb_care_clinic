import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class ConfirmAppointmentController extends GetxController {
  // --- VARIABEL PENAMPUNG DATA ---
  late int poliId;
  late int dokterId; // Nangkep ID Dokter buat dikirim ke Laravel
  late String clinicName;
  late String doctorName; // Cukup 1 aja, gak boleh dobel
  late String date;
  late String time;
  late String estFee; // Nanti kita tangkap dari halaman sebelumnya

  // Data statis lokasi
  final String location = 'G&B Care Clinic — Main Hub\nJl. Kesehatan No. 123';

  var isConfirming = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Tangkap data yang dibawa dari halaman sebelumnya
    final args = Get.arguments as Map<String, dynamic>?;

    poliId = args?['poli_id'] ?? 1;
    dokterId = args?['dokter_id'] ?? 1; // Pastikan ini ada
    clinicName = args?['clinic_name'] ?? 'Poli Umum';

    // Nangkep nama dokter, kalau kosong kasih default
    doctorName = args?['doctor_name'] ?? 'Dokter (Assigned on Arrival)';

    // 👇 NANGKEP HARGA DOKTER ASLI DARI DATABASE 👇
    estFee = args?['price']?.toString() ?? 'Rp 150.000';

    date = args?['date'] ?? 'Sep 12, 2024';
    time = args?['time'] ?? '09:30';
  }

  // ==== FUNGSI TEMBAK DATA KE LARAVEL ====
  Future<void> confirmAppointment() async {
    isConfirming.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // Tembak API Laravel
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/appointments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'poli_id': poliId.toString(),
          'dokter_id': dokterId
              .toString(), // 👈 WAJIB DIKIRIM BIAR WEB ADMIN GAK KOSONG
          'tanggal': date,
          'jam': time,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final appointment = responseData['data'];

        Get.snackbar(
          'Appointment Confirmed!',
          'Jadwal berhasil disimpan di sistem klinik.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF006A6A),
          colorText: Colors.white,
        );

        // Pindah ke tiket dengan bawa arguments asli
        Get.offAllNamed(
          '/digital-ticket',
          arguments: {
            'id': appointment['id'],
            'queue_number': appointment['queue_number'],
            'patient_name': appointment['user']['name'],
            'service': clinicName,
            'doctor': doctorName,
            'date': date,
            'time': time,
          },
        );
      } else {
        Get.snackbar(
          'Oops!',
          'Gagal menyimpan data ke server.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error booking: $e");
      Get.snackbar(
        'Error',
        'Koneksi ke server terputus.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isConfirming.value = false;
    }
  }

  void editSelection() {
    Get.back();
  }
}
