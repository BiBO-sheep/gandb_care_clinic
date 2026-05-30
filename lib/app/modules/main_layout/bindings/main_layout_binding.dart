import 'package:get/get.dart';
import '../controllers/main_layout_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../payment_history/controllers/payment_history_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(() => MainLayoutController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PaymentHistoryController>(() => PaymentHistoryController());
    Get.lazyPut<NotificationsController>(() => NotificationsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
