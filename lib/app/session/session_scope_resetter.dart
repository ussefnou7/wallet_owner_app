import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/branches/presentation/controllers/branches_controller.dart';
import '../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/plans/presentation/controllers/plans_controller.dart';
import '../../features/reports/presentation/controllers/reports_controller.dart';
import '../../features/settings/presentation/controllers/renewal_controller.dart';
import '../../features/settings/presentation/controllers/renewal_requests_controller.dart';
import '../../features/settings/presentation/controllers/request_renewal_controller.dart';
import '../../features/settings/presentation/controllers/support_controller.dart';
import '../../features/settings/presentation/controllers/support_tickets_controller.dart';
import '../../features/transactions/presentation/controllers/create_transaction_controller.dart';
import '../../features/transactions/presentation/controllers/transactions_controller.dart';
import '../../features/users/presentation/controllers/users_controller.dart';
import '../../features/wallets/presentation/controllers/wallets_controller.dart';

void resetSessionScopedProviders(ProviderContainer container) {
  container.invalidate(walletsSearchQueryProvider);
  container.invalidate(walletTypesProvider);
  container.invalidate(walletsControllerProvider);
  container.invalidate(walletDetailsProvider);

  container.invalidate(transactionsSearchQueryProvider);
  container.invalidate(transactionsFilterProvider);
  container.invalidate(transactionsControllerProvider);
  container.invalidate(transactionDetailsProvider);
  container.invalidate(createTransactionControllerProvider);

  container.invalidate(branchesSearchQueryProvider);
  container.invalidate(branchesStatusFilterProvider);
  container.invalidate(branchesControllerProvider);

  container.invalidate(usersSearchQueryProvider);
  container.invalidate(usersRoleFilterProvider);
  container.invalidate(usersControllerProvider);

  container.invalidate(dashboardOverviewProvider);
  container.invalidate(userDashboardOverviewProvider);
  container.invalidate(dashboardTransactionSummaryProvider);
  container.invalidate(dashboardRecentTransactionsProvider);

  container.invalidate(reportsSelectedTypeProvider);
  container.invalidate(reportsAppliedFiltersProvider);
  container.invalidate(reportsControllerProvider);

  container.invalidate(plansControllerProvider);
  container.invalidate(notificationsProvider);

  container.invalidate(renewalRequestsControllerProvider);
  container.invalidate(renewalControllerProvider);
  container.invalidate(requestRenewalControllerProvider);
  container.invalidate(supportTicketsControllerProvider);
  container.invalidate(supportControllerProvider);
}
