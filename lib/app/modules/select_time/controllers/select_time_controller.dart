import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTimeController extends GetxController {
  var clinicId = 0.obs;
  var clinicName = 'Klinik'.obs;

  // 1. Variabel Tanggal & Waktu
  var selectedDate = DateTime.now().obs;
  var selectedTime = ''.obs;

  // 2. Variabel buat nampilin Kalender (Bisa digeser ke bulan depan)
  var displayMonth = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;

  final List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void onInit() {
    super.onInit();
    // Tangkap data dari halaman Poli
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      clinicId.value = args['poli_id'] ?? 0;
      clinicName.value = args['poli_name'] ?? 'Klinik';
    }
  }

  // ==== FUNGSI NAVIGASI KALENDER ====
  void nextMonth() {
    displayMonth.value = DateTime(
      displayMonth.value.year,
      displayMonth.value.month + 1,
      1,
    );
  }

  void prevMonth() {
    DateTime now = DateTime.now();
    DateTime currentMonthStart = DateTime(now.year, now.month, 1);
    // Cuma bisa geser mundur kalau bulannya lebih dari bulan ini (Gak bisa booking ke masa lalu)
    if (displayMonth.value.isAfter(currentMonthStart)) {
      displayMonth.value = DateTime(
        displayMonth.value.year,
        displayMonth.value.month - 1,
        1,
      );
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTime.value = ''; // Reset jam kalau tanggal ganti
  }

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

  // Format Text
  String getFormattedDisplayMonth() {
    return '${monthNames[displayMonth.value.month - 1]} ${displayMonth.value.year}';
  }

  String getFormattedSelectedDate() {
    return '${monthNames[selectedDate.value.month - 1]} ${selectedDate.value.day}, ${selectedDate.value.year}';
  }

  // --- MOCK DATA JADWAL (Nanti nyambung API) ---
  final List<Map<String, dynamic>> timeSlots = [
    {'time': '09:00', 'period': 'Morning', 'status': 'available'},
    {'time': '10:30', 'period': 'Morning', 'status': 'available'},
    {'time': '11:15', 'period': 'Morning', 'status': 'available'},
    {'time': '14:00', 'period': 'Afternoon', 'status': 'available'},
    {'time': '15:45', 'period': 'Afternoon', 'status': 'available'},
    {'time': '17:00', 'period': 'Afternoon', 'status': 'booked'},
  ];

  // ==== FUNGSI LANJUT KONFIRMASI ====
  void continueToPayment() {
    if (selectedTime.value.isEmpty) {
      Get.snackbar(
        'Pilih Jadwal',
        'Silakan pilih waktu kunjungan Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Berhasil!',
      'Jadwal di ${clinicName.value} untuk ${getFormattedSelectedDate()}, Jam ${selectedTime.value}.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(
        '/confirm-appointment',
        arguments: {
          'poli_id': clinicId.value,
          'clinic_name': clinicName.value,
          'date': getFormattedSelectedDate(),
          'time': selectedTime.value,
        },
      );
    });
  }

  getFormattedCurrentMonth() {}
}
