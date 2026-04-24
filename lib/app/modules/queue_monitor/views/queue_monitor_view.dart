import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/queue_monitor_controller.dart';

class QueueMonitorView extends GetView<QueueMonitorController> {
  const QueueMonitorView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildCustomAppBar(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHeroSection(isDark),
                    const SizedBox(height: 24),
                    _buildMainQueueCard(isDark),
                    const SizedBox(height: 16),
                    _buildTimelineCard(isDark),
                    const SizedBox(height: 16),
                    _buildBentoDetails(
                      isDark,
                    ), // 👈 Ini udah dibenerin buat nampilin data asli
                    const SizedBox(height: 16),
                    _buildInfoBanner(isDark),
                    const SizedBox(height: 16),
                    _buildImageAnchor(
                      isDark,
                    ), // 👈 Ini juga ditambahin anti 404
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildCustomAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 28, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'G&B Care Clinic',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.secondary,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: isDark ? Colors.white70 : AppColors.secondary,
            ),
            onPressed: controller.openQRScanner,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CURRENT SESSION',
          style: GoogleFonts.beVietnamPro(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your health journey is in\nprogress.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.onSurface,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMainQueueCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF571B05) : const Color(0xFFFF7F50),
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFFFF7F50).withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: Column(
        children: [
          Text(
            'QUEUE POSITION',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Number',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF380C00),
              height: 1,
            ),
          ),
          Obx(
            () => Text(
              controller.myQueueNumber.value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? const Color(0xFFFFDBCF)
                    : const Color(0xFF380C00),
                height: 1,
              ),
            ),
          ),
          Container(
            height: 3,
            width: 40,
            color: isDark
                ? Colors.white24
                : const Color(0xFF380C00).withOpacity(0.2),
            margin: const EdgeInsets.symmetric(vertical: 24),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white10
                  : const Color(0xFF380C00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.list_alt,
                  color: isDark ? Colors.white70 : const Color(0xFF380C00),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    'Now Serving: ${controller.nowServing.value}',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF380C00),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : const Color(0xFFF4F3F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated wait',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white38
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '~${controller.estimatedWaitTime.value} min',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFFFFDBCF)
                            : const Color(0xFF380C00),
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF571B05)
                      : const Color(0xFFFFDBCF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hourglass_top,
                  color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 2,
                width: double.infinity,
                color: isDark ? Colors.white10 : AppColors.surfaceVariant,
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 2,
                  width: 200,
                  color: AppColors.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimelineDot(isCompleted: true, isDark: isDark),
                  _buildTimelineDot(isCompleted: true, isDark: isDark),
                  _buildTimelineDot(isCurrent: true, isDark: isDark),
                  _buildTimelineDot(isFuture: true, isDark: isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHECK-IN',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : AppColors.onSurface,
                ),
              ),
              Text(
                'PRE-SCREEN',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : AppColors.onSurface,
                ),
              ),
              Text(
                'WAITING',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'CONSULT',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white24 : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot({
    bool isCompleted = false,
    bool isCurrent = false,
    bool isFuture = false,
    required bool isDark,
  }) {
    if (isCompleted) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.grey[900]! : Colors.white,
            width: 2,
          ),
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 10),
      );
    } else if (isCurrent) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: isDark ? Colors.white12 : AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
      );
    }
  }

  // 👇 INI YANG DIBENERIN BIAR NAMPILIN DATA DARI LARAVEL 👇
  Widget _buildBentoDetails(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 140,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF003333) : const Color(0xFFE0F7F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.medical_services,
                  color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
                  size: 28,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSIGNED DOCTOR',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFF93F2F2)
                            : AppColors.secondary,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.doctorName.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF004F54),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 140,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : const Color(0xFFE9E8E5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.meeting_room,
                      color: isDark
                          ? Colors.white38
                          : AppColors.onSurfaceVariant,
                      size: 24,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white10
                              : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(
                          () => Text(
                            controller.clinicName.value.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOCATION',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white38
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.roomName.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : AppColors.surfaceVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF7AF4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Color(0xFF006970),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'While you wait',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enjoy complimentary herbal tea at our lounge or browse the wellness library in the digital app.',
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

  // 👇 INI JUGA DITAMBAHIN ANTI ERROR 404 👇
  Widget _buildImageAnchor(bool isDark) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Colors.grey[800] : Colors.grey[300], // Warna fallback
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=600&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: isDark ? Colors.white24 : Colors.grey[500],
                    size: 40,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Clinic Sanctuary Space',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: isDark
              ? Colors.black.withOpacity(0.8)
              : const Color(0xFFFAF9F6).withOpacity(0.8),
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
                  : (isDark
                        ? Colors.white38
                        : AppColors.secondary.withOpacity(0.5)),
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
                    : (isDark
                          ? Colors.white38
                          : AppColors.secondary.withOpacity(0.5)),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
