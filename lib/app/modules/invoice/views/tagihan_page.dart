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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rincian Pembayaran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF006A6A), // Teal dari web
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
                      color: Color(0xFFE0F7F7), // Teal Muda
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
                      Text(tagihanC.namaPasien.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
                      Text("Nomor Antrean: ${tagihanC.nomorAntrean.value}", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),

              // Rincian Tagihan
              Text("Rincian Biaya", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF9F5), // Coral Muda
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFFFD1BC), width: 1), // Coral Border
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
                        Text("Total Tagihan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        Text("Rp ${tagihanC.formatRupiah(tagihanC.grandTotal.value)}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFE65A15))), // Coral
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Daftar Obat
              Text("Resep Obat Digital", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 15),
              ...tagihanC.medicines.map((obat) => Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(obat['medicine_name'] ?? '-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  onPressed: () {
                    // Logic bayar lu di sini
                    Get.snackbar("Bayar", "Melanjutkan ke pembayaran...");
                  },
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
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}
