import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_metric_card.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_transactions.dart';

class OwnerDashboardPage extends ConsumerWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);

    return AppPageScaffold(
      title: 'Dashboard',
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications_none_rounded),
      ),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
      ],
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.dashboard),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: '',
        onDestinationSelected: context.go,
      ),
      padding: EdgeInsets.zero,
      maxWidth: AppDimensions.contentMaxWidth,
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 430;
            final crossAxisCount = isCompact ? 1 : 2;

            return SingleChildScrollView(
              padding: AppDimensions.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSectionHeader(
                    title: 'Overview',
                    subtitle:
                        'A quick snapshot of owner-level wallet activity and totals.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppMetricCard(
                    label: 'Total Profit',
                    value: formatCurrency(summary.totalProfit),
                    helperText: 'Updated from recorded wallet transactions.',
                    icon: Icons.trending_up_rounded,
                    highlighted: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isCompact ? 2.8 : 1.7,
                    children: [
                      AppMetricCard(
                        label: 'Active Wallets',
                        value: summary.activeWallets.toString(),
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                      AppMetricCard(
                        label: 'Total Transactions',
                        value: formatCompactNumber(summary.totalTransactions),
                        icon: Icons.receipt_long_outlined,
                      ),
                      AppMetricCard(
                        label: 'Total Credit',
                        value: formatCurrency(summary.totalCredit),
                        icon: Icons.south_west_rounded,
                      ),
                      AppMetricCard(
                        label: 'Total Debit',
                        value: formatCurrency(summary.totalDebit),
                        icon: Icons.north_east_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  DashboardQuickActions(
                    onCreateTransaction: () =>
                        context.go(AppRoutes.createTransaction),
                    onViewReports: () => context.go(AppRoutes.reports),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  DashboardRecentTransactions(
                    items: summary.recentTransactions.take(3).toList(),
                    onSeeAll: () => context.go(AppRoutes.transactions),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
