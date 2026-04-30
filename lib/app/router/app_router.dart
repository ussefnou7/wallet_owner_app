import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/owner_app_shell.dart';
import '../../core/widgets/user_app_shell.dart';
import '../../features/auth/domain/entities/session.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/unauthorized_role_page.dart';
import '../../features/branches/presentation/pages/branches_page.dart';
import '../../features/dashboard/presentation/pages/owner_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/user_dashboard_page.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/plans/presentation/pages/plans_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/create_renewal_request_page.dart';
import '../../features/settings/presentation/pages/create_support_ticket_page.dart';
import '../../features/settings/presentation/pages/request_renewal_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/support_page.dart';
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
      final location = state.matchedLocation;
      final isSplash = location == AppRoutes.splash;
      final isLoggingIn = location == AppRoutes.login;
      final isUnauthorizedRole = location == AppRoutes.unauthorizedRole;

      if (isLoading) {
        return isSplash ? null : AppRoutes.splash;
      }

      final session = authState.session;
      final isAuthenticated = session != null;

      if (!isAuthenticated) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (session.role == UserRole.unknown) {
        return isUnauthorizedRole ? null : AppRoutes.unauthorizedRole;
      }

      if (isUnauthorizedRole) {
        return _homeForRole(session.role);
      }

      if (isSplash || isLoggingIn) {
        return _homeForRole(session.role);
      }

      if (session.role == UserRole.owner && _isUserRoute(location)) {
        return AppRoutes.ownerDashboard;
      }

      if (session.role == UserRole.user && _isOwnerRoute(location)) {
        return AppRoutes.userDashboard;
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
        path: AppRoutes.unauthorizedRole,
        name: 'unauthorized-role',
        builder: (context, state) => const UnauthorizedRolePage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return OwnerAppShell(
            currentRoute: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.ownerDashboard,
            name: 'owner-dashboard',
            builder: (context, state) => const OwnerDashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerWallets,
            name: 'owner-wallets',
            builder: (context, state) => const WalletsPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerTransactions,
            name: 'owner-transactions',
            builder: (context, state) => const TransactionsPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerCreateTransaction,
            name: 'owner-create-transaction',
            builder: (context, state) => const CreateTransactionPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerReports,
            name: 'owner-reports',
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerUsers,
            name: 'owner-users',
            builder: (context, state) => const UsersPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerBranches,
            name: 'owner-branches',
            builder: (context, state) => const BranchesPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerPlans,
            name: 'owner-plans',
            builder: (context, state) => const PlansPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerRequestRenewal,
            name: 'owner-request-renewal',
            builder: (context, state) => const RequestRenewalPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerCreateRenewalRequest,
            name: 'owner-create-renewal-request',
            builder: (context, state) => const CreateRenewalRequestPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerSupport,
            name: 'owner-support',
            builder: (context, state) => const SupportPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerCreateSupport,
            name: 'owner-create-support',
            builder: (context, state) => const CreateSupportTicketPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerSettings,
            name: 'owner-settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerNotifications,
            name: 'owner-notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          return UserAppShell(
            currentRoute: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.userDashboard,
            name: 'user-dashboard',
            builder: (context, state) => const UserDashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.userWallets,
            name: 'user-wallets',
            builder: (context, state) => const WalletsPage(readOnly: true),
          ),
          GoRoute(
            path: AppRoutes.userTransactions,
            name: 'user-transactions',
            builder: (context, state) => const TransactionsPage(),
          ),
          GoRoute(
            path: AppRoutes.userCreateTransaction,
            name: 'user-create-transaction',
            builder: (context, state) => const CreateTransactionPage(),
          ),
        ],
      ),
    ],
  );
});

String _homeForRole(UserRole role) {
  return switch (role) {
    UserRole.owner => AppRoutes.ownerDashboard,
    UserRole.user => AppRoutes.userDashboard,
    UserRole.unknown => AppRoutes.unauthorizedRole,
  };
}

bool _isOwnerRoute(String location) {
  return location == '/owner' || location.startsWith('/owner/');
}

bool _isUserRoute(String location) {
  return location == '/user' || location.startsWith('/user/');
}
