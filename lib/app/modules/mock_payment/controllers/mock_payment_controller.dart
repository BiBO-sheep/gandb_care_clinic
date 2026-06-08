import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../invoice/controllers/invoice_controller.dart';
import '../../../data/providers/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class MockPaymentController extends GetxController {
  late String method;
  late int amount;
  late int invoiceId;

  final ApiService _apiService = ApiService();

  var isProcessing = false.obs;

  final selectedMethod = 'QRIS'.obs;
  final inputAmountController = TextEditingController();

  final List<String> availableMethods = [
    'QRIS',
    'Bank BCA (VA)',
    'Bank Mandiri (VA)',
    'Bank BNI (VA)',
    'GoPay',
    'OVO',
    'ShopeePay',
  ];

  @override
  void onClose() {
    inputAmountController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      method = args['method'] ?? 'unknown';
      amount = args['amount'] ?? 0;
      invoiceId = args['invoiceId'] ?? 0;
    } else {
      method = 'unknown';
      amount = 0;
      invoiceId = 0;
    }
  }

  void simulatePaymentSuccess() async {
    if (invoiceId == 0) {
      AppSnackbar.error('Error', 'ID Tagihan tidak valid.');
      return;
    }

    final inputAmount = int.tryParse(inputAmountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    
    if (amount <= 0) {
      AppSnackbar.error('Error', 'Total tagihan Rp 0. Tidak ada yang perlu dibayar atau tagihan belum valid.');
      return;
    }

    if (inputAmount != amount) {
      AppSnackbar.warning('Nominal Tidak Sesuai', 'Jumlah yang dimasukkan harus persis sama dengan total tagihan (Rp $amount).');
      return;
    }

    isProcessing.value = true;
    
    try {
      final response = await _apiService.post(
        'simulate-payment-success/$invoiceId',
        body: {'payment_method': selectedMethod.value},
      );
      
      final responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        // Menampilkan Notifikasi Sukses
        Get.snackbar(
          'Pembayaran Berhasil!',
          'Simulasi pembayaran telah berhasil dilakukan.',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green[800],
          snackPosition: SnackPosition.TOP,
        );

        // KEMBALI KE HALAMAN INVOICE
        Get.back();

        // Update status di InvoiceController menjadi Lunas (hanya di tampilan aplikasi)
        if (Get.isRegistered<InvoiceController>()) {
          final invoiceController = Get.find<InvoiceController>();
          if (invoiceController.invoiceData.value != null) {
            invoiceController.invoiceData.value!['status'] = 'paid';
            invoiceController.invoiceData.value!['payment_method'] = selectedMethod.value;
            invoiceController.invoiceData.refresh(); // Memicu UI untuk update
          }
        }
      } else {
        AppSnackbar.error('Gagal', responseData['message'] ?? 'Gagal mensimulasikan pembayaran.');
      }
    } catch (e) {
      AppSnackbar.error('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isProcessing.value = false;
    }
  }
}
