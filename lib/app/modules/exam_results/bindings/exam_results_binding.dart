import 'package:get/get.dart';
import '../controllers/exam_results_controller.dart';

class ExamResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamResultsController>(() => ExamResultsController());
  }
}
