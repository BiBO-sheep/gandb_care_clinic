import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_config.dart';

class TagihanController extends GetxController {
  var isLoading = false.obs;
  
  var namaPasien = ''.obs;
  var nomorAntrean = ''.obs;
  var totalKonsultasi = 0.obs;
  var totalObat = 0.obs;
  var grandTotal = 0.obs;
  
  var medicines = <Map<String, dynamic>>[].obs;

  Future<void> fetchDetailTagihan(int appointmentId) async {
    isLoading.value = true;
    
    // Reset data sebelum mengambil yang baru
    namaPasien.value = '';
    nomorAntrean.value = '';
    totalKonsultasi.value = 0;
    totalObat.value = 0;
    grandTotal.value = 0;
    medicines.clear();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/payment-summary/$appointmentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          final data = responseData['data'];
          
          namaPasien.value = data['nama_pasien'] ?? '-';
          nomorAntrean.value = data['nomor_antrean'] ?? '-';
          
          final invoice = data['invoice'];
          // Cek apakah invoice udah terbit
          if (data['invoice'] != null) {
            // Pake double.parse() dulu biar koma desimal dari Laravel (.00) gak bikin error, baru diubah ke toInt()
            totalKonsultasi.value = double.parse(
              data['invoice']['total_consultation'].toString(),
            ).toInt();
            totalObat.value = double.parse(
              data['invoice']['total_medicines'].toString(),
            ).toInt();
            grandTotal.value = double.parse(
              data['invoice']['grand_total'].toString(),
            ).toInt();
          }
          
          if (data['medicines'] != null) {
            medicines.value = List<Map<String, dynamic>>.from(data['medicines']);
          }
        }
      }
    } catch (e) {
      print("[TagihanController] Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper untuk format Rupiah yang rapi di UI
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
