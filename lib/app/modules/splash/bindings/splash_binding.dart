import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Kita pake Get.put supaya controllernya langsung siap pas aplikasi nyala
    Get.put(SplashController());
  }
}
