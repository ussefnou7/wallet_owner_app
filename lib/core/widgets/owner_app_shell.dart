import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_spacing.dart';
import 'owner_app_drawer.dart';
import 'owner_bottom_nav_bar.dart';
import 'owner_top_bar.dart';

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

    return Scaffold(
      endDrawer: OwnerAppDrawer(currentRoute: currentRoute),
      bottomNavigationBar: OwnerBottomNavBar(
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
                    title: _titleForRoute(currentRoute),
                    onNotificationsPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notifications will be available soon.'),
                        ),
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

  static String _titleForRoute(String route) {
    switch (route) {
      case AppRoutes.wallets:
        return 'Wallets';
      case AppRoutes.transactions:
        return 'Transactions';
      case AppRoutes.createTransaction:
        return 'New Transaction';
      case AppRoutes.dashboard:
      default:
        return 'Dashboard';
    }
  }
}
