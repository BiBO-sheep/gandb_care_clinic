import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color tealColor = isDark ? const Color(0xFF93F2F2) : const Color(0xFF00796B);
    final Color goldColor = const Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  backgroundColor,
                  tealColor.withOpacity(isDark ? 0.05 : 0.1),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tealColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      color: tealColor,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'G&B Care Clinic',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: tealColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monitor_heart_rounded,
                        color: goldColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Empowering Health, Embracing Care',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
