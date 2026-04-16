import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // --- HEADER ACTIONS ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inbox',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.markAllAsRead,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF90EFEF).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Mark all as read',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- TODAY SECTION ---
              _buildSectionHeader('TODAY'),
              Obx(
                () => Column(
                  children: controller.todayNotifs
                      .map(
                        (notif) => _buildNotificationCard(
                          title: notif['title'] as String,
                          time: notif['time'] as String,
                          desc: notif['desc'] as String,
                          icon: notif['icon'] as IconData,
                          color: notif['color'] as Color,
                          bgColor: notif['bgColor'] as Color,
                          isRead: notif['isRead'] as bool,
                        ),
                      )
                      .toList(),
                ),
              ),

              // --- YESTERDAY SECTION ---
              const SizedBox(height: 16),
              _buildSectionHeader('YESTERDAY'),
              Obx(
                () => Column(
                  children: controller.yesterdayNotifs
                      .map(
                        (notif) => _buildNotificationCard(
                          title: notif['title'] as String,
                          time: notif['time'] as String,
                          desc: notif['desc'] as String,
                          icon: notif['icon'] as IconData,
                          color: notif['color'] as Color,
                          bgColor: notif['bgColor'] as Color,
                          isRead: notif['isRead'] as bool,
                        ),
                      )
                      .toList(),
                ),
              ),

              // --- EARLIER SECTION ---
              const SizedBox(height: 16),
              _buildSectionHeader('EARLIER'),
              Obx(
                () => Column(
                  children: controller.earlierNotifs
                      .map(
                        (notif) => _buildNotificationCard(
                          title: notif['title'] as String,
                          time: notif['time'] as String,
                          desc: notif['desc'] as String,
                          icon: notif['icon'] as IconData,
                          color: notif['color'] as Color,
                          bgColor: notif['bgColor'] as Color,
                          isRead: notif['isRead'] as bool,
                        ),
                      )
                      .toList(),
                ),
              ),

              // --- FEATURED WELLNESS TIP ---
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFFDBCF,
                  ).withOpacity(0.3), // primary-container/10
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFDBCF).withOpacity(0.5),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalized Wellness Tip',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: Text(
                            'Keep track of your hydration today. It helps process those lab results faster!',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: -20,
                      right: -20,
                      child: Icon(
                        Icons.water_drop,
                        size: 80,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Spacing for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Helper Widget: Section Header (Garis horizontal)
 Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              // UBAH DI SINI: Gunakan const Color langsung
              color: const Color(0xFF8B7169),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 1,
              // UBAH DI SINI JUGA
              color: const Color(0xFF8B7169).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Notification Card
  Widget _buildNotificationCard({
    required String title,
    required String time,
    required String desc,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.surfaceContainerLow?.withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isRead
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indikator Titik Merah (Jika belum dibaca)
          if (!isRead)
            Container(
              margin: const EdgeInsets.only(top: 20, right: 8),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 14), // Spacing agar sejajar

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: isRead
                              ? FontWeight.w600
                              : FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Bottom Nav
  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: const Color(0xFFFAF9F6).withOpacity(0.8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'Home', Icons.home),
                _buildNavItem(1, 'History', Icons.history),
                _buildNavItem(2, 'Notifs', Icons.notifications), // Yang menyala
                _buildNavItem(3, 'Profile', Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF7F50).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.secondary.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.secondary.withOpacity(0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
