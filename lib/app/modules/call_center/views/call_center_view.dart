import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/call_center_controller.dart';

class CallCenterView extends GetView<CallCenterController> {
  const CallCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Pusat Bantuan',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(Icons.support_agent, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Kami Siap Membantu Anda',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih metode komunikasi yang paling nyaman untuk Anda.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            Text(
              'Layanan Darurat',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              title: 'Panggil Ambulans',
              subtitle: 'Layanan darurat medis 24 Jam',
              icon: Icons.emergency,
              color: Colors.red,
              onTap: controller.callAmbulance,
              theme: theme,
            ),
            
            const SizedBox(height: 24),
            Text(
              'Hubungi Kami',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              title: 'Chat via WhatsApp',
              subtitle: 'Respon cepat oleh tim customer service kami',
              icon: Icons.chat,
              color: Colors.green,
              onTap: controller.chatWhatsApp,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              title: 'Kirim Email',
              subtitle: 'Untuk pertanyaan detail dan pengiriman dokumen',
              icon: Icons.email,
              color: theme.colorScheme.primary,
              onTap: controller.sendEmail,
              theme: theme,
            ),
            
            const SizedBox(height: 32),
            Text(
              'Pertanyaan Umum (FAQ)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildFAQItem('Bagaimana cara membatalkan janji temu?', 'Untuk membatalkan janji temu, Anda bisa pergi ke halaman History, lalu pilih tiket Anda dan tekan tombol Batalkan Janji.', theme),
            _buildFAQItem('Apa yang harus disiapkan saat ke klinik?', 'Pastikan membawa kartu identitas asli (KTP) dan kartu asuransi jika Anda menggunakan layanan asuransi.', theme),
            _buildFAQItem('Apakah ada toleransi keterlambatan?', 'Klinik kami memberikan toleransi maksimal 15 menit dari jadwal Anda. Lebih dari itu, Anda mungkin perlu mengambil antrean ulang.', theme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Text(
            answer,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
