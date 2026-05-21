import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'app/services/polling_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reset semua instance GetX saat hot restart agar tidak ada
  // stale Rx observers dari widget tree lama yang menyebabkan assertion error.
  // Get.reset() akan memanggil onClose() pada semua service (termasuk stopPolling).
  Get.reset(clearRouteBindings: true);

  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => PollingService().init());

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
