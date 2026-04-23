import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.primary,
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
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 4,
                        ),
                      ),
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Text(
                        controller.profileCtrl.userName.value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.onSurface,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.profileCtrl.userEmail.value,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle(Icons.person_outline, 'Edit Profile', isDark),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : const Color(0xFFF4F3F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSettingsTextField('Full Name', controller.nameController, isDark),
                    const SizedBox(height: 12),
                    _buildSettingsTextField('Email', controller.emailController, isDark),
                    const SizedBox(height: 12),
                    _buildSettingsTextField('Phone', controller.phoneController, isDark),
                    const SizedBox(height: 12),
                    _buildSettingsTextField('Address', controller.addressController, isDark, maxLines: 2),
                    const SizedBox(height: 20),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value ? null : controller.updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: isDark ? 0 : 4,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Simpan Perubahan'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(Icons.display_settings, 'Display & App Info', isDark),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : const Color(0xFFF4F3F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => _buildToggleItem(
                        title: 'Dark Mode',
                        subtitle: 'Ubah tema menjadi gelap',
                        icon: Icons.dark_mode,
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleDarkMode,
                        isDark: isDark,
                      ),
                    ),
                    _buildDivider(),
                    _buildLinkItem('Privacy Policy', controller.openPrivacyPolicy, isDark),
                    _buildDivider(),
                    _buildLinkItem('Terms of Service', controller.openTerms, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.signOut,
                  icon: const Icon(Icons.logout, color: Color(0xFFBA1A1A), size: 20),
                  label: Text(
                    'Sign Out',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFBA1A1A),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF410002) : const Color(0xFFFFDAD6),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildSectionTitle(IconData icon, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Row(
        children: [
          Icon(icon, color: isDark ? const Color(0xFFFFDBCF) : AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.onSurface,
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
    required bool isDark,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF57423B), size: 24),
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
                    color: isDark ? Colors.white : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String title, VoidCallback onTap, bool isDark) {
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
                color: isDark ? Colors.white : AppColors.onSurface,
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildSettingsTextField(
    String label,
    TextEditingController textController,
    bool isDark, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: textController,
          maxLines: maxLines,
          style: GoogleFonts.beVietnamPro(fontSize: 14, color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF93F2F2) : AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
