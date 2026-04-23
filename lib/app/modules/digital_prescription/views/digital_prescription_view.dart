import 'package:flutter/material.dart';
import 'package:gandb_care_clinic/app/modules/digital_prescription/controllers/digital_prescription_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalPrescriptionView extends GetView<DigitalPrescriptionController> {
  const DigitalPrescriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menangkap seluruh object record dari arguments
    final dynamic record = Get.arguments ?? {};
    final List<dynamic> prescriptions = record['prescriptions'] ?? [];
    final String diagnosis = record['diagnosis'] ?? 'Tidak ada diagnosis';
    final String doctorName = record['doctor']?['name'] ?? 'Dokter tidak tersedia';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1594824436998-d40d12e8471c?q=80&w=150&auto=format&fit=crop',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'G&B Care Clinic',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF006A6A),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF006A6A)),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resep Digital',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF006A6A),
                ),
              ),
              const SizedBox(height: 16),
              
              // Info Box (Diagnosis & Doctor)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.medical_services, color: Color(0xFF006A6A), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'DIAGNOSIS',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF006A6A),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diagnosis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF006A6A),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white, height: 1),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF006A6A), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'DOKTER',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF006A6A),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      doctorName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF006A6A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              if (prescriptions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.medical_information_outlined, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada resep obat',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...prescriptions.map((med) => _buildMedicineTile(med)).toList(),
                
              const SizedBox(height: 100), // spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineTile(dynamic med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.medication,
              color: Color(0xFF006A6A),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med['medicine_name'] ?? 'Nama Obat',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF006A6A),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.science, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      med['dosage'] ?? 'Dosis',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: Color(0xFF006A6A)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          med['rules'] ?? 'Aturan pakai',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF006A6A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
