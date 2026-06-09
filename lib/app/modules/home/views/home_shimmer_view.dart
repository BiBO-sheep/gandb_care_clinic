import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerView extends StatelessWidget {
  const HomeShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    final Color baseColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
    final Color highlightColor = isDark ? Colors.grey[800]! : Colors.white;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/logo_klinik.png'),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 120, height: 18, color: Colors.white),
                  ],
                ),
                const Icon(Icons.qr_code_scanner, color: Colors.white),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              direction: ShimmerDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(width: 250, height: 28, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 300, height: 14, color: Colors.white),
                  const SizedBox(height: 32),
                  _buildAppointmentCardShimmer(),
                  const SizedBox(height: 32),
                  _buildQuickActionsShimmer(),
                  const SizedBox(height: 32),
                  _buildHealthTipsShimmer(),
                  const SizedBox(height: 32),
                  _buildPoliGridShimmer(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPoliGridShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: 100, height: 12, color: Colors.white),
            Container(width: 50, height: 12, color: Colors.white),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
                  const Spacer(),
                  Container(width: 80, height: 14, color: Colors.white),
                  const SizedBox(height: 4),
                  Container(width: 60, height: 11, color: Colors.white),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHealthTipsShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 100, height: 12, color: Colors.white),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCardShimmer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 150, height: 20, color: Colors.white),
          const SizedBox(height: 16),
          Container(width: double.infinity, height: 24, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: 200, height: 13, color: Colors.white),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 120, height: 12, color: Colors.white),
        const SizedBox(height: 16),
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
