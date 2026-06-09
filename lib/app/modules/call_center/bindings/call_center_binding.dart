import 'package:get/get.dart';
import '../controllers/call_center_controller.dart';

class CallCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallCenterController>(
      () => CallCenterController(),
    );
  }
}
