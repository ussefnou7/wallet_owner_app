import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../constants/app_dimensions.dart';
import '../localization/app_l10n.dart';
import 'app_bottom_nav_bar.dart';
import 'app_shell_scaffold.dart';
import 'user_app_drawer.dart';

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
    final contentMaxWidth =
        currentRoute == AppRoutes.userCreateTransaction ||
            currentRoute == AppRoutes.userCreateSupport
        ? AppDimensions.compactContentMaxWidth
        : AppDimensions.contentMaxWidth;

    return AppShellScaffold(
      title: _titleForRoute(context, currentRoute),
      currentRoute: currentRoute,
      navVariant: AppBottomNavVariant.user,
      endDrawer: UserAppDrawer(currentRoute: currentRoute),
      onDestinationSelected: context.go,
      onBackPressed: context.canPop() ? context.pop : null,
      maxWidth: contentMaxWidth,
      showNotifications: false,
      child: child,
    );
  }

  static String _titleForRoute(BuildContext context, String route) {
    final l10n = appL10n(context);
    return switch (route) {
      AppRoutes.userWallets => l10n.wallets,
      AppRoutes.userTransactions => l10n.transactions,
      AppRoutes.userCreateTransaction => l10n.newTransaction,
      AppRoutes.userSupport => l10n.supportTickets,
      AppRoutes.userCreateSupport => l10n.newTicket,
      _ => l10n.dashboard,
    };
  }
}
