import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_results_controller.dart';

class ExamResultsView extends GetView<ExamResultsController> {
  const ExamResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(Icons.person, size: 24, color: theme.colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Text(
                  'G&B Care Clinic',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.primary),
              onPressed: controller.backToHistory,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'Examination Results',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  height: 1.1,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                }
                if (controller.resultsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada riwayat rekam medis',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  itemCount: controller.resultsList.length,
                  itemBuilder: (context, index) {
                    final record = controller.resultsList[index];
                    return _buildRecordCard(record, theme, isDark);
                  },
                );
              }),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(theme, isDark),
    );
  }

  Widget _buildRecordCard(dynamic record, ThemeData theme, bool isDark) {
    final appointmentDate = record['appointment']?['appointment_date'] ?? 'Tanggal tidak tersedia';
    final doctorName = record['doctor']?['name'] ?? 'Dokter tidak tersedia';
    final doctorSpec = record['doctor']?['specialization'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? [] : [
          BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  appointmentDate,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 12, color: theme.colorScheme.secondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            doctorName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (doctorSpec.isNotEmpty) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                doctorSpec,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (record['keluhan'] != null && record['keluhan'].toString().isNotEmpty) ...[
            Text(
              'KELUHAN PASIEN',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              record['keluhan'],
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'DIAGNOSIS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            record['diagnosis'] ?? 'Tidak ada diagnosis',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'TREATMENT PLAN',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            record['treatment_plan'] ?? 'Tidak ada rencana perawatan',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.goToPrescription(record),
                  icon: Icon(Icons.medication, color: theme.colorScheme.onPrimaryContainer, size: 18),
                  label: Text(
                    'Lihat Resep',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (record['appointment']?['status'] != 'paid')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final appointmentId = record['appointment_id'] ?? record['appointment']?['id'];
                      if (appointmentId != null) {
                        Get.toNamed('/invoice', arguments: {'appointment_id': appointmentId});
                      } else {
                        Get.snackbar('Gagal', 'ID Appointment tidak ditemukan');
                      }
                    },
                    icon: Icon(Icons.payment, color: theme.colorScheme.onPrimary, size: 18),
                    label: Text(
                      'Bayar Sekarang',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: theme.colorScheme.surface.withValues(alpha: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'Home', Icons.home, theme, isDark),
                _buildNavItem(1, 'History', Icons.history, theme, isDark),
                _buildNavItem(2, 'Notifs', Icons.notifications, theme, isDark),
                _buildNavItem(3, 'Profile', Icons.person, theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, ThemeData theme, bool isDark) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

