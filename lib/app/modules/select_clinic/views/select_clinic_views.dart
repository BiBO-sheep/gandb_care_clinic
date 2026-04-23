import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/select_clinic_controller.dart';

class SelectClinicView extends GetView<SelectClinicController> {
  const SelectClinicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : AppColors.secondary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
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
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: isDark ? Colors.white70 : AppColors.secondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEW APPOINTMENT',
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
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.onSurface,
                    height: 1.2,
                  ),
                  children: [
                    const TextSpan(text: 'Select Your\nSpecialist '),
                    TextSpan(
                      text: 'Clinic',
                      style: TextStyle(color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Choose the department that best suits your current health needs.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Gigi',
                      'Dental care & surgery',
                      Icons.child_care,
                      isDark ? Colors.teal.withOpacity(0.1) : const Color(0xFF90EFEF).withOpacity(0.4),
                      isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Umum',
                      'General checkups',
                      Icons.medical_services,
                      isDark ? Colors.deepOrange.withOpacity(0.1) : const Color(0xFFFFDBCF).withOpacity(0.5),
                      isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildWideClinicCard(
                'Anak',
                'Pediatric specialist for infants and children.',
                Icons.child_friendly,
                isDark ? Colors.teal.withOpacity(0.1) : const Color(0xFF00B5C0).withOpacity(0.2),
                isDark ? const Color(0xFF93F2F2) : const Color(0xFF006970),
                isDark,
                hasImage: true,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Mata',
                      'Eye health & vision',
                      Icons.visibility,
                      isDark ? Colors.teal.withOpacity(0.1) : const Color(0xFF90EFEF).withOpacity(0.4),
                      isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Jantung',
                      'Cardiac screening',
                      Icons.favorite,
                      isDark ? Colors.deepOrange.withOpacity(0.1) : const Color(0xFFFFDBCF).withOpacity(0.5),
                      isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildListClinicCard(
                'Kandungan',
                'Obstetrics & Gynecology care',
                Icons.pregnant_woman,
                isDark ? Colors.teal.withOpacity(0.1) : const Color(0xFF00B5C0).withOpacity(0.2),
                isDark ? const Color(0xFF93F2F2) : const Color(0xFF006970),
                isDark,
              ),
              const SizedBox(height: 40),

              _buildCallCenterCard(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareClinicCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => controller.onClinicSelected(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark ? [] : [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                color: isDark ? Colors.white54 : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideClinicCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    bool isDark, {
    bool hasImage = false,
  }) {
    return GestureDetector(
      onTap: () => controller.onClinicSelected(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark ? [] : [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (hasImage) ...[
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=200&auto=format&fit=crop',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListClinicCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => controller.onClinicSelected(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark ? [] : [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isDark ? Colors.white38 : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCallCenterCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF003333) : AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Can't find\nyour clinic?",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Contact our patient service for further assistance or special referrals.",
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.callCenter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: isDark ? const Color(0xFF004F54) : AppColors.secondary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Call Center',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.support_agent,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
