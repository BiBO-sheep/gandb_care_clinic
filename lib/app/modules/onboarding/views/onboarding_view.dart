import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF004F54) : AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.medical_services, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'G&B Care Clinic',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[900] : Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: isDark ? [] : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 32,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1579684385127-1ef15d508118?q=80&w=600&auto=format&fit=crop',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _buildFloatingChip(
                              icon: Icons.favorite,
                              text: 'HOLISTIC CARE',
                              color: isDark ? const Color(0xFF571B05) : const Color(0xFFFFDBCF),
                              textColor: isDark ? const Color(0xFFFFDBCF) : const Color(0xFF380C00),
                              isDark: isDark,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: -10,
                            child: _buildFloatingChip(
                              icon: Icons.verified_user,
                              text: 'EXPERT DOCTORS',
                              color: isDark ? const Color(0xFF003333) : AppColors.secondaryContainer,
                              textColor: isDark ? const Color(0xFF93F2F2) : const Color(0xFF006E6E),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.onSurface,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(text: 'Your Health,\n'),
                          TextSpan(
                            text: 'Curated.',
                            style: TextStyle(color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Experience a sanctuary for wellness\nwhere modern medicine meets\ncompassionate, personalized care.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.onGetStartedPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: isDark ? 0 : 5,
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.goToLogin,
                        child: Text(
                          'Log In',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 6,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white12 : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white12 : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.white.withOpacity(0.5)),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}
