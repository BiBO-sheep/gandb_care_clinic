import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/app_snackbar.dart';

class CallCenterController extends GetxController {
  
  Future<void> callAmbulance() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '119', // Nomor darurat Indonesia
    );
    await _launchUrl(launchUri);
  }

  Future<void> chatWhatsApp() async {
    // Gunakan nomor WA klinik, misal +6281234567890
    final Uri launchUri = Uri.parse('https://wa.me/6281234567890?text=Halo%20G&B%20Care%20Clinic,%20saya%20butuh%20bantuan...');
    await _launchUrl(launchUri);
  }

  Future<void> sendEmail() async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: 'support@gnb-care-clinic.bngshot.my.id',
      query: 'subject=Bantuan%20Aplikasi%20Klinik',
    );
    await _launchUrl(launchUri);
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        AppSnackbar.error('Gagal', 'Tidak dapat membuka tautan atau aplikasi terkait.');
      }
    } catch (e) {
      AppSnackbar.error('Gagal', 'Terjadi kesalahan sistem.');
    }
  }
}
