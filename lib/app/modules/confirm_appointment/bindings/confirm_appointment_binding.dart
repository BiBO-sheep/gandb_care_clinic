import 'package:get/get.dart';
import '../controllers/confirm_appointment_controller.dart';

class ConfirmAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmAppointmentController>(
      () => ConfirmAppointmentController(),
    );
  }
}
