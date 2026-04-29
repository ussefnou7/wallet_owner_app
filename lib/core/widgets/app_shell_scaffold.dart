import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';
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
    super.key,
  });

  final String title;
  final String currentRoute;
  final AppBottomNavVariant navVariant;
  final Widget endDrawer;
  final ValueChanged<String> onDestinationSelected;
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
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
                          onNotificationsPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.notificationsComingSoon),
                              ),
                            );
                          },
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
