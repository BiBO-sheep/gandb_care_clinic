import 'package:gandb_care_clinic/app/modules/login/bindings/login_binding.dart';
import 'package:gandb_care_clinic/app/modules/login/views/login_view.dart';
import 'package:gandb_care_clinic/app/modules/register/bindings/register_binding.dart';
import 'package:gandb_care_clinic/app/modules/register/views/register_view.dart';
import 'package:get/get.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    // Tambahkan GetPage ini
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.downToUp, // Animasi slide dari bawah ke atas agar mirip seperti modal pop-up (opsional)
    ),
  ];
}
