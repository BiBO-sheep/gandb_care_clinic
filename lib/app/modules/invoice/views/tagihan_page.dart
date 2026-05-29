import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tagihan_controller.dart'; 

class TagihanPage extends StatelessWidget {
  final int appointmentId;

  const TagihanPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    // Panggil Controllernya
    final tagihanC = Get.put(TagihanController());

    // Panggil fungsi buat narik data pas halaman kebuka
    tagihanC.fetchDetailTagihan(appointmentId);
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Rincian Pembayaran", style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary, // Teal tetap menonjol sebagai identitas brand
        elevation: 0,
        leading: BackButton(color: theme.colorScheme.onPrimary),
      ),
      body: Obx(() {
        if (tagihanC.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Pasien
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer, // Teal Muda Adaptive
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(tagihanC.getInitials(), style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tagihanC.namaPasien.value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
                      Text("Nomor Antrean: ${tagihanC.nomorAntrean.value}", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),

              // Rincian Tagihan
              Text("Rincian Biaya", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer, // Coral Muda Adaptive
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.secondary.withValues(alpha: 0.3), width: 1), // Coral Border
                ),
                child: Column(
                  children: [
                    _buildTagihanRow("Jasa Dokter", "Rp ${tagihanC.formatRupiah(tagihanC.totalKonsultasi.value)}", theme, isDark),
                    SizedBox(height: 10),
                    _buildTagihanRow("Biaya Obat", "Rp ${tagihanC.formatRupiah(tagihanC.totalObat.value)}", theme, isDark),
                    Divider(color: theme.colorScheme.secondary.withValues(alpha: 0.3), height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Tagihan", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer)),
                        Text("Rp ${tagihanC.formatRupiah(tagihanC.grandTotal.value)}", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.secondary)), // Coral
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Daftar Obat
              Text("Resep Obat Digital", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              SizedBox(height: 15),
              ...tagihanC.medicines.map((obat) => Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: theme.colorScheme.surfaceContainerHighest, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(obat['medicine_name'] ?? '-', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                        Text("${obat['dosage'] ?? ''}", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("${obat['rules'] ?? ''}", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary, fontStyle: FontStyle.italic)),
                  ],
                ),
              )),

              // Tombol Bayar
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPaymentBottomSheet(context, theme, isDark),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary, // Teal
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  child: Text("Bayar Sekarang", style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTagihanRow(String label, String value, ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7))),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer)),
      ],
    );
  }

  void _showPaymentBottomSheet(BuildContext context, ThemeData theme, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Pilih Metode Pembayaran",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            SizedBox(height: 20),
            _buildPaymentOption(
              icon: Icons.point_of_sale,
              iconColor: theme.colorScheme.primary, // Teal
              title: "Bayar di Kasir",
              subtitle: "Tunjukkan rincian ini kepada staf kasir.",
              theme: theme,
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Berhasil', 
                  'Silakan menuju meja kasir.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: theme.colorScheme.primary,
                  colorText: theme.colorScheme.onPrimary,
                  margin: EdgeInsets.all(15),
                );
              },
            ),
            SizedBox(height: 15),
            _buildPaymentOption(
              icon: Icons.account_balance_wallet,
              iconColor: theme.colorScheme.secondary, // Coral
              title: "Bayar Online",
              subtitle: "E-Wallet, Virtual Account, atau Midtrans.",
              theme: theme,
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Info', 
                  'Mengarahkan ke Payment Gateway...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: theme.colorScheme.secondary,
                  colorText: theme.colorScheme.onSecondary,
                  margin: EdgeInsets.all(15),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

