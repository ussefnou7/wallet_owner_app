import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../../features/notifications/presentation/widgets/notification_badge_icon.dart';
import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
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
    this.onBackPressed,
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
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      endDrawer: endDrawer,
      body: Stack(
        clipBehavior: Clip.none,
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
                          leading: onBackPressed != null
                              ? _ShellTopBarButton(
                                  tooltip: MaterialLocalizations.of(
                                    context,
                                  ).backButtonTooltip,
                                  icon: Icons.arrow_back_rounded,
                                  onPressed: onBackPressed!,
                                )
                              : showNotifications
                              ? const NotificationBadgeIcon()
                              : const SizedBox(width: 44, height: 44),
                          trailing: _ShellTopBarButton(
                            tooltip: 'Menu',
                            icon: Icons.menu_rounded,
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                          ),
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
                        padding: EdgeInsetsDirectional.only(
                          start: AppSpacing.md,
                          end: AppSpacing.md,
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
            bottom: bottomInset + AppDimensions.floatingBottomNavOffset,
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

class _ShellTopBarButton extends StatelessWidget {
  const _ShellTopBarButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
