import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER PROFIL SINGKAT ---
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceContainerLow ?? Colors.grey,
                          width: 4,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
                          ), // Placeholder Wajah
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Robert J. Wilson',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Patient ID: GB-10023',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // --- EDIT PROFILE SECTION ---
              _buildSectionTitle(Icons.person_outline, 'Edit Profile'),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSettingsTextField('Full Name', controller.nameController),
                    const SizedBox(height: 12),
                    _buildSettingsTextField('Email', controller.emailController),
                    const SizedBox(height: 12),
                    _buildSettingsTextField('Phone', controller.phoneController),
                    const SizedBox(height: 12),
                    _buildSettingsTextField('Address', controller.addressController, maxLines: 2),
                    const SizedBox(height: 20),
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Simpan Perubahan'),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- NOTIFICATIONS SECTION ---
              _buildSectionTitle(Icons.notifications, 'Notifications'),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => _buildToggleItem(
                        title: 'Appointment Reminders',
                        subtitle: 'Get alerts for upcoming clinic visits',
                        value: controller.appointmentReminders.value,
                        onChanged: controller.toggleAppointment,
                      ),
                    ),
                    _buildDivider(),
                    Obx(
                      () => _buildToggleItem(
                        title: 'Lab Result Alerts',
                        subtitle: 'Immediate notifications for new reports',
                        value: controller.labResultAlerts.value,
                        onChanged: controller.toggleLabResults,
                      ),
                    ),
                    _buildDivider(),
                    Obx(
                      () => _buildToggleItem(
                        title: 'Wellness Tips',
                        subtitle: 'Curated health advice and insights',
                        value: controller.wellnessTips.value,
                        onChanged: controller.toggleWellnessTips,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SECURITY SECTION ---
              _buildSectionTitle(Icons.security, 'Security'),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildActionItem(
                      title: 'Change Password',
                      subtitle: 'Last updated 3 months ago',
                      icon: Icons.lock_reset,
                      onTap: controller.changePassword,
                    ),
                    _buildDivider(),
                    Obx(
                      () => _buildToggleItem(
                        title: 'Biometric Login',
                        subtitle: 'Use FaceID or Fingerprint',
                        icon: Icons.fingerprint, // Icon ekstra untuk keamanan
                        value: controller.biometricLogin.value,
                        onChanged: controller.toggleBiometric,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- APP INFO SECTION ---
              _buildSectionTitle(Icons.info, 'App Info'),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Version',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            '2.4.0 (Build 108)',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildDivider(),
                    _buildLinkItem(
                      'Privacy Policy',
                      controller.openPrivacyPolicy,
                    ),
                    _buildDivider(),
                    _buildLinkItem('Terms of Service', controller.openTerms),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- SIGN OUT BUTTON ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.signOut,
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFBA1A1A),
                    size: 20,
                  ),
                  label: Text(
                    'Sign Out',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFBA1A1A),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDAD6), // error-container
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- KOMPONEN BANTUAN UNTUK MENGURANGI KODE BERULANG ---

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: const Color(0xFF57423B),
              size: 24,
            ), // on-surface-variant
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF57423B), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF8B7169),
              size: 20,
            ), // outline
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const Icon(
              Icons.open_in_new,
              color: Color(0xFF8B7169),
              size: 18,
            ), // outline
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.surfaceVariant.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildSettingsTextField(String label, TextEditingController textController, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: textController,
          maxLines: maxLines,
          style: GoogleFonts.beVietnamPro(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
