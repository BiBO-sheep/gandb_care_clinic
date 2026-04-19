import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class PaymentHistoryController extends GetxController {
  // Observables untuk State Management
  var isLoading = true.obs;
  var historyList = [].obs;
  var currentIndex = 1.obs; // Tab Bottom Nav

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  // Fungsi narik data dari Laravel
  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        historyList.value = responseData['data'];
      }
    } catch (e) {
      print("Error fetch history: $e");
      Get.snackbar('Error', 'Gagal memuat riwayat');
    } finally {
      isLoading.value = false;
    }
  }

  // Buka tiket lama
  void openTicket(Map<String, dynamic> item) {
    Get.toNamed(
      '/digital-ticket',
      arguments: {
        'id': item['id'],
        'queue_number': item['queue_number'],
        'patient_name': item['user']?['name'] ?? 'Patient',
        'service':
            item['poli']?['nama_poli'] ??
            'Klinik', // Sesuaikan nama kolom poli di DB lu
        'date': item['tanggal'],
        'time': item['jam'],
      },
    );
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) Get.offAllNamed('/home');
    // Nanti tambahin rute lain kalau udah jadi
  }
}
