import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class QueueMonitorController extends GetxController {
  var myQueueNumber = '...'.obs;
  var nowServing = '...'.obs;
  var estimatedWaitTime = 0.obs;
  var isLoading = true.obs;
  var currentIndex = 0.obs;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchQueueData();
    // Auto refresh data setiap 10 detik biar real-time
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchQueueData();
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchQueueData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/queue-status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Update state dari database
        myQueueNumber.value = data['my_queue'] ?? 'N/A';
        nowServing.value = data['now_serving'] ?? '1';

        // Logika estimasi: (Antrean Saya - Sekarang) * 10 menit
        int myNum = int.tryParse(myQueueNumber.value.replaceAll('A-', '')) ?? 0;
        int servNum = int.tryParse(nowServing.value.replaceAll('A-', '')) ?? 0;
        int diff = myNum - servNum;
        estimatedWaitTime.value = diff > 0 ? diff * 10 : 0;

        if (myQueueNumber.value == nowServing.value && myNum != 0) {
          Get.snackbar(
            'Giliran Anda!',
            'Silakan menuju ruang konsultasi sekarang.',
          );
        }
      }
    } catch (e) {
      print("Error fetch queue: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    } else if (index == 1) {
      // 👇 INI HARUS ADA SUPAYA BISA PINDAH KE HALAMAN HISTORY
      Get.toNamed('/payment-history');
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
