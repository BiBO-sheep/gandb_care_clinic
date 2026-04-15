import 'package:get/get.dart';
import '../controllers/select_clinic_controller.dart';

class SelectClinicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectClinicController>(() => SelectClinicController());
  }
}
