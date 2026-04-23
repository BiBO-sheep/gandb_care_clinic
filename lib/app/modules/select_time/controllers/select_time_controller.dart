import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart'; // Pastikan path ini bener bos!

class SelectTimeController extends GetxController {
  var clinicId = 0.obs;
  var clinicName = 'Klinik'.obs;

  // 👇 INI VARIABEL BARU BUAT NAMPUNG DATA DOKTER ASLI 👇
  var dokterId = 0.obs;
  var doctorName = 'Loading...'.obs;
  var estFee = 'Rp 0'.obs;
  var isLoadingDokter = true.obs;

  // 1. Variabel Tanggal & Waktu
  var selectedDate = DateTime.now().obs;
  var selectedTime = ''.obs;

  // 2. Variabel buat nampilin Kalender
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

      // Langsung tembak API buat nyari dokter di Poli ini
      fetchDokterByPoli(clinicId.value);
    }
  }

  // ==== FUNGSI BARU: TARIK DATA DOKTER DARI LARAVEL ====
  Future<void> fetchDokterByPoli(int poliId) async {
    try {
      isLoadingDokter.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/poli/$poliId/dokter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List dokters = responseData['data'] ?? [];

        if (dokters.isNotEmpty) {
          // Ambil dokter pertama dari poli tersebut (Bisa diupgrade pakai Dropdown nanti)
          final dokter = dokters[0];
          dokterId.value = dokter['id'] ?? 0;
          doctorName.value = dokter['name'] ?? 'Dokter Umum';

          // Format harga dari angka (misal: 150000) jadi Rupiah
          final harga = dokter['price'] ?? 150000;
          estFee.value =
              'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
        } else {
          doctorName.value = 'Belum ada Dokter';
          estFee.value = 'Rp -';
        }
      }
    } catch (e) {
      print("🚨 Error ambil dokter: $e");
      doctorName.value = 'Error Jaringan';
    } finally {
      isLoadingDokter.value = false;
    }
  }

  // ==== FUNGSI NAVIGASI KALENDER (Tetap sama) ====
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
    selectedTime.value = '';
  }

  void selectTime(String time, String status) {
    if (status != 'booked') {
      selectedTime.value = time;
    } else {
      Get.snackbar(
        'Jadwal Penuh',
        'Waktu ini sudah dibooking oleh pasien lain.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

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
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (dokterId.value == 0) {
      Get.snackbar(
        'Mohon Tunggu',
        'Data dokter sedang dimuat atau tidak tersedia.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Meneruskan...',
      'Membuka halaman konfirmasi',
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.toNamed(
        '/confirm-appointment',
        arguments: {
          'poli_id': clinicId.value,
          'clinic_name': clinicName.value,
          'date': getFormattedSelectedDate(),
          'time': selectedTime.value,
          // 👇 INI DIA BOS: KITA LEMPAR DATA DOKTER ASLI KE HALAMAN CONFIRM 👇
          'dokter_id': dokterId.value,
          'doctor_name': doctorName.value,
          'price': estFee.value,
        },
      );
    });
  }
}
