import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/queue_monitor_controller.dart';

class QueueMonitorView extends GetView<QueueMonitorController> {
  const QueueMonitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildCustomAppBar(theme, isDark),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  );
                }

                if (!controller.isHasActiveSession.value) {
                  return _buildNoSessionState(theme, isDark);
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeroSection(theme, isDark),
                      const SizedBox(height: 24),
                      _buildMainQueueCard(theme, isDark),
                      const SizedBox(height: 16),
                      _buildTimelineCard(theme, isDark),
                      const SizedBox(height: 16),
                      _buildBentoDetails(theme, isDark),
                      const SizedBox(height: 16),
                      _buildInfoBanner(theme, isDark),
                      const SizedBox(height: 16),
                      _buildImageAnchor(theme, isDark),
                      const SizedBox(height: 120),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(theme, isDark),
    );
  }

  Widget _buildCustomAppBar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/logo_klinik.png'),
              ),
              const SizedBox(width: 12),
              Text(
                'G&B Care Clinic',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: controller.testAudio,
              ),
              IconButton(
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: controller.openQRScanner,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CURRENT SESSION',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your health journey is in\nprogress.',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMainQueueCard(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: Column(
        children: [
          Obx(
            () => Text(
              controller.currentStatus.value == 'check_in'
                  ? 'STATUS'
                  : 'QUEUE POSITION',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onTertiary.withValues(alpha: 0.8),
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              controller.currentStatus.value == 'check_in'
                  ? 'Saat Ini'
                  : 'Number',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onTertiary,
                height: 1,
              ),
            ),
          ),
          Obx(
            () => Text(
              controller.currentStatus.value == 'check_in'
                  ? 'DIPANGGIL'
                  : controller.currentQueue.value,
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onTertiary,
                fontSize: controller.currentStatus.value == 'check_in'
                    ? 48
                    : null,
                height: 1,
              ),
            ),
          ),
          Container(
            height: 3,
            width: 40,
            color: theme.colorScheme.onTertiary.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(vertical: 24),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.onTertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.list_alt,
                  color: theme.colorScheme.onTertiary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    'Now Serving: ${controller.nowServing.value}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated wait',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Obx(() {
                    bool isCalled =
                        controller.currentStatus.value == 'check_in';
                    if (isCalled) {
                      return const AnimatedBlinkingText(text: 'CONSULT');
                    }
                    return Text(
                      '~${controller.estimatedWait.value} min',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        height: 1.2,
                      ),
                    );
                  }),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.hourglass_top,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 2,
                width: double.infinity,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 2,
                  width: 200,
                  color: theme.colorScheme.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimelineDot(
                    isCompleted: _isStatusReached('check-in', true),
                    isCurrent: _isStatusReached('check-in', false),
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildTimelineDot(
                    isCompleted: _isStatusReached('pre-screen', true),
                    isCurrent: _isStatusReached('pre-screen', false),
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildTimelineDot(
                    isCompleted: _isStatusReached('waiting', true),
                    isCurrent: _isStatusReached('waiting', false),
                    theme: theme,
                    isDark: isDark,
                  ),
                  _buildTimelineDot(
                    isCompleted: _isStatusReached('consult', true),
                    isCurrent: _isStatusReached('consult', false),
                    isFuture:
                        !_isStatusReached('consult', true) &&
                        !_isStatusReached('consult', false),
                    theme: theme,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimelineText(
                'CHECK-IN',
                _isStatusReached('check-in', false) ||
                    _isStatusReached('check-in', true),
                theme,
                isDark,
              ),
              _buildTimelineText(
                'PRE-SCREEN',
                _isStatusReached('pre-screen', false) ||
                    _isStatusReached('pre-screen', true),
                theme,
                isDark,
              ),
              _buildTimelineText(
                'WAITING',
                _isStatusReached('waiting', false) ||
                    _isStatusReached('waiting', true),
                theme,
                isDark,
              ),
              _buildTimelineText(
                'CONSULT',
                _isStatusReached('consult', false) ||
                    _isStatusReached('consult', true),
                theme,
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isStatusReached(String target, bool checkCompleted) {
    String current = controller.currentStatus.value.toLowerCase();

    // Map Laravel status to Timeline status
    String mappedCurrent = 'scheduled';
    if (current == 'check_in' || current == 'pemeriksaan')
      mappedCurrent = 'consult';
    else if (['selesai', 'pending_kasir', 'unpaid', 'paid'].contains(current))
      mappedCurrent = 'completed';

    List<String> statuses = [
      'scheduled',
      'check-in',
      'pre-screen',
      'waiting',
      'consult',
      'completed',
    ];
    int currentIdx = statuses.indexOf(mappedCurrent);
    int targetIdx = statuses.indexOf(target.toLowerCase());

    if (checkCompleted) {
      return currentIdx > targetIdx;
    } else {
      return currentIdx == targetIdx;
    }
  }

  Widget _buildTimelineText(
    String label,
    bool isActive,
    ThemeData theme,
    bool isDark,
  ) {
    return Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.bold,
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildNoSessionState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              "Belum ada jadwal pemeriksaan hari ini.",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Silakan lakukan booking terlebih dahulu melalui menu utama.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineDot({
    bool isCompleted = false,
    bool isCurrent = false,
    bool isFuture = false,
    required ThemeData theme,
    required bool isDark,
  }) {
    if (isCompleted) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.surface, width: 2),
        ),
        child: Icon(Icons.check, color: theme.colorScheme.onPrimary, size: 10),
      );
    } else if (isCurrent) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary, width: 3),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      );
    }
  }

  // 👇 INI YANG DIBENERIN BIAR NAMPILIN DATA DARI LARAVEL 👇
  Widget _buildBentoDetails(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 140,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.medical_services,
                  color: theme.colorScheme.secondary,
                  size: 28,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSIGNED DOCTOR',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.doctorName.value,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 140,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.meeting_room,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(
                          () => Text(
                            controller.clinicName.value.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOCATION',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.roomName.value,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb,
              color: theme.colorScheme.onTertiaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'While you wait',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enjoy complimentary herbal tea at our lounge or browse the wellness library in the digital app.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 👇 INI JUGA DITAMBAHIN ANTI ERROR 404 👇
  Widget _buildImageAnchor(ThemeData theme, bool isDark) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceContainerHighest, // Warna fallback
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=600&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    size: 40,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Clinic Sanctuary Space',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: theme.colorScheme.surface.withValues(alpha: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, 'Home', Icons.home, theme, isDark),
                _buildNavItem(1, 'History', Icons.history, theme, isDark),
                _buildNavItem(2, 'Notifs', Icons.notifications, theme, isDark),
                _buildNavItem(3, 'Profile', Icons.person, theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    IconData icon,
    ThemeData theme,
    bool isDark,
  ) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        width: 76,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBlinkingText extends StatefulWidget {
  final String text;
  const AnimatedBlinkingText({Key? key, required this.text}) : super(key: key);

  @override
  State<AnimatedBlinkingText> createState() => _AnimatedBlinkingTextState();
}

class _AnimatedBlinkingTextState extends State<AnimatedBlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        widget.text,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary,
          height: 1.2,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
