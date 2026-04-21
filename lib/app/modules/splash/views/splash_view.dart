import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart'; // Jangan lupa bikin controllernya buat ngatur pindah halaman

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 👇 WARNA TEMA DESAIN KLINIK 👇
    final Color backgroundColor = Colors.white;
    final Color tealColor = const Color(0xFF00796B); // Deep teal
    final Color goldColor = const Color(0xFFFFC107); // Subtle gold accent

    return Scaffold(
      body: Stack(
        children: [
          // --- 1. GRADIENT BACKGROUND ---
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  backgroundColor,
                  tealColor.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // --- 2. LOGO & TEXT CENTERED ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 👇 PLACEHOLDER LOGO ABSTRAK (Ubah jadi gambar logo asli nanti) 👇
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
                    ), // Ganti ini pake Asset Image logo asli
                  ),
                ),
                const SizedBox(height: 32),

                // 👇 KLINIK NAME TEXT (Modern Font) 👇
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

                // 👇 TAGLINE & HEARTBEAT ICON 👇
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
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
                      ), // Heartbeat icon
                      const SizedBox(width: 8),
                      Text(
                        'Empowering Health, Embracing Care',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
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
