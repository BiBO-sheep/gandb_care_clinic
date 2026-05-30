import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'app/services/polling_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("DotEnv load error: $e");
  }
  // LANGKAH 1: Hentikan timer polling lebih dulu sebelum apapun.
  // Ini mencegah timer callback memicu update .obs ke widget tree lama.
  if (Get.isRegistered<PollingService>()) {
    try {
      Get.find<PollingService>().stopPolling();
    } catch (_) {}
  }

  // LANGKAH 2: Reset semua GetX instances
  Get.reset(clearRouteBindings: true);

  // LANGKAH 3: Tunggu 100ms agar Flutter selesai membersihkan
  // element tree lama setelah Rx subscriptions di-dispose.
  // Tanpa ini, Obx() widget lama bisa trigger assertion error.
  await Future.delayed(const Duration(milliseconds: 100));

  // LANGKAH 4: Daftarkan ulang services dan jalankan app
  await Get.putAsync(() => ThemeService().init(), permanent: true);
  await Get.putAsync(() => PollingService().init(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'G&B Care Clinic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService.to.theme,
      initialRoute: '/splash',
      getPages: AppPages.routes,
    );
  }
}
