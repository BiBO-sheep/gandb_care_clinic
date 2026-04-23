import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api_config.dart';
import '../../../../core/theme/app_colors.dart';

class InvoiceController extends GetxController {
  // ==========================================
  // STATE MANAGEMENT
  // ==========================================
  var isLoading = true.obs;
  var isPaying = false.obs;
  var errorMessage = ''.obs;

  // Data Invoice dari Laravel
  var invoiceData = Rxn<Map<String, dynamic>>();

  // ID Appointment yang dibawa dari halaman sebelumnya
  late int appointmentId;

  @override
  void onInit() {
    super.onInit();

    // Tangkap argument appointment_id dari halaman sebelumnya
    final dynamic args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      appointmentId = args['appointment_id'] ?? 0;
    } else if (args != null) {
      appointmentId = int.tryParse(args.toString()) ?? 0;
    } else {
      appointmentId = 0;
    }

    if (appointmentId > 0) {
      fetchInvoice();
    } else {
      isLoading.value = false;
      errorMessage.value = 'ID Appointment tidak ditemukan.';
    }
  }

  // ==========================================
  // 1. AMBIL DATA INVOICE DARI LARAVEL
  //    GET /api/invoice/{appointment_id}
  // ==========================================
  Future<void> fetchInvoice() async {
    isLoading.value = true;
    errorMessage.value = '';

    final url = '${ApiConfig.baseUrl}/invoice/$appointmentId';
    print('[InvoiceController] GET -> $url');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('[InvoiceController] Status: ${response.statusCode}');
      print('[InvoiceController] Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          invoiceData.value = responseData['data'];
        } else {
          errorMessage.value =
              responseData['message'] ?? 'Gagal memuat data invoice.';
        }
      } else {
        errorMessage.value =
            'Server Error ${response.statusCode}: ${response.reasonPhrase}';
      }
    } catch (e) {
      print('[InvoiceController] Exception: $e');
      errorMessage.value = 'Koneksi ke server terputus.';
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 2. PROSES PEMBAYARAN
  //    POST /api/payment/process
  // ==========================================
  Future<void> processPayment(String method) async {
    // Tutup bottom sheet kalau ada
    if (Get.isBottomSheetOpen ?? false) Get.back();

    // Kalau bayar tunai, cukup kasih instruksi
    if (method == 'cashier') {
      Get.snackbar(
        'Instruksi Pembayaran',
        'Silakan tunjukkan Invoice ini ke meja kasir untuk menyelesaikan pembayaran.',
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
        icon: const Icon(Icons.info_outline, color: Colors.blue),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Online payment (QRIS / Bank Transfer)
    final invoiceId = invoiceData.value?['id'];
    if (invoiceId == null) {
      Get.snackbar('Error', 'Data invoice tidak ditemukan.');
      return;
    }

    // Tampilkan loading dialog
    isPaying.value = true;
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      barrierDismissible: false,
    );

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

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

      // Tutup loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      print('[InvoiceController] Payment Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['snap_url'] != null) {
          // Buka URL pembayaran di browser
          final Uri paymentUrl = Uri.parse(data['snap_url']);
          if (await canLaunchUrl(paymentUrl)) {
            await launchUrl(
              paymentUrl,
              mode: LaunchMode.externalApplication,
            );
          } else {
            Get.snackbar('Error', 'Tidak dapat membuka halaman pembayaran.');
          }
        } else if (data['success'] == true) {
          // Pembayaran langsung sukses (misal kasir)
          Get.snackbar(
            'Pembayaran Berhasil!',
            data['message'] ?? 'Invoice telah lunas.',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green[800],
            snackPosition: SnackPosition.TOP,
          );
          // Refresh data invoice
          fetchInvoice();
        } else {
          Get.snackbar(
            'Gagal',
            data['message'] ?? 'Terjadi kesalahan saat memproses pembayaran.',
          );
        }
      } else {
        Get.snackbar('Error', 'Server Error: ${response.statusCode}');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print('[InvoiceController] Payment Exception: $e');
      Get.snackbar('Error', 'Koneksi bermasalah: $e');
    } finally {
      isPaying.value = false;
    }
  }

  // ==========================================
  // 3. BOTTOM SHEET PILIH METODE BAYAR
  // ==========================================
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
            // Handle bar
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
            const SizedBox(height: 8),
            Text(
              'Pilih cara yang paling nyaman untuk Anda',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            _buildMethodItem(
              'Tunai di Kasir',
              'Bayar langsung di meja resepsionis',
              Icons.point_of_sale,
              () => processPayment('cashier'),
            ),
            const Divider(height: 1),
            _buildMethodItem(
              'QRIS / E-Wallet',
              'GoPay, OVO, DANA, ShopeePay',
              Icons.qr_code,
              () => processPayment('qris'),
            ),
            const Divider(height: 1),
            _buildMethodItem(
              'Transfer Bank / VA',
              'BCA, Mandiri, BNI, BRI',
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

  Widget _buildMethodItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }

  // ==========================================
  // HELPER: Format angka ke Rupiah
  // ==========================================
  String formatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    int value = 0;
    
    if (amount is int) {
      value = amount;
    } else if (amount is double) {
      value = amount.toInt();
    } else {
      // 👇 INI OBATNYA BOS! Kalau dia string "311000.00", kita ubah dulu ke double, baru ke int
      value = double.tryParse(amount.toString())?.toInt() ?? 0;
    }
    
    // Format manual ribuan
    String result = value.toString();
    String formatted = '';
    int count = 0;
    for (int i = result.length - 1; i >= 0; i--) {
      count++;
      formatted = result[i] + formatted;
      if (count % 3 == 0 && i != 0) {
        formatted = '.$formatted';
      }
    }
    return 'Rp $formatted';
  }
}
