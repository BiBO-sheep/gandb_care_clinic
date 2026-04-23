import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Obx(() {
          // === STATE: LOADING ===
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // === STATE: ERROR ===
          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorState();
          }

          // === STATE: DATA KOSONG ===
          if (controller.invoiceData.value == null) {
            return _buildEmptyState();
          }

          // === STATE: INVOICE READY ===
          return _buildInvoiceContent(controller.invoiceData.value!);
        }),
      ),
    );
  }

  // ==========================================
  // APP BAR
  // ==========================================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.secondary,
          size: 20,
        ),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.receipt_long, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            'Invoice',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KONTEN UTAMA INVOICE (SUDAH DISESUAIKAN DENGAN API LARAVEL)
  // ==========================================
  Widget _buildInvoiceContent(Map<String, dynamic> data) {
    // 👇 MENGAMBIL DATA DARI JSON BARU LARAVEL 👇

    // Tarik relasi bersarang (nested JSON)
    final appointment = data['appointment'] ?? {};
    final medicalRecord = appointment['medical_record'] ?? {};
    final poli = appointment['poli'] ?? {};
    final user = appointment['user'] ?? {};

    // Data teks
    final String diagnosis =
        medicalRecord['diagnosis'] ?? 'Tidak ada catatan diagnosis';
    final String patientName = user['name'] ?? 'Pasien';
    final String clinicName = poli['name'] ?? 'G&B Care Clinic';
    final String invoiceNumber = 'INV-${data['id'] ?? '000'}';
    final String status = data['status'] ?? 'unpaid';
    final bool isPaid = status.toLowerCase() == 'paid';

    // Data Biaya (Di-parse ke double karena Laravel ngirim string "261000.00")
    final consultationFee =
        double.tryParse(data['total_consultation']?.toString() ?? '0') ?? 0;
    final medicineFee =
        double.tryParse(data['total_medicines']?.toString() ?? '0') ?? 0;
    final grandTotal =
        double.tryParse(data['grand_total']?.toString() ?? '0') ?? 0;

    // List obat (kalau ada di API nanti)
    final List medicines = data['medicines'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Text(
            'INVOICE',
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                height: 1.2,
              ),
              children: [
                const TextSpan(text: 'Tagihan\n'),
                TextSpan(
                  text: 'Pembayaran',
                  style: TextStyle(
                    color: isPaid ? Colors.green : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Badge Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPaid
                  ? Colors.green.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPaid ? Icons.check_circle : Icons.pending,
                  size: 14,
                  color: isPaid ? Colors.green : AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  isPaid ? 'LUNAS' : 'BELUM DIBAYAR',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- KARTU INFO PASIEN ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.person, 'PASIEN', patientName),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.local_hospital,
                  'KLINIK / POLI',
                  clinicName,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.tag, 'NO. INVOICE', invoiceNumber),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- KARTU DIAGNOSIS ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.surfaceVariant.withOpacity(0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.medical_information,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Diagnosis Dokter',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  diagnosis,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- RINCIAN BIAYA ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rincian Biaya',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Biaya Konsultasi
                _buildFeeRow(
                  'Biaya Konsultasi & Tindakan',
                  controller.formatRupiah(consultationFee),
                ),
                const SizedBox(height: 12),

                // Biaya Obat
                _buildFeeRow(
                  'Biaya Resep Obat',
                  controller.formatRupiah(medicineFee),
                ),

                if (medicines.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...medicines.map(
                    (obat) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '• ${obat['nama_obat'] ?? '-'} x${obat['jumlah'] ?? 1}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Text(
                            controller.formatRupiah(obat['subtotal']),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: AppColors.surfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(height: 16),

                // Grand Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Tagihan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      controller.formatRupiah(grandTotal),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // --- TOMBOL BAYAR SEKARANG ---
          if (!isPaid)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: controller.showPaymentMethods,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'BAYAR SEKARANG',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // --- BADGE LUNAS ---
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
                  Text(
                    'Tagihan Lunas',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Tombol kembali ke Home
          Center(
            child: TextButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: Text(
                'Kembali ke Beranda',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF93F2F2).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF93F2F2), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF93F2F2).withOpacity(0.7),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Invoice',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.fetchInvoice,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: AppColors.surfaceVariant),
          const SizedBox(height: 16),
          Text(
            'Invoice tidak ditemukan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
