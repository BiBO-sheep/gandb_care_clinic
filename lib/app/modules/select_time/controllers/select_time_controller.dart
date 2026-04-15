import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTimeController extends GetxController {
  // Menangkap nama poli dari halaman sebelumnya
  final String clinicName = Get.arguments as String? ?? 'Umum';

  // State untuk tanggal dan waktu yang dipilih
  var selectedDate = 12.obs;
  var selectedTime = '10:30'.obs;

  // Mock Data: Jadwal Waktu
  final List<Map<String, dynamic>> timeSlots = [
    {'time': '09:00', 'period': 'Morning', 'status': 'available'},
    {'time': '10:30', 'period': 'Morning', 'status': 'available'},
    {'time': '11:15', 'period': 'Morning', 'status': 'available'},
    {'time': '14:00', 'period': 'Afternoon', 'status': 'available'},
    {'time': '15:45', 'period': 'Afternoon', 'status': 'available'},
    {'time': '17:00', 'period': 'Afternoon', 'status': 'booked'},
  ];

  // Fungsi saat tanggal diklik
  void selectDate(int date) {
    if (date > 0) {
      // Hanya tanggal aktif yang bisa diklik
      selectedDate.value = date;
      selectedTime.value = ''; // Reset jam jika tanggal berubah
    }
  }

  // Fungsi saat jam diklik
  void selectTime(String time, String status) {
    if (status != 'booked') {
      selectedTime.value = time;
    } else {
      Get.snackbar(
        'Jadwal Penuh',
        'Waktu ini sudah dibooking oleh pasien lain.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi tombol Lanjut
  void continueToPayment() {
    // 1. CEK ERROR (Validasi)
    if (selectedDate.value == 0 || selectedTime.value.isEmpty) {
      Get.snackbar(
        'Pilih Jadwal',
        'Silakan pilih tanggal dan waktu kunjungan Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return; // Berhenti di sini jika error
    }

    // 2. JIKA SUKSES (Melewati validasi di atas)
    Get.snackbar(
      'Berhasil!',
      'Jadwal $clinicName di-booking untuk Tgl ${selectedDate.value}, Jam ${selectedTime.value}.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2), // Samakan durasi dengan delay
    );

    // 3. PINDAH HALAMAN
    // Tunggu snackbar selesai (2 detik), lalu pindah halaman
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/queue-monitor');
    });
  }
}
