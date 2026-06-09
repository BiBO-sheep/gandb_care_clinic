import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> rotateAnimation;
  late Animation<double> opacityAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Bouncing scale effect
    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // 3D Flip effect (from half rotation to 0)
    rotateAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Fade in effect
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeIn),
      ),
    );

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    _startSplash();
  }

  void _startSplash() async {
    // Tunggu animasi selesai + sedikit jeda
    await Future.delayed(const Duration(milliseconds: 3000));

    if (isClosed) return;

    try {
      String? token;
      try {
        token = await _storage
            .read(key: 'token')
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint("Storage read error/timeout: $e");
        token = null;
      }

      if (isClosed) return;

      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      if (!isClosed) Get.offAllNamed(Routes.LOGIN);
    }
  }
}
