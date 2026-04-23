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
    bool isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.todayNotifs.isEmpty && controller.earlierNotifs.isEmpty) {
            return Center(
              child: Text(
                'Belum ada notifikasi.',
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
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
                        color: isDark ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.markAllAsRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF90EFEF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Mark all as read',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- TODAY SECTION ---
                if (controller.todayNotifs.isNotEmpty) ...[
                  _buildSectionHeader('TODAY', isDark),
                  Column(
                    children: controller.todayNotifs.map((notif) => _buildDynamicNotifCard(notif, isDark)).toList(),
                  ),
                ],

                // --- EARLIER SECTION ---
                if (controller.earlierNotifs.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionHeader('EARLIER', isDark),
                  Column(
                    children: controller.earlierNotifs.map((notif) => _buildDynamicNotifCard(notif, isDark)).toList(),
                  ),
                ],

                const SizedBox(height: 120), // Spasi buat navigasi bawah
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  // --- WIDGET HELPER: Header Tanggal ---
  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(height: 1, color: Colors.grey.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: Desain Kartu Otomatis Berdasarkan Tipe ---
  Widget _buildDynamicNotifCard(Map<String, dynamic> notif, bool isDark) {
    String type = notif['type'] ?? 'info';
    bool isRead = notif['isRead'] ?? false;

    // Logika Warna & Icon Dinamis
    IconData icon;
    Color iconColor;
    Color bgColor;

    if (type == 'appointment') {
      icon = Icons.calendar_month;
      iconColor = const Color(0xFFA43C12);
      bgColor = const Color(0xFFFFDBCF);
    } else if (type == 'invoice') {
      icon = Icons.receipt_long;
      iconColor = const Color(0xFF006A6A);
      bgColor = const Color(0xFF90EFEF).withOpacity(0.5);
    } else {
      icon = Icons.notifications;
      iconColor = const Color(0xFF8B7169);
      bgColor = isDark ? Colors.grey[800]! : const Color(0xFFE9E8E5);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark 
          ? (isRead ? Colors.transparent : Colors.grey[900])
          : (isRead ? Colors.grey[50] : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: isRead ? Border.all(color: Colors.grey.withOpacity(0.2)) : null,
        boxShadow: isRead || isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRead)
            Container(
              margin: const EdgeInsets.only(top: 20, right: 8),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            )
          else
            const SizedBox(width: 14),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
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
                        notif['title'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      notif['time'],
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notif['desc'],
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
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

  // --- WIDGET HELPER: Bottom Nav ---
  Widget _buildBottomNav(bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: isDark ? Colors.black.withOpacity(0.8) : const Color(0xFFFAF9F6).withOpacity(0.8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, 'Home', Icons.home),
              _buildNavItem(1, 'History', Icons.history),
              _buildNavItem(2, 'Notifs', Icons.notifications),
              _buildNavItem(3, 'Profile', Icons.person),
            ],
          )),
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
          color: isSelected ? const Color(0xFFFF7F50).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : Colors.grey,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}