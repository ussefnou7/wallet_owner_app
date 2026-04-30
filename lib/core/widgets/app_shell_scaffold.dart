import 'package:flutter/material.dart';

import '../../features/notifications/presentation/widgets/notification_badge_icon.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_bottom_nav_bar.dart';
import 'owner_top_bar.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.title,
    required this.currentRoute,
    required this.navVariant,
    required this.endDrawer,
    required this.onDestinationSelected,
    required this.child,
    this.maxWidth = 640.0,
    this.showNotifications = false,
    super.key,
  });

  final String title;
  final String currentRoute;
  final AppBottomNavVariant navVariant;
  final Widget endDrawer;
  final ValueChanged<String> onDestinationSelected;
  final Widget child;
  final double maxWidth;
  final bool showNotifications;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      endDrawer: endDrawer,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    child: Builder(
                      builder: (context) {
                        return OwnerTopBar(
                          title: title,
                          notifications: showNotifications
                              ? const NotificationBadgeIcon()
                              : const SizedBox(width: 44, height: 44),
                          onMenuPressed: () =>
                              Scaffold.of(context).openEndDrawer(),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomInset + 10,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: AppBottomNavBar(
                  variant: navVariant,
                  currentRoute: currentRoute,
                  onDestinationSelected: onDestinationSelected,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
