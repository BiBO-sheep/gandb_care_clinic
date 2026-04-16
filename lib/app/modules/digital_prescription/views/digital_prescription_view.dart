import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gandb_care_clinic/app/modules/digital_prescription/controllers/digital+prescription_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DigitalPrescriptionView extends GetView<DigitalPrescriptionController> {
  const DigitalPrescriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1594824436998-d40d12e8471c?q=80&w=150&auto=format&fit=crop',
                      ),
                      fit: BoxFit.cover,
                    ), // Placeholder Dokter Wanita
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'G&B Care Clinic',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.primary),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- HERO HEADER ---
                  Text(
                    'VERIFIED PRESCRIPTION',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Digital Prescription',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Issued on Oct 24, 2023 • ID: GB-99281-XC',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- PHARMACY SLIP (STRUK KERTAS) ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Clinic & Doctor Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ATTENDING PHYSICIAN',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Dr. Althea Sterling',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  'Specialist of Internal Medicine',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const FaIcon(
                              FontAwesomeIcons.prescription,
                              color: AppColors.primary,
                              size: 36,
                            ), // Jika tidak ada Icons.prescriptions, otomatis fallback ke ikon yang ada atau gunakan Icons.receipt
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDashedLine(),
                        const SizedBox(height: 24),

                        // Medication List
                        _buildMedicationItem(
                          icon: Icons.medication,
                          iconBg: const Color(0xFFFFDBCF),
                          iconColor: AppColors.primary,
                          name: 'Amoxicillin Trihydrate',
                          badge: 'ANTIBIOTIC',
                          dosage: '500mg • 15 Capsules',
                          instruction:
                              '"Take one capsule three times daily after meals for 5 consecutive days."',
                        ),
                        const SizedBox(height: 24),
                        _buildMedicationItem(
                          icon: Icons.water_drop,
                          iconBg: const Color(0xFF93F2F2),
                          iconColor: AppColors.secondary,
                          name: 'Cetirizine HCl',
                          badge: 'ANTIHISTAMINE',
                          dosage: '10mg • 10 Tablets',
                          instruction:
                              '"Take one tablet before sleep as needed for seasonal allergies."',
                        ),
                        const SizedBox(height: 24),
                        _buildMedicationItem(
                          icon: Icons.medical_information,
                          iconBg: const Color(0xFF7AF4FF),
                          iconColor: const Color(0xFF006970),
                          name: 'Paracetamol',
                          badge: 'ANALGESIC',
                          dosage: '500mg • 20 Tablets',
                          instruction:
                              '"Take one tablet every 4-6 hours if fever or pain persists. Do not exceed 4g per day."',
                        ),

                        const SizedBox(height: 24),
                        _buildDashedLine(),
                        const SizedBox(height: 24),

                        // Footer Signature
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PATIENT NAME',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Jonathan Doe',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'DIGITAL SIGNATURE',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  Icons.qr_code_2,
                                  size: 40,
                                  color: AppColors.onSurfaceVariant.withOpacity(
                                    0.4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- INFO BOX ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This digital prescription is valid for 7 days. You can redeem it at any G&B Care Clinic Pharmacy or through our home delivery service.',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              color: const Color(0xFF004F4F),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 180,
                  ), // Extra spacing for FAB & Bottom Nav
                ],
              ),
            ),

            // --- FLOATING ACTION BUTTON (TEBUS OBAT) ---
            Positioned(
              bottom: 110,
              left: 24,
              right: 24,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isRequesting.value
                      ? null
                      : controller.requestMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: controller.isRequesting.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_pharmacy, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              'Request Medication (Tebus Obat)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Helper: Komponen Item Obat
  Widget _buildMedicationItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String name,
    required String badge,
    required String dosage,
    required String instruction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF006E6E),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dosage,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.secondary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DOSAGE INSTRUCTIONS',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      instruction,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper: Garis Putus-putus
  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0
                ? Colors.transparent
                : AppColors.surfaceVariant,
            height: 2,
          ),
        ),
      ),
    );
  }

  // Helper: Bottom Nav
  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: const Color(0xFFFAF9F6).withOpacity(0.8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'Home', Icons.home),
                _buildNavItem(1, 'History', Icons.history),
                _buildNavItem(2, 'Notifs', Icons.notifications),
                _buildNavItem(3, 'Profile', Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF7F50).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.secondary.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.secondary.withOpacity(0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
