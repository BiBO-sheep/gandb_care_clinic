import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class SelectTimeController extends GetxController {
  var clinicId = 0.obs;
  var clinicName = 'Klinik'.obs;

  var dokterId = 0.obs;
  var doctorName = 'Loading...'.obs;
  var estFee = 'Rp 0'.obs;
  var isLoadingDokter = true.obs;

  var selectedDate = DateTime.now().obs;
  var selectedTime = ''.obs;

  var displayMonth = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;

  final ApiService _apiService = ApiService();

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
    _initBaseSlots();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      clinicId.value = args['poli_id'] ?? 0;
      clinicName.value = args['poli_name'] ?? 'Klinik';

      fetchDokterByPoli(clinicId.value);
      fetchAvailableSlots();
    }
  }

  Future<void> fetchDokterByPoli(int poliId) async {
    try {
      isLoadingDokter.value = true;

      final response = await _apiService.get('poli/$poliId/dokter');
      final responseData = jsonDecode(response.body);
      final List dokters = responseData['data'] ?? [];

      if (dokters.isNotEmpty) {
        final dokter = dokters[0];
        dokterId.value = dokter['id'] ?? 0;
        doctorName.value = dokter['name'] ?? 'Dokter Umum';

        final harga = dokter['price'] ?? 150000;
        estFee.value =
            'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
      } else {
        doctorName.value = 'Belum ada Dokter';
        estFee.value = 'Rp -';
      }
    } catch (e) {
      debugPrint("🚨 Error ambil dokter: $e");
      doctorName.value = 'Error Jaringan';
    } finally {
      isLoadingDokter.value = false;
    }
  }

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
    fetchAvailableSlots();
  }

  void selectTime(String time, String status) {
    if (status != 'booked') {
      selectedTime.value = time;
    } else {
      AppSnackbar.warning(
        'Jadwal Tidak Tersedia',
        'Waktu ini sudah dipesan oleh pasien lain.',
      );
    }
  }

  String getFormattedDisplayMonth() {
    return '${monthNames[displayMonth.value.month - 1]} ${displayMonth.value.year}';
  }

  String getFormattedSelectedDate() {
    return '${monthNames[selectedDate.value.month - 1]} ${selectedDate.value.day}, ${selectedDate.value.year}';
  }

  final List<Map<String, dynamic>> _baseTimeSlots = [
    {'time': '09:00', 'period': 'Morning', 'status': 'available'},
    {'time': '10:30', 'period': 'Morning', 'status': 'available'},
    {'time': '11:15', 'period': 'Morning', 'status': 'available'},
    {'time': '14:00', 'period': 'Afternoon', 'status': 'available'},
    {'time': '15:45', 'period': 'Afternoon', 'status': 'available'},
    {'time': '17:45', 'period': 'Afternoon', 'status': 'available'},
  ];

  var timeSlots = <Map<String, dynamic>>[].obs;
  var isFetchingSlots = false.obs;

  void _initBaseSlots() {
    timeSlots.value = _baseTimeSlots
        .map((s) => {...s, 'status': 'available'})
        .toList();
  }

  Future<void> fetchAvailableSlots() async {
    try {
      isFetchingSlots.value = true;
      String dateStr = getFormattedSelectedDate();
      final response = await _apiService.get(
        'available-slots?tanggal=$dateStr&poli_id=${clinicId.value}',
      );
      final responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        List slotsFromApi = responseData['data'] ?? [];
        DateTime now = DateTime.now();
        bool isToday =
            selectedDate.value.year == now.year &&
            selectedDate.value.month == now.month &&
            selectedDate.value.day == now.day;

        List<Map<String, dynamic>> newSlots = [];
        for (var baseSlot in _baseTimeSlots) {
          String jam = baseSlot['time'] as String;
          var apiSlot = slotsFromApi.firstWhere(
            (s) => s['jam'] == jam,
            orElse: () => null,
          );
          String status = apiSlot != null ? apiSlot['status'] : 'available';

          if (isToday && status != 'booked') {
            List<String> parts = jam.split(':');
            int hour = int.parse(parts[0]);
            int minute = int.parse(parts[1]);
            DateTime slotTime = DateTime(
              now.year,
              now.month,
              now.day,
              hour,
              minute,
            );
            if (slotTime.isBefore(now)) {
              status = 'booked';
            }
          }

          newSlots.add({
            ...baseSlot,
            'status': status,
            'sisa_kuota': apiSlot != null ? apiSlot['sisa_kuota'] : 3,
          });
        }
        timeSlots.value = newSlots;
      }
    } catch (e) {
      debugPrint("Error fetching slots: $e");
    } finally {
      isFetchingSlots.value = false;
    }
  }

  void continueToPayment() {
    if (selectedTime.value.isEmpty) {
      AppSnackbar.warning(
        'Jadwal Belum Dipilih',
        'Silakan pilih waktu kunjungan Anda.',
      );
      return;
    }

    if (dokterId.value == 0) {
      AppSnackbar.info(
        'Mohon Tunggu',
        'Data dokter sedang dimuat atau tidak tersedia.',
      );
      return;
    }

    Get.toNamed(
      '/confirm-appointment',
      arguments: {
        'poli_id': clinicId.value,
        'clinic_name': clinicName.value,
        'date': getFormattedSelectedDate(),
        'time': selectedTime.value,
        'dokter_id': dokterId.value,
        'doctor_name': doctorName.value,
        'price': estFee.value,
      },
    );
  }
}
