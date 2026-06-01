import 'package:get/get.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gandb_care_clinic/app/modules/main_layout/controllers/main_layout_controller.dart';

class DigitalTicketController extends GetxController {
  var currentIndex = 1.obs;
  var isSimulating = false.obs;
  var status = 'confirmed'.obs;

  var queueNumber = '...'.obs;
  var patientName = '...'.obs;
  var service = '...'.obs;
  var dateTime = '...'.obs;
  var appointmentId = '0'.obs;
  
  // Variabel untuk parsing tanggal
  String _rawDate = "";
  String _rawTime = "";

  final String location =
      'G&B Care Central, 4th Floor, Suite 400, Medical Plaza';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var data = Get.arguments;
      queueNumber.value = data['queue_number'] ?? 'A-00';
      patientName.value = data['patient_name'] ?? 'Patient';
      service.value = data['service'] ?? 'Clinic';
      
      _rawDate = data['date'] ?? '';
      _rawTime = data['time'] ?? '';
      dateTime.value = "$_rawDate, $_rawTime";
      
      appointmentId.value = data['id'].toString();
      status.value = data['status'] ?? 'confirmed';
    }
  }

  void backToDashboard() {
    changePage(0);
  }

  void changePage(int index) {
    if (Get.isRegistered<MainLayoutController>()) {
      Get.find<MainLayoutController>().changePage(index);
      Get.until((route) => route.settings.name == '/home' || route.isFirst);
    } else {
      Get.offAllNamed('/home');
    }
  }

  void addToCalendar() {
    try {
      // Parsing tanggal: format asumsikan YYYY-MM-DD dan HH:mm
      // Contoh: 2026-04-28, 14:00
      DateTime start;
      try {
        start = DateTime.parse("$_rawDate $_rawTime");
      } catch (e) {
        // Fallback jika format berbeda (misal Apr 28, 2026)
        start = DateTime.now().add(const Duration(hours: 1));
      }
      
      final DateTime end = start.add(const Duration(hours: 1));

      final Event event = Event(
        title: "Jadwal Periksa - ${service.value}",
        description: "Jadwal periksa untuk pasien ${patientName.value} di klinik G&B Care.",
        location: location,
        startDate: start,
        endDate: end,
      );

      Add2Calendar.addEvent2Cal(event);
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuka kalender: $e');
    }
  }

  void shareTicket() {
    final String shareText = "🏥 *Jadwal Konsultasi G&B Care Clinic*\n\n"
        "Pasien: ${patientName.value}\n"
        "Layanan: ${service.value}\n"
        "Jadwal: ${dateTime.value}\n"
        "Lokasi: $location\n\n"
        "Mohon datang 15 menit sebelum jadwal pemeriksaan. Terima kasih!";
    
    Share.share(shareText);
  }
}
