import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.medical_services, color: theme.colorScheme.onPrimaryContainer, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              'G&B Care Clinic',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
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
                    BoxShadow(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 10),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome back',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Continue your wellness journey with us.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              _buildLabel('EMAIL OR PHONE', theme),
              TextField(
                controller: controller.emailController,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter your contact details',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('PASSWORD', theme),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot?',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
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
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
                    child: controller.isLoading.value
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text('Login'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: isDark ? Colors.white12 : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
                  ),
                  Expanded(child: Divider(color: isDark ? Colors.white12 : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2))),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: controller.isGoogleLoading.value ? null : controller.signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.isGoogleLoading.value
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                            : Image.asset('assets/images/google_logo.png', width: 24, height: 24),
                        const SizedBox(width: 12),
                        Text(
                          controller.isGoogleLoading.value ? 'Connecting...' : 'Continue with Google',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New to the clinic? ', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  GestureDetector(
                    onTap: () => Get.toNamed('/register'),
                    child: Text('Sign Up', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
