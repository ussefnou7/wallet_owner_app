import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';
import 'owner_top_bar.dart';
import 'user_app_drawer.dart';
import 'user_bottom_nav_bar.dart';

class UserAppShell extends StatelessWidget {
  const UserAppShell({
    required this.currentRoute,
    required this.child,
    super.key,
  });

  final String currentRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final contentMaxWidth = currentRoute == AppRoutes.userCreateTransaction
        ? AppDimensions.compactContentMaxWidth
        : AppDimensions.contentMaxWidth;

    return Scaffold(
      endDrawer: const UserAppDrawer(),
      bottomNavigationBar: UserBottomNavBar(
        currentRoute: currentRoute,
        onRouteSelected: context.go,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppDimensions.screenPadding,
              child: Builder(
                builder: (context) {
                  return OwnerTopBar(
                    title: _titleForRoute(l10n, currentRoute),
                    onNotificationsPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.notificationsComingSoon)),
                      );
                    },
                    onMenuPressed: () => Scaffold.of(context).openEndDrawer(),
                  );
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      0,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _titleForRoute(AppLocalizations l10n, String route) {
    return switch (route) {
      AppRoutes.userWallets => l10n.wallets,
      AppRoutes.userTransactions => l10n.transactions,
      AppRoutes.userCreateTransaction => l10n.newTransaction,
      _ => l10n.dashboard,
    };
  }
}
