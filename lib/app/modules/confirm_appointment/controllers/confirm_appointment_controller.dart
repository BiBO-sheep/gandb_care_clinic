import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan path-nya benar menuju file api_config.dart
import '../../../../api_config.dart';

class ConfirmAppointmentController extends GetxController {
  // Variabel penampung data dari halaman Select Time
  late int poliId;
  late String clinicName;
  late String date;
  late String time;

  // Data Rangkuman (Disesuaikan dengan Opsi A: System Allocation)
  final String doctorName = 'Assigned on Arrival';
  final String estFee = 'Rp 150.000'; // Biaya estimasi
  final String location = 'G&B Care Clinic — Main Hub\nJl. Kesehatan No. 123';

  var isConfirming = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Tangkap data yang dibawa dari halaman Select Time
    final args = Get.arguments as Map<String, dynamic>?;
    poliId = args?['poli_id'] ?? 1;
    clinicName = args?['clinic_name'] ?? 'Poli Umum';
    date = args?['date'] ?? 'Sep 12, 2024';
    time = args?['time'] ?? '09:30';
  }

  // ==== FUNGSI TEMBAK DATA KE LARAVEL ====
  Future<void> confirmAppointment() async {
    isConfirming.value = true;

    try {
      // 1. Ambil Kunci Token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // 2. Tembak API Laravel
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/appointments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {'poli_id': poliId.toString(), 'tanggal': date, 'jam': time},
      );

      // 3. Cek Balasan dari Laravel
      if (response.statusCode == 201 || response.statusCode == 200) {
        // --- PROSES TANGKAP DATA RESPONSE ---
        final responseData = jsonDecode(response.body);
        final appointment = responseData['data'];

        Get.snackbar(
          'Appointment Confirmed!',
          'Jadwal berhasil disimpan di sistem klinik.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF006A6A),
          colorText: Colors.white,
        );

        // --- PINDAH KE TIKET DENGAN MEMBAWA ARGUMENTS ASLI ---
        Get.offAllNamed(
          '/digital-ticket',
          arguments: {
            'id': appointment['id'],
            'queue_number': appointment['queue_number'],
            'patient_name':
                appointment['user']['name'], // Nama dari table users via relasi di Laravel
            'service': clinicName,
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
