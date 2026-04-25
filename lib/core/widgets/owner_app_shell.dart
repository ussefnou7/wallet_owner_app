import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../constants/app_dimensions.dart';
import '../localization/app_l10n.dart';
import 'app_bottom_nav_bar.dart';
import 'app_shell_scaffold.dart';
import 'owner_app_drawer.dart';

class OwnerAppShell extends StatelessWidget {
  const OwnerAppShell({
    required this.currentRoute,
    required this.child,
    this.maxWidth = AppDimensions.contentMaxWidth,
    super.key,
  });

  final String currentRoute;
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final contentMaxWidth = currentRoute == AppRoutes.createTransaction
        ? AppDimensions.compactContentMaxWidth
        : maxWidth;

    return AppShellScaffold(
      title: _titleForRoute(context, currentRoute),
      currentRoute: currentRoute,
      navVariant: AppBottomNavVariant.owner,
      endDrawer: OwnerAppDrawer(currentRoute: currentRoute),
      onDestinationSelected: context.go,
      maxWidth: contentMaxWidth,
      child: child,
    );
  }

  static String _titleForRoute(BuildContext context, String route) {
    final l10n = appL10n(context);
    switch (route) {
      case AppRoutes.ownerWallets:
        return l10n.wallets;
      case AppRoutes.ownerTransactions:
        return l10n.transactions;
      case AppRoutes.ownerCreateTransaction:
        return l10n.newTransaction;
      case AppRoutes.ownerReports:
        return l10n.reports;
      case AppRoutes.ownerUsers:
        return l10n.users;
      case AppRoutes.ownerBranches:
        return l10n.branches;
      case AppRoutes.ownerPlans:
        return l10n.plans;
      case AppRoutes.ownerRequestRenewal:
        return l10n.requestRenewal;
      case AppRoutes.ownerSettings:
        return l10n.settings;
      case AppRoutes.ownerDashboard:
      default:
        return l10n.dashboard;
    }
  }
}
