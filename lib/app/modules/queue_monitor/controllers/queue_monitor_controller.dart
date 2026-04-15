import 'dart:async';
import 'dart:ui';
import 'package:get/get.dart';

class QueueMonitorController extends GetxController {
  // State Data Antrean
  var myQueueNumber = 15.obs;
  var nowServing = 12.obs;
  var estimatedWaitTime = 18.obs; // dalam menit

  // State untuk Bottom Navigation (Sama seperti Home)
  var currentIndex = 0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startQueueSimulation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Simulasi Antrean Berjalan
  void _startQueueSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (nowServing.value < myQueueNumber.value) {
        nowServing.value++; // Nomor antrean berjalan
        estimatedWaitTime.value -= 6; // Waktu tunggu berkurang

        if (nowServing.value == myQueueNumber.value) {
          Get.snackbar(
            'Giliran Anda!',
            'Silakan menuju Ruang 204. Dokter Aris Thorne sudah menunggu.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF006A6A),
            colorText: const Color(0xFFFFFFFF),
            duration: const Duration(seconds: 5),
          );
          timer.cancel(); // Hentikan simulasi jika sudah giliran
        }
      }
    });
  }

  // Fungsi mengubah tab menu bawah
  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home'); // Kembali ke home jika tab home diklik
    }
  }

  void openQRScanner() {
    Get.snackbar(
      'QR Scanner',
      'Membuka pemindai...',
      snackPosition: SnackPosition.TOP,
    );
  }
}
