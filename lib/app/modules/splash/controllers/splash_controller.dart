import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi setelah halaman selesai dirender
    _startSplash();
  }

  void _startSplash() async {
    // 1. Tahan di layar Splash selama 3 detik
    await Future.delayed(const Duration(seconds: 3));

    try {
      // 2. Cek token login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // 3. Pindah halaman dengan aman
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.offAllNamed('/login');
    }
  }
}
