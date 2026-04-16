import 'package:gandb_care_clinic/app/modules/confirm_appointment/bindings/confirm_appointment_binding.dart';
import 'package:gandb_care_clinic/app/modules/confirm_appointment/views/confirm_appointment_view.dart';
import 'package:gandb_care_clinic/app/modules/digital_prescription/bindings/digital_prescription_binding.dart';
import 'package:gandb_care_clinic/app/modules/digital_prescription/views/digital_prescription_view.dart';
import 'package:gandb_care_clinic/app/modules/digital_ticket/bindings/digital_binding.dart';
import 'package:gandb_care_clinic/app/modules/digital_ticket/views/digital_ticket_view.dart';
import 'package:gandb_care_clinic/app/modules/exam_results/bindings/exam_results_binding.dart';
import 'package:gandb_care_clinic/app/modules/exam_results/views/exam_results.view.dart';
import 'package:gandb_care_clinic/app/modules/home/bindings/home_bindings.dart';
import 'package:gandb_care_clinic/app/modules/home/views/home_view.dart';
import 'package:gandb_care_clinic/app/modules/login/bindings/login_binding.dart';
import 'package:gandb_care_clinic/app/modules/login/views/login_view.dart';
import 'package:gandb_care_clinic/app/modules/queue_monitor/bindings/queue_monitor_binding.dart';
import 'package:gandb_care_clinic/app/modules/queue_monitor/views/queue_monitor_view.dart';
import 'package:gandb_care_clinic/app/modules/register/bindings/register_binding.dart';
import 'package:gandb_care_clinic/app/modules/register/views/register_view.dart';
import 'package:gandb_care_clinic/app/modules/select_clinic/bindings/select_clinic_binding.dart';
import 'package:gandb_care_clinic/app/modules/select_clinic/views/select_clinic_views.dart';
import 'package:gandb_care_clinic/app/modules/select_time/bindings/select_time_bindings.dart';
import 'package:gandb_care_clinic/app/modules/select_time/views/select_time_view.dart';
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
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn, // Animasi halus saat masuk ke dashboard
    ),
    GetPage(
      name: Routes.SELECT_CLINIC,
      page: () => const SelectClinicView(),
      binding: SelectClinicBinding(),
      transition: Transition
          .rightToLeft, // Animasi slide dari kanan khas pindah halaman
    ),
    GetPage(
      name: Routes.SELECT_TIME,
      page: () => const SelectTimeView(),
      binding: SelectTimeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.QUEUE_MONITOR,
      page: () => const QueueMonitorView(),
      binding: QueueMonitorBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.CONFIRM_APPOINTMENT,
      page: () => const ConfirmAppointmentView(),
      binding: ConfirmAppointmentBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.DIGITAL_TICKET,
      page: () => const DigitalTicketView(),
      binding: DigitalTicketBinding(),
      transition: Transition
          .downToUp, // Animasi muncul dari bawah ke atas agar berasa "Sukses"
    ),
    GetPage(
      name: Routes.EXAM_RESULTS,
      page: () => const ExamResultsView(),
      binding: ExamResultsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.DIGITAL_PRESCRIPTION,
      page: () => const DigitalPrescriptionView(),
      binding: DigitalPrescriptionBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
