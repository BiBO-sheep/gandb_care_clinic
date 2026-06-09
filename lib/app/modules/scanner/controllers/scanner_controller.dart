import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/utils/app_snackbar.dart';

class ScannerController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController();
  var isScanning = true.obs;

  void onDetect(BarcodeCapture capture) {
    if (!isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        isScanning.value = false;
        _handleScanResult(code);
      }
    }
  }

  void _handleScanResult(String code) {
    // Simulasi Fast Check-in atau membaca tiket
    AppSnackbar.success(
      'Scan Berhasil',
      'QR Code Terdeteksi: $code\nAnda telah berhasil Check-in.',
    );
    
    // Tunda sebentar lalu kembali
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
