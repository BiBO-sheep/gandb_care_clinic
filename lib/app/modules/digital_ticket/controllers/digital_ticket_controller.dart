import 'package:get/get.dart';

class DigitalTicketController extends GetxController {
  var currentIndex = 1.obs;

  // Variabel penampung data asli
  var queueNumber = '...'.obs;
  var patientName = '...'.obs;
  var service = '...'.obs;
  var dateTime = '...'.obs;
  var appointmentId = '0'.obs; // Untuk isi QR Code
  final String location =
      'G&B Care Central\n4th Floor, Suite 400, Medical Plaza';

  @override
  void onInit() {
    super.onInit();
    // TANGKAP DATA DARI HALAMAN KONFIRMASI
    if (Get.arguments != null) {
      var data = Get.arguments;
      queueNumber.value = data['queue_number'] ?? 'A-00';
      patientName.value = data['patient_name'] ?? 'Patient';
      service.value = data['service'] ?? 'Clinic';
      dateTime.value = "${data['date']}, ${data['time']}";
      appointmentId.value = data['id'].toString();
    }
  }

  void backToDashboard() => Get.offAllNamed('/home');

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) Get.offAllNamed('/home');
  }

  // Fungsi dummy tambahan
  void addToCalendar() => Get.snackbar('Success', 'Added to calendar');
  void shareTicket() => Get.snackbar('Share', 'Opening share menu...');
}
