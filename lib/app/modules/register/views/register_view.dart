import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // Kita buat tombol custom
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.medical_services,
                color: AppColors.secondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'G&B Care Clinic',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.secondary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.secondary),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER TEXT ---
              Text(
                'Begin Your Wellness Journey',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Join our community of care. Please provide your basic details to set up your digital health profile.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // --- FORM CONTAINER ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F3F1), // surface-container-low
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      'FULL NAME',
                      Icons.person,
                      'e.g. Julian Montgomery',
                      controller.nameController,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      'PHONE NUMBER',
                      Icons.call,
                      '+1 (555) 000-0000',
                      controller.phoneController,
                      isPhone: true,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      'EMAIL ADDRESS',
                      Icons.mail,
                      'julian@example.com',
                      controller.emailController,
                      isEmail: true,
                    ),
                    const SizedBox(height: 20),
                    Obx(() => _buildInputField(
                      'PASSWORD',
                      Icons.lock,
                      '••••••••',
                      controller.passwordController,
                      isPassword: true,
                      obscureText: !controller.isPasswordVisible.value,
                      onToggleVisibility: () => controller.isPasswordVisible.toggle(),
                    )),
                    const SizedBox(height: 24),

                    // --- BLOOD TYPE GRID ---
                    _buildLabel('BLOOD TYPE'),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: controller.bloodTypes.length,
                      itemBuilder: (context, index) {
                        final type = controller.bloodTypes[index];
                        return Obx(() {
                          final isSelected =
                              controller.selectedBloodType.value == type;
                          return GestureDetector(
                            onTap: () => controller.selectBloodType(type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFFDBCF).withOpacity(0.3)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                type,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // --- TERMS CHECKBOX ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: controller.isTermsAccepted.value,
                              onChanged: controller.toggleTerms,
                              activeColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      ' and consent to medical data processing for clinic purposes.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- SUBMIT BUTTON ---
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: AppColors.primary.withOpacity(0.2),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'Create Patient Account',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- INFO CARDS ---
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.security,
                      title: 'Secure Data',
                      desc: 'End-to-end encryption for all patient records.',
                      bgColor: const Color(
                        0xFF90EFEF,
                      ).withOpacity(0.3), // secondary-container/30
                      iconColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.speed,
                      title: 'Fast Intake',
                      desc:
                          'Skip the waiting room paperwork on your first visit.',
                      bgColor: const Color(0xFFFFDBCF), // primary-fixed
                      iconColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppColors.secondary,
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool isEmail = false,
    bool isPhone = false,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : (isPhone ? TextInputType.phone : TextInputType.text),
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.beVietnamPro(
              color: AppColors.onSurfaceVariant.withOpacity(0.4),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: AppColors.secondary.withOpacity(0.4)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.secondary.withOpacity(0.4),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
