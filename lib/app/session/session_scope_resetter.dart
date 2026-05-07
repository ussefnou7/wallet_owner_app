import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/branches/presentation/controllers/branches_controller.dart';
import '../../features/dashboard/presentation/controllers/user_dashboard_controller.dart';
import '../../features/dashboard/presentation/controllers/user_dashboard_recent_transactions_controller.dart';
import '../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/plans/presentation/controllers/plans_controller.dart';
import '../../features/settings/presentation/controllers/renewal_controller.dart';
import '../../features/settings/presentation/controllers/renewal_requests_controller.dart';
import '../../features/settings/presentation/controllers/request_renewal_controller.dart';
import '../../features/settings/presentation/controllers/support_controller.dart';
import '../../features/settings/presentation/controllers/support_tickets_controller.dart';
import '../../features/transactions/presentation/controllers/create_transaction_controller.dart';
import '../../features/transactions/presentation/controllers/transactions_controller.dart';
import '../../features/users/presentation/controllers/users_controller.dart';
import '../../features/wallets/presentation/controllers/wallets_controller.dart';

abstract final class SessionScopedCacheInvalidator {
  static void invalidateContainer(ProviderContainer container) {
    _invalidate(container.invalidate);
  }

  static void invalidateRef(Ref ref) {
    _invalidate(ref.invalidate);
  }

  static void _invalidate(void Function(ProviderOrFamily provider) invalidate) {
    invalidate(walletsSearchQueryProvider);
    invalidate(walletSortOptionProvider);
    invalidate(walletTypesProvider);
    invalidate(walletsControllerProvider);
    invalidate(walletDetailsProvider);

    invalidate(transactionsSearchQueryProvider);
    invalidate(transactionsControllerProvider);
    invalidate(transactionDetailsProvider);
    invalidate(createTransactionControllerProvider);

    invalidate(branchesSearchQueryProvider);
    invalidate(branchesStatusFilterProvider);
    invalidate(branchesControllerProvider);

    invalidate(usersSearchQueryProvider);
    invalidate(usersRoleFilterProvider);
    invalidate(usersControllerProvider);

    invalidate(dashboardOverviewProvider);
    invalidate(userDashboardOverviewProvider);
    invalidate(userDashboardControllerProvider);
    invalidate(userDashboardRecentTransactionsControllerProvider);
    invalidate(dashboardTransactionSummaryProvider);
    invalidate(dashboardRecentTransactionsProvider);

    invalidate(plansControllerProvider);
    invalidate(notificationsProvider);

    invalidate(renewalRequestsControllerProvider);
    invalidate(renewalControllerProvider);
    invalidate(requestRenewalControllerProvider);
    invalidate(supportTicketsControllerProvider);
    invalidate(supportControllerProvider);
  }
}
