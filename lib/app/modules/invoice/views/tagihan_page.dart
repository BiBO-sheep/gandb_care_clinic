import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tagihan_controller.dart'; 

class TagihanPage extends StatelessWidget {
  final int appointmentId;

  TagihanPage({required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    // Panggil Controllernya
    final tagihanC = Get.put(TagihanController());

    // Panggil fungsi buat narik data pas halaman kebuka
    tagihanC.fetchDetailTagihan(appointmentId);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Rincian Pembayaran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF006A6A), // Teal tetap menonjol sebagai identitas brand
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(() {
        if (tagihanC.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF006A6A)));
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
                      color: Color(0xFF006A6A).withOpacity(0.1), // Teal Muda Adaptive
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(tagihanC.getInitials(), style: TextStyle(color: Color(0xFF006A6A), fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tagihanC.namaPasien.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      Text("Nomor Antrean: ${tagihanC.nomorAntrean.value}", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),

              // Rincian Tagihan
              Text("Rincian Biaya", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.grey[900] : Color(0xFFFFF9F5), // Coral Muda Adaptive
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Get.isDarkMode ? Colors.grey[800]! : Color(0xFFFFD1BC), width: 1), // Coral Border
                ),
                child: Column(
                  children: [
                    _buildTagihanRow("Jasa Dokter", "Rp ${tagihanC.formatRupiah(tagihanC.totalKonsultasi.value)}"),
                    SizedBox(height: 10),
                    _buildTagihanRow("Biaya Obat", "Rp ${tagihanC.formatRupiah(tagihanC.totalObat.value)}"),
                    Divider(color: Color(0xFFFFD1BC), height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Tagihan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                        Text("Rp ${tagihanC.formatRupiah(tagihanC.grandTotal.value)}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFE65A15))), // Coral
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Daftar Obat
              Text("Resep Obat Digital", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
              SizedBox(height: 15),
              ...tagihanC.medicines.map((obat) => Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Get.isDarkMode ? Colors.white12 : Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(obat['medicine_name'] ?? '-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                        Text("${obat['dosage'] ?? ''}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("${obat['rules'] ?? ''}", style: TextStyle(fontSize: 14, color: Color(0xFF006A6A), fontStyle: FontStyle.italic)),
                  ],
                ),
              )).toList(),

              // Tombol Bayar
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPaymentBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006A6A), // Teal
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: Color(0xFF006A6A).withOpacity(0.3),
                  ),
                  child: Text("Bayar Sekarang", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTagihanRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Get.isDarkMode ? Colors.white : Colors.black)),
      ],
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            SizedBox(height: 20),
            _buildPaymentOption(
              icon: Icons.point_of_sale,
              iconColor: Color(0xFF006A6A), // Teal
              title: "Bayar di Kasir",
              subtitle: "Tunjukkan rincian ini kepada staf kasir.",
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Berhasil', 
                  'Silakan menuju meja kasir.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF006A6A),
                  colorText: Colors.white,
                  margin: EdgeInsets.all(15),
                );
              },
            ),
            SizedBox(height: 15),
            _buildPaymentOption(
              icon: Icons.account_balance_wallet,
              iconColor: Color(0xFFE65A15), // Coral
              title: "Bayar Online",
              subtitle: "E-Wallet, Virtual Account, atau Midtrans.",
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Info', 
                  'Mengarahkan ke Payment Gateway...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFFE65A15),
                  colorText: Colors.white,
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
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Get.isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}
