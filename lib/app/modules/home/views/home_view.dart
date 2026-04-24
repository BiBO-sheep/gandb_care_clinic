import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gandb_care_clinic/app/data/models/appointment_model.dart';
import 'package:gandb_care_clinic/app/data/models/health_tip_model.dart';
import 'package:gandb_care_clinic/app/modules/home/views/home_shimmer_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => controller.isLoading.value
              ? const HomeShimmerView()
              : _buildHomeContent(isDark),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildHomeContent(bool isDark) {
    return Column(
      children: [
        _buildCustomAppBar(isDark),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildWelcomeSection(isDark),
                const SizedBox(height: 32),
                _buildAppointmentCard(isDark),
                const SizedBox(height: 32),
                _buildQuickActions(isDark),
                const SizedBox(height: 32),
                _buildHealthTips(isDark),
                const SizedBox(height: 32),
                _buildPoliGrid(
                  isDark,
                ), // 👈 Udah diganti jadi Grid biar nampil semua
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildWelcomeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${controller.patientName.value} 👋',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your health journey is looking great today.',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(bool isDark) {
    return Obx(() {
      final appointment = controller.upcomingAppointment.value;

      if (appointment == null) {
        return _buildNoAppointmentCard(isDark);
      }

      return GestureDetector(
        onTap: () => Get.toNamed('/queue-monitor'),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'UPCOMING APPOINTMENT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Icon(Icons.event, color: Colors.white, size: 20),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                appointment.poli.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.medical_services,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dr. ${appointment.dokter?.name ?? 'Assigned Doctor'} • ${appointment.poli.ruangan}',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardDetail(
                        'DATE & TIME',
                        '${appointment.tanggal}, ${appointment.jam}',
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _buildCardDetail(
                        'QUEUE ID',
                        appointment.queueNumber,
                        alignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNoAppointmentCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : const Color(0xFFF4F3F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: isDark ? Colors.white24 : Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No Upcoming Appointment',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep track of your health journey by booking a new session.',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetail(
    String title,
    String value, {
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.6),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.secondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionItem(
              'Book\nAppointment',
              Icons.add_circle,
              const Color(0xFF90EFEF),
              AppColors.secondary,
              isDark,
            ),
            _buildActionItem(
              'My History',
              Icons.history,
              const Color(0xFFFFDBCF),
              AppColors.primary,
              isDark,
            ),
            _buildActionItem(
              'Poli Info',
              Icons.info,
              const Color(0xFF7AF4FF),
              const Color(0xFF006970),
              isDark,
            ),
            // Tombol Active Prescription sudah resmi dihapus sesuai permintaan Bos Besar! 💥
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(
    String title,
    IconData icon,
    Color bgColor,
    Color iconColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => controller.onQuickActionTapped(title.replaceAll('\n', ' ')),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : const Color(0xFFF4F3F1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.onSurface,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTips(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HEALTH TIPS',
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.secondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.healthTips.length,
            itemBuilder: (context, index) {
              final tip = controller.healthTips[index];
              return _buildTipCard(tip, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(HealthTipModel tip, bool isDark) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.surfaceVariant.withOpacity(isDark ? 0.1 : 0.5),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white10
                          : AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconData(tip.icon),
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white10
                          : AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tip.category.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFF90EFEF)
                            : AppColors.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    tip.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.description,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white60
                          : AppColors.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.network(
                tip.image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                // 👇 INI OBATNYA BOS! Kalau link gambar mati, diganti gradasi cantik 👇
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? Colors.grey[800]!
                              : AppColors.primary.withOpacity(0.3),
                          isDark
                              ? Colors.grey[900]!
                              : AppColors.secondary.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.health_and_safety,
                        color: isDark ? Colors.white24 : Colors.white70,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop;
      case 'directions_run':
        return Icons.directions_run;
      case 'restaurant':
        return Icons.restaurant;
      case 'bedtime':
        return Icons.bedtime;
      case 'spa':
        return Icons.spa;
      default:
        return Icons.health_and_safety;
    }
  }

  // 👇 INI UDAH DIROMBAK JADI GRID BIAR NAMPILIN SEMUA POLI 👇
  Widget _buildPoliGrid(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'OUR CLINICS',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : AppColors.secondary,
                letterSpacing: 2,
              ),
            ),
            Text(
              'See All',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.listPoli.isEmpty) {
            return Text(
              'Poli belum tersedia',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Biar nggak bentrok sama scroll layar utama
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1, // Ngatur proporsi kotak polinya
            ),
            itemCount: controller.listPoli.length,
            itemBuilder: (context, index) {
              final poli = controller.listPoli[index];
              return _buildPoliCard(poli, isDark);
            },
          );
        }),
      ],
    );
  }

  Widget _buildPoliCard(dynamic poli, bool isDark) {
    final String namaPoli = poli['name']?.toString() ?? 'Poli Umum';
    final String ruanganPoli = poli['ruangan']?.toString() ?? 'Belum ada ruang';

    IconData iconPoli = Icons.medical_services;
    if (namaPoli.toLowerCase().contains('gigi')) iconPoli = Icons.sick;
    if (namaPoli.toLowerCase().contains('jantung'))
      iconPoli = Icons.monitor_heart;
    if (namaPoli.toLowerCase().contains('anak')) iconPoli = Icons.child_care;
    if (namaPoli.toLowerCase().contains('mata'))
      iconPoli = Icons.remove_red_eye;

    return Container(
      // width dan margin horizontal gua hapus karena sekarang udah otomatis diatur sama GridView
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.surfaceVariant.withOpacity(isDark ? 0.1 : 0.5),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconPoli, color: AppColors.primary, size: 24),
          ),
          const Spacer(),
          Text(
            namaPoli,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            ruanganPoli,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : AppColors.onSurfaceVariant,
            ),
          ),
        ],
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
          child: Row(
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
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, bool isDark) {
    return Obx(() {
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
    });
  }
}
