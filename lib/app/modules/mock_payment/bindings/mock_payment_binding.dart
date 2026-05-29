import 'package:get/get.dart';
import '../controllers/mock_payment_controller.dart';

class MockPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MockPaymentController>(
      () => MockPaymentController(),
    );
  }
}
