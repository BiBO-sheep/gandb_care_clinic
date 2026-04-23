import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/digital_ticket_controller.dart';

class DigitalTicketView extends GetView<DigitalTicketController> {
  const DigitalTicketView({Key? key}) : super(key: key);

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
                    color: isDark ? Colors.white : AppColors.secondary,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.close_fullscreen,
                color: isDark ? Colors.white70 : AppColors.primary,
              ),
              onPressed: controller.backToDashboard,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF90EFEF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.secondary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Booking Confirmed!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your health journey continues. We're excited to see you.",
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: isDark ? [] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF571B05) : AppColors.primary,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'NOMOR ANTREAN',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              controller.queueNumber.value,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isDark ? [] : [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                              ],
                            ),
                            child: Obx(
                              () => Image.network(
                                'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${controller.appointmentId.value}',
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                },
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code, size: 80),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Scan at the clinic reception',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Obx(
                            () => Column(
                              children: [
                                _buildDetailRow('PATIENT', controller.patientName.value, isDark),
                                const SizedBox(height: 16),
                                _buildDetailRow('SERVICE', controller.service.value, isDark),
                                const SizedBox(height: 16),
                                _buildDetailRow('DATE & TIME', controller.dateTime.value, isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        20,
                        (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0 ? Colors.transparent : (isDark ? Colors.white10 : AppColors.surfaceVariant),
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : const Color(0xFFF4F3F1),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Color(0xFF90EFEF), shape: BoxShape.circle),
                            child: const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              controller.location,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.addToCalendar,
                      icon: Icon(Icons.calendar_month, color: isDark ? const Color(0xFF006A6A) : AppColors.secondary, size: 18),
                      label: Text(
                        'Add to\nCalendar',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF006A6A) : AppColors.secondary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE0F7F7),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.shareTicket,
                      icon: const Icon(Icons.share, color: Colors.white, size: 18),
                      label: Text(
                        'Share Ticket',
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offNamed('/queue-monitor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF380C00) : const Color(0xFF380C00),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Check Queue Status',
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.status.value == 'completed') {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (controller.appointmentId.value != '0' && controller.appointmentId.value.isNotEmpty) {
                          Get.toNamed('/payment-history', arguments: controller.appointmentId.value);
                        } else {
                          Get.snackbar('Error', 'ID Janji Temu tidak ditemukan');
                        }
                      },
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: Text(
                        'Lanjut ke Pembayaran',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006A6A),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSimulating.value ? null : controller.simulateDoctorExamination,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isSimulating.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 2))
                          : Text(
                              'Simulasi Periksa (Dev Mode)',
                              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent),
                            ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.backToDashboard,
                child: Text(
                  'Back to Dashboard',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.onSurface,
          ),
        ),
      ],
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
              color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : AppColors.secondary.withOpacity(0.5)),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : AppColors.secondary.withOpacity(0.5)),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
