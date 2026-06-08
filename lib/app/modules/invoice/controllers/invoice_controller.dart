import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/providers/api_service.dart';

class InvoiceController extends GetxController {
  var isLoading = true.obs;
  var isPaying = false.obs;
  var errorMessage = ''.obs;

  var invoiceData = Rxn<Map<String, dynamic>>();
  late int appointmentId;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();

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

  Future<void> fetchInvoice() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.get('invoice/$appointmentId');
      final responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        invoiceData.value = responseData['data'];
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Gagal memuat data invoice.';
      }
    } catch (e) {
      debugPrint('[InvoiceController] Exception: $e');
      if (e.toString().contains('Sesi telah berakhir')) {
        Get.offAllNamed('/login');
      } else {
        errorMessage.value = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processPayment(String method) async {
    if (Get.isBottomSheetOpen ?? false) Get.back();

    if (method == 'cashier') {
      Get.snackbar(
        'Instruksi Pembayaran',
        'Silakan tunjukkan Invoice ini ke meja kasir untuk menyelesaikan pembayaran.',
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        colorText: Colors.blue,
        icon: const Icon(Icons.info_outline, color: Colors.blue),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final invoiceId = invoiceData.value?['id'];
    if (invoiceId == null) {
      Get.snackbar('Error', 'Data invoice tidak ditemukan.');
      return;
    }

    final totalAmount = invoiceData.value?['total_amount'] ?? 0;
    
    int parsedAmount = 0;
    if (totalAmount is int) {
      parsedAmount = totalAmount;
    } else if (totalAmount is double) {
      parsedAmount = totalAmount.toInt();
    } else {
      parsedAmount = double.tryParse(totalAmount.toString())?.toInt() ?? 0;
    }

    Get.toNamed('/mock-payment', arguments: {
      'method': method,
      'amount': parsedAmount,
      'invoiceId': invoiceId,
    });
  }

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
              'Payment Gateway (Virtual)',
              'Bayar via QRIS, Bank Transfer, E-Wallet',
              Icons.payment,
              () => processPayment('virtual'),
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
          color: AppColors.primary.withValues(alpha: 0.1),
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

  String formatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    int value = 0;
    
    if (amount is int) {
      value = amount;
    } else if (amount is double) {
      value = amount.toInt();
    } else {
      value = double.tryParse(amount.toString())?.toInt() ?? 0;
    }
    
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

