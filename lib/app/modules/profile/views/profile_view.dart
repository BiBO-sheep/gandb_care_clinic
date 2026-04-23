import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

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
        title: Text(
          'My Profile',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primary),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                    border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 4),
                  ),
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.userName.value.isEmpty ? 'User' : controller.userName.value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userEmail.value.isEmpty ? 'No Email' : controller.userEmail.value,
                  style: GoogleFonts.beVietnamPro(fontSize: 14, color: isDark ? Colors.white38 : Colors.grey),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoStat('Gol. Darah', controller.userBloodType.value.isEmpty ? '-' : controller.userBloodType.value, isDark),
                      Container(height: 40, width: 1, color: isDark ? Colors.white12 : Colors.grey.withOpacity(0.3)),
                      _buildInfoStat('Tinggi', '158 cm', isDark),
                      Container(height: 40, width: 1, color: isDark ? Colors.white12 : Colors.grey.withOpacity(0.3)),
                      _buildInfoStat('Berat', '62 kg', isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildMenuItem(Icons.history, 'Riwayat Medis', () => Get.toNamed('/exam-results'), isDark),
                _buildMenuItem(Icons.receipt_long, 'Tagihan & Pembayaran', () => Get.toNamed('/payment-history'), isDark),
                _buildMenuItem(Icons.security, 'Keamanan Akun', () => Get.snackbar('Info', 'Fitur segera hadir'), isDark),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Keluar / Logout',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.red.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildInfoStat(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, bool isDark) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.onSurface,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white38 : Colors.grey),
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
              color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : Colors.grey),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : Colors.grey),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
