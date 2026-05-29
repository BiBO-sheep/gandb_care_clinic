import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mock_payment_controller.dart';

class MockPaymentView extends GetView<MockPaymentController> {
  const MockPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    bool isQris = controller.method == 'qris';
    
    // Format helper for amount
    String formatRupiah(int amount) {
      String result = amount.toString();
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isQris ? 'Pembayaran QRIS' : 'Transfer Bank (VA)',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Total Tagihan',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(controller.amount),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),

            // KOTAK INSTRUKSI / QRIS
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
                boxShadow: isDark ? [] : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (isQris) ...[
                    Icon(Icons.qr_code_2, size: 200, color: theme.colorScheme.onSurface),
                    const SizedBox(height: 16),
                    Text(
                      'Scan QR Code di atas\nmenggunakan aplikasi E-Wallet Anda.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Bank BCA',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nomor Virtual Account:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '8077 0812 3456 7890',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, size: 20, color: theme.colorScheme.primary),
                          onPressed: () {
                            Get.snackbar(
                              'Disalin', 
                              'Nomor VA berhasil disalin.',
                              backgroundColor: theme.colorScheme.primaryContainer,
                              colorText: theme.colorScheme.onPrimaryContainer,
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Atas Nama: GandB Care Clinic',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            
            const SizedBox(height: 60),

            // TOMBOL SIMULASI BAYAR
            Obx(() => ElevatedButton(
              onPressed: controller.isProcessing.value 
                  ? null 
                  : controller.simulatePaymentSuccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.isProcessing.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2),
                    )
                  : Text(
                      'Tandai Lunas (Simulasi)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
            )),
            
            const SizedBox(height: 16),
            Text(
              '*Halaman ini hanya untuk simulasi aplikasi karena gateway Midtrans belum aktif.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

