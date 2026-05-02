import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../constants/app_dimensions.dart';
import '../localization/app_l10n.dart';
import 'app_bottom_nav_bar.dart';
import 'app_shell_scaffold.dart';
import 'owner_app_drawer.dart';

class OwnerAppShell extends ConsumerStatefulWidget {
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
  ConsumerState<OwnerAppShell> createState() => _OwnerAppShellState();
}

class _OwnerAppShellState extends ConsumerState<OwnerAppShell>
    with WidgetsBindingObserver {
  Timer? _unreadCountTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _refreshUnreadCount();
      _startUnreadCountTimer();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshUnreadCount();
      _startUnreadCountTimer();
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _cancelUnreadCountTimer();
      return;
    }

    if (state == AppLifecycleState.inactive) {
      return;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelUnreadCountTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentMaxWidth =
        widget.currentRoute == AppRoutes.createTransaction ||
            widget.currentRoute == AppRoutes.ownerCreateSupport
        ? AppDimensions.compactContentMaxWidth
        : widget.maxWidth;

    return AppShellScaffold(
      title: _titleForRoute(context, widget.currentRoute),
      currentRoute: widget.currentRoute,
      navVariant: AppBottomNavVariant.owner,
      endDrawer: OwnerAppDrawer(currentRoute: widget.currentRoute),
      onDestinationSelected: context.go,
      onBackPressed: _backActionForRoute(context, widget.currentRoute),
      maxWidth: contentMaxWidth,
      showNotifications: true,
      child: widget.child,
    );
  }

  void _refreshUnreadCount() {
    unawaited(ref.read(notificationsProvider.notifier).loadUnreadCount());
  }

  void _startUnreadCountTimer() {
    _unreadCountTimer ??= Timer.periodic(
      const Duration(seconds: 90),
      (_) => _refreshUnreadCount(),
    );
  }

  void _cancelUnreadCountTimer() {
    _unreadCountTimer?.cancel();
    _unreadCountTimer = null;
  }

  VoidCallback? _backActionForRoute(BuildContext context, String route) {
    final canPop = context.canPop();

    if (_settingsDetailRoutes.contains(route)) {
      return canPop ? context.pop : () => context.go(AppRoutes.settings);
    }

    if (canPop) {
      return context.pop;
    }

    return null;
  }

  static String _titleForRoute(BuildContext context, String route) {
    final l10n = appL10n(context);
    if (route == AppRoutes.ownerCreateRenewalRequest) {
      return l10n.newRequest;
    }
    if (route == AppRoutes.ownerCreateSupport) {
      return l10n.newTicket;
    }

    switch (route) {
      case AppRoutes.ownerAbout:
        return l10n.aboutTa2feela;
      case AppRoutes.ownerPrivacyPolicy:
        return l10n.privacyPolicy;
      case AppRoutes.ownerTermsAndConditions:
        return l10n.termsAndConditions;
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
        return l10n.renewalRequests;
      case AppRoutes.ownerSupport:
        return l10n.supportTickets;
      case AppRoutes.ownerSettings:
        return l10n.settings;
      case AppRoutes.ownerNotifications:
        return l10n.notificationsTitle;
      case AppRoutes.ownerDashboard:
      default:
        return l10n.dashboard;
    }
  }
}

const _settingsDetailRoutes = {
  AppRoutes.ownerAbout,
  AppRoutes.ownerPrivacyPolicy,
  AppRoutes.ownerTermsAndConditions,
  AppRoutes.ownerPlans,
  AppRoutes.ownerRequestRenewal,
};
