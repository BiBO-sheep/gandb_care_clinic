import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentHistoryController extends GetxController {
  // Tab History yang aktif (Index 1)
  var currentIndex = 1.obs;

  // Data Mock Tagihan (Nanti diganti response JSON dari PHP)
  final paymentDetails = [
    {'name': 'Consultation Fee', 'amount': 'Rp 250.000'},
    {'name': 'Laboratory Tests', 'amount': 'Rp 450.000'},
    {'name': 'Medicine & Vitamins', 'amount': 'Rp 185.000'},
  ];
  final String totalAmount = 'Rp 885.000';

  // Data Mock Riwayat (Nanti diganti response JSON dari PHP)
  final List<Map<String, String>> historyList = [
    {
      'date': '12 OCT 2023',
      'title': 'General Checkup',
      'clinic': 'Poli Umum',
      'doctor': 'Dr. Sarah Jenkins',
      'status': 'PAID',
    },
    {
      'date': '28 AUG 2023',
      'title': 'Dermatology Consult',
      'clinic': 'Poli Kulit & Kelamin',
      'doctor': 'Dr. Michael Chen',
      'status': 'PAID',
    },
    {
      'date': '15 JUN 2023',
      'title': 'Blood Panel Screening',
      'clinic': 'Laboratorium',
      'doctor': 'Dr. Amara Okafor',
      'status': 'PAID',
    },
  ];

  void payWithQRIS() {
    Get.snackbar(
      'QRIS Pay',
      'Membuka kamera untuk scan QRIS...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );
  }

  void payWithBank() {
    Get.snackbar(
      'Bank Transfer',
      'Menampilkan nomor Virtual Account...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF006A6A),
      colorText: Colors.white,
    );
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/home');
    }
  }
}
