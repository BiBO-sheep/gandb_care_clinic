import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme, isDark),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }
          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorState(theme, isDark);
          }
          if (controller.invoiceData.value == null) {
            return _buildEmptyState(theme, isDark);
          }
          return _buildInvoiceContent(controller.invoiceData.value!, theme, isDark);
        }),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.primary, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.receipt_long, size: 18, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 10),
          Text(
            'Invoice',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceContent(Map<String, dynamic> data, ThemeData theme, bool isDark) {
    final appointment = data['appointment'] ?? {};
    final medicalRecord = appointment['medical_record'] ?? {};
    final poli = appointment['poli'] ?? {};
    final user = appointment['user'] ?? {};
    final dokter = appointment['dokter'] ?? {};

    final String diagnosis = medicalRecord['diagnosis'] ?? 'Belum ada diagnosis';
    final String patientName = user['name'] ?? 'Pasien';
    final String clinicName = poli['name'] ?? 'G&B Care Clinic';
    final String doctorName = dokter['name'] ?? 'Dokter';
    final String invoiceNumber = data['invoice_number'] ?? 'INV-${data['id'] ?? '000'}';
    final String status = data['status'] ?? 'unpaid';
    final bool isPaid = status.toLowerCase() == 'paid';
    final bool isPending = status.toLowerCase() == 'pending';

    final consultationFee = double.tryParse(data['total_consultation']?.toString() ?? '0') ?? 0;
    final medicineFee = double.tryParse(data['total_medicines']?.toString() ?? '0') ?? 0;
    final grandTotal = double.tryParse(data['grand_total']?.toString() ?? '0') ?? 0;
    final List<dynamic> medicines = List<dynamic>.from(data['medicines'] ?? []);

    // Cek apakah semua obat sudah diberi harga oleh kasir
    final bool hasUnpricedMedicine = medicines.isNotEmpty &&
        medicines.any((obat) {
          final price = obat['price'];
          if (price == null) return true;
          final priceNum = double.tryParse(price.toString()) ?? 0;
          return priceNum <= 0;
        });

    // canPay: status unpaid DAN semua harga obat sudah diisi (atau tidak ada resep) DAN grandTotal > 0
    final bool canPay = !isPaid && !isPending && !hasUnpricedMedicine && grandTotal > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
                height: 1.2,
              ),
              children: [
                const TextSpan(text: 'Tagihan\n'),
                TextSpan(
                  text: 'Pembayaran',
                  style: TextStyle(color: isPaid ? Colors.green : theme.colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPaid
                  ? Colors.green.withValues(alpha: 0.1)
                  : isPending
                      ? Colors.orange.withValues(alpha: 0.1)
                      : hasUnpricedMedicine
                          ? Colors.amber.withValues(alpha: 0.1)
                          : theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPaid
                      ? Icons.check_circle
                      : isPending
                          ? Icons.hourglass_top
                          : hasUnpricedMedicine
                              ? Icons.pending_actions
                              : Icons.payment,
                  size: 14,
                  color: isPaid
                      ? Colors.green
                      : isPending
                          ? Colors.orange
                          : hasUnpricedMedicine
                              ? Colors.amber
                              : theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  isPaid
                      ? 'LUNAS'
                      : isPending
                          ? 'MENUNGGU KASIR'
                          : hasUnpricedMedicine
                              ? 'MENUNGGU HARGA OBAT'
                              : 'SIAP BAYAR',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPaid
                        ? Colors.green
                        : isPending
                            ? Colors.orange
                            : hasUnpricedMedicine
                                ? Colors.amber
                                : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark ? [] : [
                BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.person, 'PASIEN', patientName, theme, isDark),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.local_hospital, 'KLINIK / POLI', clinicName, theme, isDark),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.medical_services, 'DOKTER', 'Dr. $doctorName', theme, isDark),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.tag, 'NO. INVOICE', invoiceNumber, theme, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.medical_information, color: theme.colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Diagnosis Dokter',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  diagnosis,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark ? [] : [
                BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
              ],
              border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Rincian Biaya',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFeeRow('Jasa Dokter', controller.formatRupiah(consultationFee), theme, isDark),
                const SizedBox(height: 12),
                _buildFeeRow('Biaya Obat-obatan', controller.formatRupiah(medicineFee), theme, isDark),
                const SizedBox(height: 4),
                _buildMedicineList(medicines, theme, isDark),
                const SizedBox(height: 16),
                Container(height: 1, color: theme.colorScheme.surfaceContainerHighest),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Tagihan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                    Text(controller.formatRupiah(grandTotal), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPaymentAction(isPaid, isPending, canPay, hasUnpricedMedicine, theme, isDark),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: Text('Kembali ke Beranda', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.secondary)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // =========================================
  // HELPER: Daftar Obat (aman dari spread error)
  // =========================================
  Widget _buildMedicineList(List<dynamic> medicines, ThemeData theme, bool isDark) {
    if (medicines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
        child: Text(
          'Harga obat sedang dihitung kasir...',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.orange,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final List<Widget> rows = [];
    for (final obat in medicines) {
      rows.add(
        Padding(
          key: ValueKey(obat['id']),
          padding: const EdgeInsets.only(left: 16, top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '\u2022 ${obat['medicine_name'] ?? '-'}  (${obat['dosage'] ?? ''})\n  ${obat['rules'] ?? ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                controller.formatRupiah(obat['price']),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  // =========================================
  // HELPER: Tombol / Banner Pembayaran
  // =========================================
  Widget _buildPaymentAction(bool isPaid, bool isPending, bool canPay, bool hasUnpricedMedicine, ThemeData theme, bool isDark) {
    if (isPaid) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            Text(
              'Tagihan Lunas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      );
    }

    if (isPending) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_top, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menunggu Kasir',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.orange[700],
                    ),
                  ),
                  Text(
                    'Harga obat sedang dihitung. Tagihan final akan segera tersedia.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Status: unpaid TAPI ada obat yang belum diberi harga kasir
    if (hasUnpricedMedicine) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.pending_actions, color: Colors.amber, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menunggu Harga Obat',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.amber[800],
                    ),
                  ),
                  Text(
                    'Kasir sedang menginput harga obat resep Anda. Harap tunggu sebentar.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Jika tidak bisa bayar (misal grandTotal == 0)
    if (!canPay) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tagihan Tidak Valid',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.red[700],
                    ),
                  ),
                  Text(
                    'Total tagihan Rp 0. Silakan hubungi kasir atau resepsionis.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // canPay = unpaid + semua harga obat sudah diisi + grandTotal > 0
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.showPaymentMethods,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: isDark ? 0 : 8,
          shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: theme.colorScheme.onPrimary, size: 22),
            const SizedBox(width: 12),
            Text(
              'BAYAR SEKARANG',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7), letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String value, ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Gagal Memuat Invoice', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 8),
            Text(controller.errorMessage.value, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.fetchInvoice,
              icon: Icon(Icons.refresh, color: theme.colorScheme.onError),
              label: Text('Coba Lagi', style: TextStyle(color: theme.colorScheme.onError)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: theme.colorScheme.surfaceContainerHighest),
          const SizedBox(height: 16),
          Text('Invoice tidak ditemukan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
