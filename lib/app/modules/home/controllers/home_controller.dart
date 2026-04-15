import 'package:get/get.dart';

class HomeController extends GetxController {
  // State untuk Bottom Navigation Bar
  var currentIndex = 0.obs;

  // State Data Pasien (MOCK DATA - Nantinya diisi dari API Laravel)
  var patientName = 'Alex'.obs;
  var heartRate = 72.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // Fungsi mengubah tab menu bawah
  void changePage(int index) {
    currentIndex.value = index;
    // TODO: Tambahkan logika perpindahan view jika index berubah
  }

  // Simulasi pemanggilan API ke Laravel
  void fetchDashboardData() async {
    isLoading.value = true;

    // MOCK LOGIC: Delay seolah-olah sedang request ke server
    await Future.delayed(const Duration(seconds: 1));

    // Di sini nantinya kamu me-mapping response JSON ke variabel
    patientName.value = 'Alex';
    heartRate.value = 72;

    isLoading.value = false;
  }

  // Fungsi untuk tombol Quick Actions
  void onQuickActionTapped(String action) {
    if (action == 'Book Appointment') {
      Get.toNamed('/select-clinic'); // Navigasi ke halaman pilih poli
    } else {
      Get.snackbar(
        'Fitur $action',
        'Sedang dalam pengembangan...',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi QR Scanner
  void openQRScanner() {
    Get.snackbar(
      'QR Scanner',
      'Membuka kamera...',
      snackPosition: SnackPosition.TOP,
    );
  }
}
