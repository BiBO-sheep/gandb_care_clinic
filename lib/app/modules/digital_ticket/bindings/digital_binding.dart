import 'package:get/get.dart';
import '../controllers/digital_ticket_controller.dart';

class DigitalTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DigitalTicketController>(() => DigitalTicketController());
  }
}
