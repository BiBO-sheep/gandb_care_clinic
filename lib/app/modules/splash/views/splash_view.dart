import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color backgroundColor = theme.colorScheme.surface;
    final Color primaryColor = theme.colorScheme.primary;
    final Color secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  backgroundColor,
                  primaryColor.withValues(alpha: isDark ? 0.12 : 0.06),
                ],
              ),
            ),
          ),

          // Animated content
          Center(
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: controller.opacityAnimation.value.clamp(0.0, 1.0),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(controller.rotateAnimation.value * 3.14159)
                      ..scaleByDouble(
                          controller.scaleAnimation.value,
                          controller.scaleAnimation.value,
                          controller.scaleAnimation.value,
                          1.0,
                        ),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.25),
                          blurRadius: 32,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        color: primaryColor,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // App name
                  Text(
                    'G&B Care Clinic',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tagline badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: secondaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: secondaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monitor_heart_rounded,
                          color: secondaryColor,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Empowering Health, Embracing Care',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? Colors.white70
                                : theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
