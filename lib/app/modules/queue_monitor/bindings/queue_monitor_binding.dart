import 'package:get/get.dart';
import '../controllers/queue_monitor_controller.dart';

class QueueMonitorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QueueMonitorController>(() => QueueMonitorController());
  }
}
