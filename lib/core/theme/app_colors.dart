import 'package:flutter/material.dart';

class AppColors {
  // Primary - Trust, Professionalism, Healthcare
  static const Color primary = Color(0xFF0F4C75);
  static const Color primaryContainer = Color(0xFF3282B8);
  static const Color onPrimaryContainer = Color(0xFFEBF8FF);

  // Secondary - Calm, Accents
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryContainer = Color(0xFFBBE1FA);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Very light greyish blue
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  // Text Colors
  static const Color onSurface = Color(0xFF1E293B); // Slate 800
  static const Color onSurfaceVariant = Color(0xFF64748B); // Slate 500
  
  // States
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  // Dark Mode specific additions if needed later (usually handled by ColorScheme in theme)
  static Color? get surfaceContainerLow => const Color(0xFFF1F5F9);
}
