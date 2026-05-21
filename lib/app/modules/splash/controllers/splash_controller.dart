import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Panggil setelah frame pertama selesai dirender - lebih aman dari onInit
    _startSplash();
  }

  void _startSplash() async {
    // 1. Tahan di layar Splash selama 3 detik
    await Future.delayed(const Duration(seconds: 3));

    // Jangan lanjutkan kalau controller sudah di-dispose (hot restart safety)
    if (isClosed) return;

    try {
      // 2. Cek token login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (isClosed) return; // cek lagi setelah await

      // 3. Pindah halaman dengan aman
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      if (!isClosed) Get.offAllNamed('/login');
    }
  }
}
