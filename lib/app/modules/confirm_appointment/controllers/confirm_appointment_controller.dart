import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';

class ConfirmAppointmentController extends GetxController {
  late int poliId;
  late int dokterId;
  late String clinicName;
  late String doctorName;
  late String date;
  late String time;
  late String estFee;

  final String location = 'G&B Care Clinic — Main Hub\nJl. Kesehatan No. 123';
  var isConfirming = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;

    poliId = args?['poli_id'] ?? 1;
    dokterId = args?['dokter_id'] ?? 1;
    clinicName = args?['clinic_name'] ?? 'Poli Umum';
    doctorName = args?['doctor_name'] ?? 'Dokter (Assigned on Arrival)';
    estFee = args?['price']?.toString() ?? 'Rp 150.000';
    date = args?['date'] ?? 'Sep 12, 2024';
    time = args?['time'] ?? '09:30';
  }

  Future<void> confirmAppointment() async {
    isConfirming.value = true;

    try {
      final response = await _apiService.post(
        'appointments',
        body: {
          'poli_id': poliId.toString(),
          'dokter_id': dokterId.toString(),
          'tanggal': date,
          'jam': time,
        },
      );

      final responseData = jsonDecode(response.body);
      final appointment = responseData['data'];

      Get.snackbar(
        'Appointment Confirmed!',
        'Jadwal berhasil disimpan di sistem klinik.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF006A6A),
        colorText: Colors.white,
      );

      Get.offNamedUntil(
        '/digital-ticket',
        (route) => route.settings.name == '/home' || route.isFirst,
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
    } catch (e) {
      debugPrint("Error booking: $e");
      if (e.toString().contains('Sesi telah berakhir')) {
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isConfirming.value = false;
    }
  }

  void editSelection() {
    Get.back();
  }
}
