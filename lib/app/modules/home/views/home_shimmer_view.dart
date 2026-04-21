import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerView extends StatelessWidget {
  const HomeShimmerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 👇 WARNA SHIMMER SESUAI DESAIN KLINIK 👇
    final Color baseColor = Colors.grey[200]!;
    final Color highlightColor = Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        direction: ShimmerDirection.ltr, // Mengalir dari kiri ke kanan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. APPY BAR DUMMY ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                    ), // Placeholder Foto
                    const SizedBox(width: 12),
                    Container(
                      width: 120,
                      height: 18,
                      color: Colors.white,
                    ), // Placeholder Clinic Name
                  ],
                ),
                const Icon(Icons.qr_code_scanner, color: Colors.white),
              ],
            ),
            const SizedBox(height: 32),

            // --- 2. WELCOME TEXT DUMMY ---
            Container(
              width: 250,
              height: 28,
              color: Colors.white,
            ), // "Hello, [Name]"
            const SizedBox(height: 8),
            Container(width: 300, height: 14, color: Colors.white), // Desc text
            const SizedBox(height: 32),

            // --- 3. CLINICS SLIDER DUMMY ---
            _buildPoliSliderShimmer(baseColor),
            const SizedBox(height: 32),

            // --- 4. APPOINTMENT CARD DUMMY (Gradient Shimmer) ---
            _buildAppointmentCardShimmer(baseColor),
            const SizedBox(height: 32),

            // --- 5. HEART RATE DUMMY ---
            Container(width: 120, height: 12, color: Colors.white), // Header
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(
              height: 100,
            ), // Spasi bawah biar gak mentok bottom nav
          ],
        ),
      ),
    );
  }

  // --- KOMPONEN KARTU POLI SHIMMER ---
  Widget _buildPoliSliderShimmer(Color baseColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 12,
              color: Colors.white,
            ), // OUR CLINICS text
            Container(
              width: 50,
              height: 12,
              color: Colors.white,
            ), // See All text
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics:
                const NeverScrollableScrollPhysics(), // Biar gak bisa di-scroll pas loading
            itemCount: 3, // Tampilin 3 kartu dummy
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                    ), // Icon
                    const Spacer(),
                    Container(
                      width: 80,
                      height: 14,
                      color: Colors.white,
                    ), // Poli Name
                    const SizedBox(height: 4),
                    Container(
                      width: 60,
                      height: 11,
                      color: Colors.white,
                    ), // Ruangan
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- KOMPONEN KARTU APPOINTMENT SHIMMER ---
  Widget _buildAppointmentCardShimmer(Color baseColor) {
    return Container(
      width: double.infinity,
      height: 200, // Menyesuaikan tinggi di image_0.png
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.5,
        ), // Biar shimmernya lebih kerasa di gradient
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ), // UPCOMING text
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 24,
            color: Colors.white,
          ), // General Check-up
          const SizedBox(height: 8),
          Container(width: 200, height: 13, color: Colors.white), // Dr. Sarah
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 60, // Dummy Date & Time grid
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}
