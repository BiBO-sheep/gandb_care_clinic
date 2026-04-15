import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmAppointmentController extends GetxController {
  // Menangkap data dari halaman Select Time
  // Jika tidak ada data (misal saat testing), gunakan nilai default
  late String clinicName;
  late String date;
  late String time;

  // Data Mock tambahan untuk review
  final String doctorName = 'Dr. Aris Thorne';
  final String estFee = '\$85.00';
  final String location =
      'G&B Care Clinic — Main Hub\n124 Medical Sanctuary Way, Suite 400';

  var isConfirming = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Mengambil argumen yang dikirim dari halaman Select Time (jika ada)
    final args = Get.arguments as Map<String, dynamic>?;
    clinicName = args?['clinic'] ?? 'General Consultation';
    date = args?['date'] ?? 'Sep 12, 2024';
    time = args?['time'] ?? '09:30 AM';
  }

  // Fungsi saat tombol Confirm ditekan
  void confirmAppointment() async {
    isConfirming.value = true;

    // Simulasi proses loading konfirmasi pembayaran/booking (1.5 detik)
    await Future.delayed(const Duration(milliseconds: 1500));

    isConfirming.value = false;

    Get.snackbar(
      'Appointment Confirmed!',
      'Your booking has been successfully secured.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );

    // Lanjut ke halaman Queue Monitor yang sudah kita buat sebelumnya!
    Get.offAllNamed('/queue-monitor');
  }

  // Fungsi untuk tombol Edit Selection (Kembali ke halaman sebelumnya)
  void editSelection() {
    Get.back(); // Kembali ke halaman Select Time
  }
}
