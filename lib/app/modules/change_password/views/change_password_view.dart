import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Ubah Kata Sandi',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keamanan Akun',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pastikan kata sandi baru Anda terdiri dari minimal 8 karakter dan berbeda dari sebelumnya.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildPasswordField(
              label: 'Kata Sandi Lama',
              controller: controller.oldPasswordController,
              isObscure: controller.isOldPasswordVisible,
              onToggle: controller.toggleOldPassword,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Kata Sandi Baru',
              controller: controller.newPasswordController,
              isObscure: controller.isNewPasswordVisible,
              onToggle: controller.toggleNewPassword,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Konfirmasi Kata Sandi Baru',
              controller: controller.confirmPasswordController,
              isObscure: controller.isConfirmPasswordVisible,
              onToggle: controller.toggleConfirmPassword,
              theme: theme,
            ),
            
            const SizedBox(height: 48),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.submitChangePassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Simpan Kata Sandi'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required RxBool isObscure,
    required VoidCallback onToggle,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller,
          obscureText: !isObscure.value,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                isObscure.value ? Icons.visibility : Icons.visibility_off,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: onToggle,
            ),
          ),
        )),
      ],
    );
  }
}
