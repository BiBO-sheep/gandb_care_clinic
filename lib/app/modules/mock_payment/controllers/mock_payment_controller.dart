import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../invoice/controllers/invoice_controller.dart';

class MockPaymentController extends GetxController {
  late String method;
  late int amount;

  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      method = args['method'] ?? 'unknown';
      amount = args['amount'] ?? 0;
    } else {
      method = 'unknown';
      amount = 0;
    }
  }

  void simulatePaymentSuccess() async {
    isProcessing.value = true;
    
    // Simulasi loading 2 detik biar terasa seperti nyata
    await Future.delayed(const Duration(seconds: 2));
    
    isProcessing.value = false;

    // Menampilkan Notifikasi Sukses
    Get.snackbar(
      'Pembayaran Berhasil!',
      'Simulasi pembayaran telah berhasil dilakukan.',
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green[800],
      snackPosition: SnackPosition.TOP,
    );

    // KEMBALI KE HALAMAN INVOICE DAN UPDATE STATUS SECARA LOKAL
    Get.back(); // Tutup halaman simulasi pembayaran

    // Update status di InvoiceController menjadi Lunas (hanya di tampilan aplikasi)
    if (Get.isRegistered<InvoiceController>()) {
      final invoiceController = Get.find<InvoiceController>();
      if (invoiceController.invoiceData.value != null) {
        invoiceController.invoiceData.value!['status'] = 'paid';
        invoiceController.invoiceData.refresh(); // Memicu UI untuk update
      }
    }
  }
}
