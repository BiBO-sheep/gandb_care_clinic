import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/providers/api_service.dart';

class TagihanController extends GetxController {
  var isLoading = false.obs;
  
  var namaPasien = ''.obs;
  var nomorAntrean = ''.obs;
  var totalKonsultasi = 0.obs;
  var totalObat = 0.obs;
  var grandTotal = 0.obs;
  
  var medicines = <Map<String, dynamic>>[].obs;

  final ApiService _apiService = ApiService();

  Future<void> fetchDetailTagihan(int appointmentId) async {
    isLoading.value = true;
    
    namaPasien.value = '';
    nomorAntrean.value = '';
    totalKonsultasi.value = 0;
    totalObat.value = 0;
    grandTotal.value = 0;
    medicines.clear();

    try {
      final response = await _apiService.get('payment-summary/$appointmentId');
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        final data = responseData['data'];
        
        namaPasien.value = data['nama_pasien'] ?? '-';
        nomorAntrean.value = data['nomor_antrean'] ?? '-';
        
        final invoice = data['invoice'];
        if (invoice != null) {
          totalKonsultasi.value = double.parse(
            invoice['total_consultation'].toString(),
          ).toInt();
          totalObat.value = double.parse(
            invoice['total_medicines'].toString(),
          ).toInt();
          grandTotal.value = double.parse(
            invoice['grand_total'].toString(),
          ).toInt();
        }
        
        if (data['medicines'] != null) {
          medicines.value = List<Map<String, dynamic>>.from(data['medicines']);
        }
      }
    } catch (e) {
      debugPrint("[TagihanController] Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String formatRupiah(int amount) {
    String result = amount.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return result.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  }

  String getInitials() {
    if (namaPasien.value.isEmpty || namaPasien.value == '-') return "??";
    List<String> names = namaPasien.value.split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (int i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }
    return initials;
  }
}

