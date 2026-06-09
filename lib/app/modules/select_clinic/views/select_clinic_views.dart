import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_clinic_controller.dart';

class SelectClinicView extends GetView<SelectClinicController> {
  const SelectClinicView({super.key});

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
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('assets/logo_klinik.png'),
            ),
            const SizedBox(width: 8),
            Text(
              'G&B Care Clinic',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () => Get.toNamed('/scanner'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEW APPOINTMENT',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    height: 1.2,
                  ),
                  children: [
                    const TextSpan(text: 'Select Your\nSpecialist '),
                    TextSpan(
                      text: 'Clinic',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Choose the department that best suits your current health needs.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Gigi',
                      'Dental care & surgery',
                      Icons.child_care,
                      theme.colorScheme.secondaryContainer,
                      theme.colorScheme.secondary,
                      theme,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Umum',
                      'General checkups',
                      Icons.medical_services,
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primary,
                      theme,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildWideClinicCard(
                'Anak',
                'Pediatric specialist for infants and children.',
                Icons.child_friendly,
                theme.colorScheme.tertiaryContainer,
                theme.colorScheme.tertiary,
                theme,
                isDark,
                hasImage: true,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Mata',
                      'Eye health & vision',
                      Icons.visibility,
                      theme.colorScheme.secondaryContainer,
                      theme.colorScheme.secondary,
                      theme,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareClinicCard(
                      'Jantung',
                      'Cardiac screening',
                      Icons.favorite,
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primary,
                      theme,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildListClinicCard(
                'Kandungan',
                'Obstetrics & Gynecology care',
                Icons.pregnant_woman,
                theme.colorScheme.tertiaryContainer,
                theme.colorScheme.tertiary,
                theme,
                isDark,
              ),
              const SizedBox(height: 40),

              _buildCallCenterCard(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareClinicCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    ThemeData theme,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => controller.onClinicSelected(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideClinicCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    ThemeData theme,
    bool isDark, {
    bool hasImage = false,
  }) {
    return GestureDetector(
      onTap: () => controller.onClinicSelected(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (hasImage) ...[
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=200&auto=format&fit=crop',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListClinicCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    ThemeData theme,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => controller.onClinicSelected(title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallCenterCard(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Can't find\nyour clinic?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Contact our patient service for further assistance or special referrals.",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.callCenter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimary,
                  foregroundColor: isDark ? Colors.blue.shade900 : theme.colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Call Center',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.support_agent,
              size: 120,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
