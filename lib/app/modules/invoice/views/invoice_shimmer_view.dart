import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class InvoiceShimmerView extends StatelessWidget {
  const InvoiceShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    final Color baseColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
    final Color highlightColor = isDark ? Colors.grey[800]! : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 200, height: 32, color: Colors.white),
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 28,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    );
  }
}
