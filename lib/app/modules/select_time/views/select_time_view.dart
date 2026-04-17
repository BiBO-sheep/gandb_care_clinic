import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/select_time_controller.dart';

class SelectTimeView extends GetView<SelectTimeController> {
  const SelectTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.secondary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'G&B Care Clinic',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDBCF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'STEP 2 OF 3',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF822800),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select your visit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a date and time that fits your wellness schedule.',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- WIDGET KALENDER ---
                  _buildCalendarWidget(),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Times',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(
                          () => Text(
                            // 👇 PERBAIKAN: Nampilin Tanggal yang Dipilih
                            controller.getFormattedSelectedDate().toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildTimeSlotsGrid(),
                  const SizedBox(height: 32),

                  // --- SYSTEM ALLOCATION INFO ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'System Allocation',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF004F4F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sistem akan otomatis mengalokasikan dokter spesialis yang bertugas untuk mempercepat antrean Anda.',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  color: const Color(
                                    0xFF004F4F,
                                  ).withOpacity(0.8),
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
              ),
            ),

            // --- BUTTON BAWAH ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: controller.continueToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Confirmation',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET HELPERS
  // ==========================================

  Widget _buildCalendarWidget() {
    final daysOfWeek = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 👇 PERBAIKAN: Nampilin Bulan & Tahun Kalender
              Obx(
                () => Text(
                  controller.getFormattedDisplayMonth(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: controller.prevMonth,
                    child: _buildCircleBtn(Icons.chevron_left),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: controller.nextMonth,
                    child: _buildCircleBtn(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Obx(() {
            DateTime displayMonth = controller.displayMonth.value;
            int daysInMonth = DateTime(
              displayMonth.year,
              displayMonth.month + 1,
              0,
            ).day;
            int firstWeekday = DateTime(
              displayMonth.year,
              displayMonth.month,
              1,
            ).weekday;
            int emptySlots = firstWeekday - 1;

            List<Widget> dayWidgets = [];
            for (int i = 0; i < emptySlots; i++) {
              dayWidgets.add(const SizedBox());
            }

            DateTime today = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

            for (int i = 1; i <= daysInMonth; i++) {
              DateTime currentDate = DateTime(
                displayMonth.year,
                displayMonth.month,
                i,
              );
              bool isPast = currentDate.isBefore(today);
              bool isSelected =
                  controller.selectedDate.value.year == currentDate.year &&
                  controller.selectedDate.value.month == currentDate.month &&
                  controller.selectedDate.value.day == currentDate.day;

              dayWidgets.add(
                GestureDetector(
                  onTap: isPast
                      ? null
                      : () => controller.selectDate(currentDate),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isPast
                                  ? Colors.transparent
                                  : Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$i',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isPast
                                  ? Colors.grey.withOpacity(0.3)
                                  : AppColors.onSurface),
                      ),
                    ),
                  ),
                ),
              );
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 7,
              children: dayWidgets,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.secondary, size: 20),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.timeSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final slot = controller.timeSlots[index];
        final time = slot['time'];
        final period = slot['period'];
        final isBooked = slot['status'] == 'booked';

        return Obx(() {
          final isSelected = controller.selectedTime.value == time;
          return GestureDetector(
            onTap: () => controller.selectTime(time, slot['status']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isBooked
                    ? AppColors.surfaceContainerLow?.withOpacity(0.5)
                    : (isSelected
                          ? AppColors.primaryContainer.withOpacity(0.2)
                          : AppColors.surfaceContainerLow),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isBooked ? Colors.grey : AppColors.onSurface,
                      decoration: isBooked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    isBooked
                        ? 'BOOKED'
                        : (isSelected ? 'SELECTED' : period.toUpperCase()),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: isBooked
                          ? Colors.grey
                          : (isSelected ? AppColors.primary : Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
