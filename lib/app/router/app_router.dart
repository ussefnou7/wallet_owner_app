import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/session.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/branches/presentation/pages/branches_page.dart';
import '../../features/dashboard/presentation/pages/owner_dashboard_page.dart';
import '../../features/plans/presentation/pages/plans_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/request_renewal_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/transactions/presentation/pages/create_transaction_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../../features/wallets/presentation/pages/wallets_page.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authController.stream),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoading = authState.status == AuthStatus.loading;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (isLoading) {
        return isSplash ? null : AppRoutes.splash;
      }

      final session = authState.session;
      final isAuthenticated = session != null;
      final isOwner = session?.role == UserRole.owner;

      if (!isAuthenticated) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (!isOwner) {
        return AppRoutes.login;
      }

      if (isSplash || isLoggingIn) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const OwnerDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.wallets,
        name: 'wallets',
        builder: (context, state) => const WalletsPage(),
      ),
      GoRoute(
        path: AppRoutes.transactions,
        name: 'transactions',
        builder: (context, state) => const TransactionsPage(),
      ),
      GoRoute(
        path: AppRoutes.createTransaction,
        name: 'create-transaction',
        builder: (context, state) => const CreateTransactionPage(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: 'reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: AppRoutes.users,
        name: 'users',
        builder: (context, state) => const UsersPage(),
      ),
      GoRoute(
        path: AppRoutes.branches,
        name: 'branches',
        builder: (context, state) => const BranchesPage(),
      ),
      GoRoute(
        path: AppRoutes.plans,
        name: 'plans',
        builder: (context, state) => const PlansPage(),
      ),
      GoRoute(
        path: AppRoutes.requestRenewal,
        name: 'request-renewal',
        builder: (context, state) => const RequestRenewalPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
