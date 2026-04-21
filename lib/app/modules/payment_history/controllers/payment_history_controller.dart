import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../api_config.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentHistoryController extends GetxController {
  // Observables untuk State Management
  var isLoading = true.obs;
  var historyList = [].obs;
  var currentIndex = 1.obs; // Tab Bottom Nav
  var errorMessage = ''.obs; // Tambahkan untuk pesan error
  
  // Observable untuk detail pembayaran (Summary)
  var invoiceData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    
    // TANGKAP ARGUMEN (ID APPOINTMENT) JIKA ADA
    final dynamic args = Get.arguments;
    if (args != null) {
      // Jika ada argumen, asumsikan itu ID untuk ringkasan pembayaran
      String appointmentId = args.toString();
      fetchPaymentSummary(appointmentId);
    } else {
      // Jika tidak ada argumen, tampilkan daftar riwayat biasa
      fetchHistory();
    }
  }

  // Fungsi narik ringkasan pembayaran dari Laravel
  Future<void> fetchPaymentSummary(String id) async {
    isLoading.value = true;
    errorMessage.value = ''; // Reset error message
    
    final url = '${ApiConfig.baseUrl}/payment-summary/$id';
    print('Memanggil API: $url');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          invoiceData.value = responseData['data'];
        } else {
          errorMessage.value = responseData['message'] ?? 'Gagal memuat rincian pembayaran';
          Get.snackbar('Error', errorMessage.value);
        }
      } else {
        errorMessage.value = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        Get.snackbar('Error', 'Gagal memuat rincian pembayaran');
      }
    } catch (e) {
      print('Error Try-Catch: $e');
      errorMessage.value = 'Exception: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi narik data daftar riwayat dari Laravel
  Future<void> fetchHistory() async {
    isLoading.value = true;
    errorMessage.value = ''; // Reset error message

    final url = '${ApiConfig.baseUrl}/history';
    print('Memanggil API: $url');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        historyList.value = responseData['data'];
      } else {
        errorMessage.value = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        Get.snackbar('Error', 'Gagal memuat riwayat');
      }
    } catch (e) {
      print('Error Try-Catch: $e');
      errorMessage.value = 'Exception: $e';
      Get.snackbar('Error', errorMessage.value);
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

  // === UI BOTTOM SHEET METODE PEMBAYARAN ===
  void showPaymentMethods() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Pilih Metode Pembayaran',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _buildMethodItem(
              'Tunai di Kasir',
              Icons.point_of_sale,
              () => processPayment('cashier'),
            ),
            const Divider(),
            _buildMethodItem(
              'QRIS / E-Wallet',
              Icons.qr_code,
              () => processPayment('qris'),
            ),
            const Divider(),
            _buildMethodItem(
              'Transfer Bank / VA',
              Icons.account_balance,
              () => processPayment('bank_transfer'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildMethodItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Future<void> processPayment(String method) async {
    print('Memproses pembayaran dengan: $method');
    Get.back(); // Tutup bottom sheet

    if (method == 'cashier') {
      Get.snackbar(
        'Instruksi Pembayaran',
        'Silakan tunjukkan Invoice ini ke meja kasir untuk menyelesaikan pembayaran.',
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
        icon: const Icon(Icons.info_outline, color: Colors.blue),
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (method == 'qris' || method == 'bank_transfer') {
      final invoiceId = invoiceData.value?['id'];
      
      if (invoiceId == null) {
        Get.snackbar('Error', 'Data invoice tidak ditemukan.');
        return;
      }

      // 1. Tampilkan Indikator Loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        // 2. HTTP POST ke Backend Laravel
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/payment/process'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'invoice_id': invoiceId,
            'method': method,
          }),
        );

        // 3. Tutup Loading
        if (Get.isDialogOpen ?? false) Get.back();

        print('Response Payment: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          if (data['success'] == true && data['snap_url'] != null) {
            // 4. Buka Snap URL menggunakan url_launcher
            final Uri url = Uri.parse(data['snap_url']);
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication, // Buka di browser HP
              );
            } else {
              Get.snackbar('Error', 'Tidak dapat membuka halaman pembayaran.');
            }
          } else {
            Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan saat memproses pembayaran.');
          }
        } else {
          Get.snackbar('Error', 'Server Error: ${response.statusCode}');
        }
      } catch (e) {
        // Tutup Loading jika terjadi error
        if (Get.isDialogOpen ?? false) Get.back();
        print('Exception Payment: $e');
        Get.snackbar('Error', 'Koneksi bermasalah: $e');
      }
    }
  }
}
