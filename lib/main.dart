import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'app/services/polling_service.dart';
import 'app/services/notification_service.dart';
import 'core/theme/app_theme.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp();
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
    } catch (e) {
      debugPrint("Firebase init failed: $e");
    }

    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("DotEnv load error: $e");
    }

    if (Get.isRegistered<PollingService>()) {
      try {
        Get.find<PollingService>().stopPolling();
      } catch (_) {}
    }

    Get.reset(clearRouteBindings: true);
    await Future.delayed(const Duration(milliseconds: 100));

    await Get.putAsync(() => ThemeService().init(), permanent: true);
    await Get.putAsync(() => PollingService().init(), permanent: true);
    await Get.putAsync(() => NotificationService().init(), permanent: true);

    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint("🚨 [ASYNC ERROR CAUGHT]: $error");
    debugPrint("Stacktrace: $stackTrace");
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
  });
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
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
