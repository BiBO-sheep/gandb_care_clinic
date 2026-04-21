import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
// Ganti path ini kalau nama file rute lu beda (misal: import '../../../routes/app_pages.dart';)
import '../../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Warna background abu-abu terang biar elegan
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal, // Sesuaikan dengan warna tema klinik lu
      ),
      body: Obx(() {
        // Tampilkan loading kalau data dari Laravel belum sampai
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- BAGIAN HEADER (FOTO & INFO USER) ---
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.userName.value.isEmpty
                        ? 'Memuat Nama...'
                        : controller.userName.value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.userEmail.value.isEmpty
                        ? 'Memuat Email...'
                        : controller.userEmail.value,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.userPhone.value.isEmpty
                        ? 'Belum ada nomor HP'
                        : controller.userPhone.value,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),

                  const SizedBox(
                    height: 12,
                  ), // Jarak untuk badge golongan darah
                  // 👇 INI TAMBAHAN BADGE GOLONGAN DARAH 👇
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          controller.userBloodType.value == '-' ||
                                  controller.userBloodType.value.isEmpty
                              ? 'Gol. Darah: Belum diisi'
                              : 'Gol. Darah: ${controller.userBloodType.value}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- BAGIAN MENU ---
            const Text(
              'Pengaturan Akun',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.teal),
                    ),
                    title: const Text(
                      'Edit Profile & Pengaturan',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () => Get.toNamed(Routes.SETTINGS),
                  ),
                  const Divider(height: 1, indent: 60), // Garis pembatas tipis
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.history_edu, color: Colors.teal),
                    ),
                    title: const Text(
                      'Riwayat Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () => Get.toNamed(Routes.PAYMENT_HISTORY),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- BAGIAN TOMBOL LOGOUT ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Munculin pop-up konfirmasi biar gak kepencet gak sengaja
                  Get.defaultDialog(
                    title: "Konfirmasi Logout",
                    middleText: "Apakah Anda yakin ingin keluar dari akun ini?",
                    textConfirm: "Ya, Keluar",
                    textCancel: "Batal",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.redAccent,
                    onConfirm: () {
                      Get.back(); // Tutup dialog
                      controller
                          .logout(); // Panggil fungsi logout di controller
                    },
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Keluar (Logout)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
