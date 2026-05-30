import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  final bool isFromMainLayout;
  const NotificationsView({super.key, this.isFromMainLayout = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }

          if (controller.todayNotifs.isEmpty && controller.earlierNotifs.isEmpty) {
            return Center(
              child: Text(
                'Belum ada notifikasi.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Inbox',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.markAllAsRead,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Mark all as read',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (controller.todayNotifs.isNotEmpty) ...[
                  _buildSectionHeader('TODAY', theme),
                  Column(
                    children: controller.todayNotifs.map((notif) => _buildDynamicNotifCard(notif, theme, isDark)).toList(),
                  ),
                ],
                if (controller.earlierNotifs.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionHeader('EARLIER', theme),
                  Column(
                    children: controller.earlierNotifs.map((notif) => _buildDynamicNotifCard(notif, theme, isDark)).toList(),
                  ),
                ],
                const SizedBox(height: 120),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: isFromMainLayout ? null : _buildBottomNav(theme, isDark),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: theme.colorScheme.surfaceContainerHighest)),
        ],
      ),
    );
  }

  Widget _buildDynamicNotifCard(Map<String, dynamic> notif, ThemeData theme, bool isDark) {
    String type = notif['type'] ?? 'info';
    bool isRead = notif['isRead'] ?? false;
    IconData icon;
    Color iconColor;
    Color bgColor;

    if (type == 'appointment') {
      icon = Icons.calendar_month;
      iconColor = theme.colorScheme.primary;
      bgColor = theme.colorScheme.primaryContainer;
    } else if (type == 'invoice') {
      icon = Icons.receipt_long;
      iconColor = theme.colorScheme.secondary;
      bgColor = theme.colorScheme.secondaryContainer;
    } else {
      icon = Icons.notifications;
      iconColor = theme.colorScheme.tertiary;
      bgColor = theme.colorScheme.tertiaryContainer;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark 
          ? (isRead ? Colors.transparent : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5))
          : (isRead ? theme.colorScheme.surface.withValues(alpha: 0.5) : theme.colorScheme.surface),
        borderRadius: BorderRadius.circular(12),
        border: isRead ? Border.all(color: theme.colorScheme.surfaceContainerHighest) : Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
        boxShadow: isRead || isDark ? [] : [
          BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRead)
            Container(
              margin: const EdgeInsets.only(top: 20, right: 8),
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
            )
          else
            const SizedBox(width: 14),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif['title'],
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      notif['time'],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notif['desc'],
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

  Widget _buildBottomNav(ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 90,
          color: theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, 'Home', Icons.home, theme, isDark),
              _buildNavItem(1, 'History', Icons.history, theme, isDark),
              _buildNavItem(2, 'Notifs', Icons.notifications, theme, isDark),
              _buildNavItem(3, 'Profile', Icons.person, theme, isDark),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, ThemeData theme, bool isDark) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}