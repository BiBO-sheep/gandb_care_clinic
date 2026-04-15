import 'package:get/get.dart';
import '../controllers/select_time_controller.dart';

class SelectTimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectTimeController>(() => SelectTimeController());
  }
}
