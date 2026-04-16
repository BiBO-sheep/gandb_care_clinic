import 'package:gandb_care_clinic/app/modules/digital_prescription/controllers/digital+prescription_controller.dart';
import 'package:get/get.dart';

class DigitalPrescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DigitalPrescriptionController>(
      () => DigitalPrescriptionController(),
    );
  }
}
