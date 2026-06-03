import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

/// Centralized snackbar helper that matches the app's theme.
/// No emoji icons, uses clean color-coded styling.
class AppSnackbar {
  AppSnackbar._();

  static const Duration _duration = Duration(seconds: 3);
  static const double _borderRadius = 16;

  /// Green — success actions (login, booking confirmed, etc.)
  static void success(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Red — errors and failures
  static void error(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  /// App primary blue — informational messages
  static void info(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline_rounded,
    );
  }

  /// Amber — warnings and validation messages
  static void warning(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFB45309), // Amber-700
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    // Close any existing snackbar first to avoid stacking
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: _duration,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      borderRadius: _borderRadius,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      titleText: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.4,
        ),
      ),
      icon: Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
