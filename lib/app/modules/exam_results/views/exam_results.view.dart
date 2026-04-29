import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/exam_results_controller.dart';
import '../../invoice/views/tagihan_page.dart';

class ExamResultsView extends GetView<ExamResultsController> {
  const ExamResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, size: 24, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  'G&B Care Clinic',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF006A6A),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close, color: isDark ? Colors.white70 : const Color(0xFF006A6A)),
              onPressed: controller.backToHistory,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'Examination Results',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF006A6A),
                  height: 1.1,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF006A6A)));
                }
                if (controller.resultsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 80, color: isDark ? Colors.grey[700] : Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada riwayat rekam medis',
                          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[500] : Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  itemCount: controller.resultsList.length,
                  itemBuilder: (context, index) {
                    final record = controller.resultsList[index];
                    return _buildRecordCard(record, isDark);
                  },
                );
              }),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildRecordCard(dynamic record, bool isDark) {
    final appointmentDate = record['appointment']?['appointment_date'] ?? 'Tanggal tidak tersedia';
    final doctorName = record['doctor']?['name'] ?? 'Dokter tidak tersedia';
    final doctorSpec = record['doctor']?['specialization'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  appointmentDate,
                  style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white60 : Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF003333) : const Color(0xFFE0F7F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 12, color: isDark ? const Color(0xFF93F2F2) : const Color(0xFF006A6A)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            doctorName,
                            style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF93F2F2) : const Color(0xFF006A6A)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (doctorSpec.isNotEmpty) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                doctorSpec,
                style: GoogleFonts.beVietnamPro(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'DIAGNOSIS',
            style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF93F2F2) : const Color(0xFF006A6A), letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            record['diagnosis'] ?? 'Tidak ada diagnosis',
            style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF006A6A)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'TREATMENT PLAN',
            style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.white60 : Colors.grey[600], letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            record['treatment_plan'] ?? 'Tidak ada rencana perawatan',
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.goToPrescription(record),
                  icon: const Icon(Icons.medication, color: Colors.white, size: 18),
                  label: Text('Lihat Resep', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006A6A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (record['appointment']?['status'] != 'paid')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final appointmentId = record['appointment_id'] ?? record['appointment']?['id'];
                      if (appointmentId != null) {
                        Get.to(() => TagihanPage(appointmentId: appointmentId is String ? int.parse(appointmentId) : appointmentId));
                      } else {
                        Get.snackbar('Gagal', 'ID Appointment tidak ditemukan');
                      }
                    },
                    icon: const Icon(Icons.payment, color: Colors.white, size: 18),
                    label: Text('Bayar Sekarang', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7F50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: isDark ? Colors.black.withOpacity(0.8) : const Color(0xFFFAF9F6).withOpacity(0.8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'Home', Icons.home, isDark),
                _buildNavItem(1, 'History', Icons.history, isDark),
                _buildNavItem(2, 'Notifs', Icons.notifications, isDark),
                _buildNavItem(3, 'Profile', Icons.person, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, bool isDark) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7F50).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? (isDark ? const Color(0xFF93F2F2) : const Color(0xFF006A6A)) : (isDark ? Colors.white38 : Colors.grey),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? (isDark ? const Color(0xFF93F2F2) : const Color(0xFF006A6A)) : (isDark ? Colors.white38 : Colors.grey),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
