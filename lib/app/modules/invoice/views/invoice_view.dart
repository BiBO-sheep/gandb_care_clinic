import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(isDark),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorState(isDark);
          }
          if (controller.invoiceData.value == null) {
            return _buildEmptyState(isDark);
          }
          return _buildInvoiceContent(controller.invoiceData.value!, isDark);
        }),
      ),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : AppColors.secondary, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDark ? const Color(0xFF004D4D) : AppColors.secondary,
            child: Icon(Icons.receipt_long, size: 18, color: isDark ? const Color(0xFF93F2F2) : Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            'Invoice',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceContent(Map<String, dynamic> data, bool isDark) {
    final appointment = data['appointment'] ?? {};
    final medicalRecord = appointment['medical_record'] ?? {};
    final poli = appointment['poli'] ?? {};
    final user = appointment['user'] ?? {};

    final String diagnosis = medicalRecord['diagnosis'] ?? 'Tidak ada catatan diagnosis';
    final String patientName = user['name'] ?? 'Pasien';
    final String clinicName = poli['name'] ?? 'G&B Care Clinic';
    final String invoiceNumber = 'INV-${data['id'] ?? '000'}';
    final String status = data['status'] ?? 'unpaid';
    final bool isPaid = status.toLowerCase() == 'paid';

    final consultationFee = double.tryParse(data['total_consultation']?.toString() ?? '0') ?? 0;
    final medicineFee = double.tryParse(data['total_medicines']?.toString() ?? '0') ?? 0;
    final grandTotal = double.tryParse(data['grand_total']?.toString() ?? '0') ?? 0;
    final List medicines = data['medicines'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.onSurface,
                height: 1.2,
              ),
              children: [
                const TextSpan(text: 'Tagihan\n'),
                TextSpan(
                  text: 'Pembayaran',
                  style: TextStyle(color: isPaid ? Colors.green : (isDark ? const Color(0xFFFFDBCF) : AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPaid ? Colors.green.withOpacity(0.1) : (isDark ? Colors.white10 : AppColors.primary.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isPaid ? Icons.check_circle : Icons.pending, size: 14, color: isPaid ? Colors.green : (isDark ? Colors.white70 : AppColors.primary)),
                const SizedBox(width: 6),
                Text(
                  isPaid ? 'LUNAS' : 'BELUM DIBAYAR',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : (isDark ? Colors.white70 : AppColors.primary),
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
              color: isDark ? const Color(0xFF003333) : AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark ? [] : [
                BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.person, 'PASIEN', patientName, isDark),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.local_hospital, 'KLINIK / POLI', clinicName, isDark),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.tag, 'NO. INVOICE', invoiceNumber, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white10 : AppColors.surfaceVariant.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: isDark ? Colors.teal.withOpacity(0.1) : AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.medical_information, color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Diagnosis Dokter',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  diagnosis,
                  style: GoogleFonts.beVietnamPro(fontSize: 14, color: isDark ? Colors.white70 : AppColors.onSurfaceVariant, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark ? [] : [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long, color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Rincian Biaya',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFeeRow('Biaya Konsultasi & Tindakan', controller.formatRupiah(consultationFee), isDark),
                const SizedBox(height: 12),
                _buildFeeRow('Biaya Resep Obat', controller.formatRupiah(medicineFee), isDark),
                if (medicines.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...medicines.map((obat) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('• ${obat['nama_obat'] ?? '-'} x${obat['jumlah'] ?? 1}', style: GoogleFonts.beVietnamPro(fontSize: 12, color: isDark ? Colors.white54 : AppColors.onSurfaceVariant))),
                        Text(controller.formatRupiah(obat['subtotal']), style: GoogleFonts.plusJakartaSans(fontSize: 12, color: isDark ? Colors.white54 : AppColors.onSurfaceVariant)),
                      ],
                    ),
                  )),
                ],
                const SizedBox(height: 16),
                Container(height: 1, color: isDark ? Colors.white12 : AppColors.surfaceVariant.withOpacity(0.5)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Tagihan', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.onSurface)),
                    Text(controller.formatRupiah(grandTotal), style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (!isPaid)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: controller.showPaymentMethods,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF571B05) : AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: isDark ? 0 : 8,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Text('BAYAR SEKARANG', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          if (isPaid)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  Text('Tagihan Lunas', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.green[700])),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: Text('Kembali ke Beranda', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF93F2F2).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF93F2F2), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF93F2F2).withOpacity(0.7), letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.beVietnamPro(fontSize: 14, color: isDark ? Colors.white70 : AppColors.onSurfaceVariant)),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.onSurface)),
      ],
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Gagal Memuat Invoice', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.onSurface)),
            const SizedBox(height: 8),
            Text(controller.errorMessage.value, textAlign: TextAlign.center, style: GoogleFonts.beVietnamPro(fontSize: 13, color: isDark ? Colors.white60 : AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.fetchInvoice,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: isDark ? Colors.white12 : AppColors.surfaceVariant),
          const SizedBox(height: 16),
          Text('Invoice tidak ditemukan', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
