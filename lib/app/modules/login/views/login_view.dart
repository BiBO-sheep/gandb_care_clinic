import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.medical_services, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: isDark ? [] : [
                    BoxShadow(color: AppColors.primaryContainer.withOpacity(0.2), blurRadius: 40, spreadRadius: 10),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome back',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Continue your wellness journey with us.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              _buildLabel('EMAIL OR PHONE', isDark),
              TextField(
                controller: controller.emailController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _inputDecoration('Enter your contact details', isDark),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('PASSWORD', isDark),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot?',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFFDBCF) : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _inputDecoration('••••••••', isDark).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                        color: isDark ? Colors.white54 : AppColors.onSurfaceVariant.withOpacity(0.6),
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: isDark ? 0 : 5,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text('Login', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: isDark ? Colors.white12 : AppColors.onSurfaceVariant.withOpacity(0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : AppColors.onSurfaceVariant.withOpacity(0.4))),
                  ),
                  Expanded(child: Divider(color: isDark ? Colors.white12 : AppColors.onSurfaceVariant.withOpacity(0.2))),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: controller.isGoogleLoading.value ? null : controller.signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                      side: BorderSide(color: isDark ? Colors.white12 : AppColors.onSurfaceVariant.withOpacity(0.1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: controller.isGoogleLoading.value
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.g_mobiledata, size: 36, color: Colors.blue),
                    label: Text(
                      controller.isGoogleLoading.value ? 'Connecting...' : 'Continue with Google',
                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.onSurface),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New to the clinic? ', style: GoogleFonts.beVietnamPro(fontSize: 14, color: isDark ? Colors.white70 : AppColors.onSurfaceVariant)),
                  GestureDetector(
                    onTap: () => Get.toNamed('/register'),
                    child: Text('Sign Up', style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.beVietnamPro(color: isDark ? Colors.white30 : AppColors.onSurfaceVariant.withOpacity(0.5)),
      filled: true,
      fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? const Color(0xFF93F2F2) : AppColors.secondary, width: 2)),
    );
  }
}
