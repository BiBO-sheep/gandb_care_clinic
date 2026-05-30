import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/polling_service.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';

class QueueMonitorController extends GetxController {
  // --- Reactive Variables (Proxy to Service) ---
  var currentQueue = ''.obs;
  var currentStatus = ''.obs;
  var estimatedWait = '0'.obs;
  var isHasActiveSession = false.obs;

  var doctorName = ''.obs;
  var clinicName = ''.obs;
  var roomName = ''.obs;
  var myQueueNumber = ''.obs;
  var nowServing = '...'.obs;

  var isLoading = false.obs;
  var currentIndex = 0.obs;

  // Simpan subscription agar bisa di-cancel saat dispose
  final List<Worker> _workers = [];

  @override
  void onInit() {
    super.onInit();

    // Ambil PollingService dengan null-safe
    final PollingService? polling = Get.isRegistered<PollingService>()
        ? PollingService.to
        : null;

    if (polling == null) return;

    // Set initial values
    currentQueue.value = polling.currentQueue.value;
    currentStatus.value = polling.currentStatus.value;
    isHasActiveSession.value = polling.isHasActiveSession.value;
    doctorName.value = polling.doctorName.value;
    clinicName.value = polling.clinicName.value;
    roomName.value = polling.roomName.value;
    myQueueNumber.value = polling.currentQueue.value;

    // Bind via ever() dan simpan workers-nya
    _workers.addAll([
      ever(polling.currentQueue, (val) {
        if (!isClosed) currentQueue.value = val.toString();
      }),
      ever(polling.currentStatus, (val) {
        if (!isClosed) currentStatus.value = val.toString();
      }),
      ever(polling.isHasActiveSession, (val) {
        if (!isClosed) isHasActiveSession.value = val;
      }),
      ever(polling.doctorName, (val) {
        if (!isClosed) doctorName.value = val.toString();
      }),
      ever(polling.clinicName, (val) {
        if (!isClosed) clinicName.value = val.toString();
      }),
      ever(polling.roomName, (val) {
        if (!isClosed) roomName.value = val.toString();
      }),
    ]);
  }

  @override
  void onClose() {
    // Cancel semua workers secara eksplisit
    for (final worker in _workers) {
      worker.dispose();
    }
    _workers.clear();
    super.onClose();
  }

  // =====================================================
  // NAVIGASI & UTILITAS
  // =====================================================
  void changePage(int index) {
    currentIndex.value = index;
    if (Get.isRegistered<MainLayoutController>()) {
      Get.find<MainLayoutController>().changePage(index);
      Get.until((route) => route.settings.name == '/home' || route.isFirst);
    } else {
      Get.offAllNamed('/home');
    }
  }

  void openQRScanner() {
    Get.snackbar('Info', 'Fitur Scan QR dinonaktifkan. Gunakan monitor antrean.');
  }

  void testAudio() {
    if (!Get.isRegistered<PollingService>()) return;
    PollingService.to.playNotificationSound();
    Get.snackbar('Audio Test', 'Memutar suara notifikasi...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blueGrey,
      colorText: Colors.white,
    );
  }
}
