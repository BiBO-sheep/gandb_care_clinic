import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Pakai Get.put (bukan lazyPut) karena SplashView.build()
    // tidak memanggil controller secara eksplisit.
    // Dengan lazyPut, controller tidak pernah dibuat dan onReady() tidak pernah dipanggil.
    Get.put<SplashController>(SplashController());
  }
}
