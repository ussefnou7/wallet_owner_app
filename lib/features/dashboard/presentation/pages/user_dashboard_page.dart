import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../../transactions/domain/entities/transaction_record.dart';
import '../../../transactions/presentation/widgets/compact_transaction_list_item.dart';
import '../../domain/entities/owner_dashboard_overview.dart';
import '../../domain/entities/user_dashboard_overview.dart';
import '../controllers/user_dashboard_controller.dart';
import '../controllers/user_dashboard_recent_transactions_controller.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(userDashboardControllerProvider);
    final transactionsState = ref.watch(
      userDashboardRecentTransactionsControllerProvider,
    );
    final l10n = appL10n(context);
    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight +
        AppSpacing.lg;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(userDashboardControllerProvider.notifier).refresh(),
          ref
              .read(userDashboardRecentTransactionsControllerProvider.notifier)
              .refresh(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(
          top: AppSpacing.md,
          bottom: bottomContentPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: l10n.userDashboardTitle,
              subtitle: l10n.userDashboardSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (dashboardState.error != null && !dashboardState.isLoading) ...[
              AppErrorState(
                message: ErrorMessageMapper.getLocalizedMessage(
                  context,
                  dashboardState.error,
                  fallbackMessage: l10n.userDashboardUnableToLoadSummary,
                ),
                compact: true,
                onRetry: () =>
                    ref.read(userDashboardControllerProvider.notifier).retry(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (dashboardState.isLoading && !dashboardState.hasLoadedOnce) ...[
              _UserDashboardLoadingState(
                selectedPeriod: dashboardState.selectedPeriod,
              ),
            ] else ...[
              _UserDashboardOverviewSection(
                overview: dashboardState.overview,
                selectedPeriod: dashboardState.selectedPeriod,
                isRefreshing: dashboardState.isRefreshing,
                onPeriodSelected: (period) {
                  if (period == dashboardState.selectedPeriod) {
                    return;
                  }
                  unawaited(
                    ref
                        .read(userDashboardControllerProvider.notifier)
                        .selectPeriod(period),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _UserDashboardWalletStatusSection(
                branchWallets: dashboardState.overview.branchWallets,
                walletConsumptions: dashboardState.overview.walletConsumptions,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            _UserDashboardRecentTransactionsSection(state: transactionsState),
          ],
        ),
      ),
    );
  }
}

class _UserDashboardLoadingState extends StatelessWidget {
  const _UserDashboardLoadingState({required this.selectedPeriod});

  final DashboardOverviewPeriod selectedPeriod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UserDashboardOverviewSection.loading(selectedPeriod: selectedPeriod),
        const SizedBox(height: AppSpacing.lg),
        const _UserDashboardWalletStatusSection.loading(),
      ],
    );
  }
}

class _UserDashboardOverviewSection extends StatelessWidget {
  const _UserDashboardOverviewSection({
    required this.overview,
    required this.selectedPeriod,
    required this.isRefreshing,
    required this.onPeriodSelected,
  }) : isLoading = false;

  const _UserDashboardOverviewSection.loading({required this.selectedPeriod})
    : overview = null,
      isRefreshing = false,
      onPeriodSelected = _noopPeriodSelected,
      isLoading = true;

  final UserDashboardOverview? overview;
  final DashboardOverviewPeriod selectedPeriod;
  final bool isRefreshing;
  final ValueChanged<DashboardOverviewPeriod> onPeriodSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final activity = overview?.myActivity;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dashboardHeroStart,
            AppColors.dashboardHeroMid,
            AppColors.dashboardHeroEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -12,
            right: -28,
            child: _GlowOrb(
              color: Colors.white.withValues(alpha: 0.04),
              size: 74,
            ),
          ),
          Positioned(
            bottom: -30,
            left: -12,
            child: _GlowOrb(
              color: AppColors.dashboardHeroGlow.withValues(alpha: 0.12),
              size: 104,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, end: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.overview,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.userDashboardSubtitle,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.72),
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (isRefreshing)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.8,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              _DashboardPeriodSelector(
                selectedPeriod: selectedPeriod,
                onSelected: onPeriodSelected,
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      l10n.transactionVolume,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: isLoading
                          ? const _HeroValuePlaceholder()
                          : Text(
                              _formatCurrencyValue(
                                activity?.transactionsVolume ?? 0,
                              ),
                              key: ValueKey<double>(
                                activity?.transactionsVolume ?? 0,
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    height: 1.05,
                                  ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final tileWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
                  return Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      SizedBox(
                        width: tileWidth,
                        child: _HeroMetricTile(
                          label: l10n.totalCredits,
                          value: activity == null
                              ? null
                              : _formatCurrencyValue(activity.totalCredits),
                          icon: Icons.call_received_rounded,
                          isLoading: isLoading,
                        ),
                      ),
                      SizedBox(
                        width: tileWidth,
                        child: _HeroMetricTile(
                          label: l10n.totalDebits,
                          value: activity == null
                              ? null
                              : _formatCurrencyValue(activity.totalDebits),
                          icon: Icons.call_made_rounded,
                          isLoading: isLoading,
                        ),
                      ),
                      SizedBox(
                        width: tileWidth,
                        child: _HeroMetricTile(
                          label: l10n.totalProfit,
                          value: activity == null
                              ? null
                              : _formatCurrencyValue(activity.totalProfit),
                          icon: Icons.trending_up_rounded,
                          isLoading: isLoading,
                        ),
                      ),
                      SizedBox(
                        width: tileWidth,
                        child: _HeroMetricTile(
                          label: l10n.transactionsCount,
                          value: activity == null
                              ? null
                              : _formatCountValue(activity.transactionsCount),
                          icon: Icons.receipt_long_outlined,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserDashboardWalletStatusSection extends StatelessWidget {
  const _UserDashboardWalletStatusSection({
    required this.branchWallets,
    required this.walletConsumptions,
  }) : isLoading = false;

  const _UserDashboardWalletStatusSection.loading()
    : branchWallets = null,
      walletConsumptions = const <UserDashboardWalletConsumption>[],
      isLoading = true;

  final UserDashboardBranchWallets? branchWallets;
  final List<UserDashboardWalletConsumption> walletConsumptions;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return _SurfaceSectionCard(
      title: l10n.walletStatus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WalletSummaryTile(
            isLoading: isLoading,
            label: l10n.wallets,
            value: isLoading
                ? null
                : _formatCountValue(branchWallets?.walletsCount ?? 0),
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.primary,
            iconBackground: AppColors.primarySoft,
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  SizedBox(
                    width: tileWidth,
                    child: _WalletMetricTile(
                      label: l10n.totalBalance,
                      value: isLoading
                          ? null
                          : _formatCurrencyValue(
                              branchWallets?.totalBalance ?? 0,
                            ),
                      icon: Icons.account_balance_rounded,
                      tone: _MetricTone.neutral,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _WalletMetricTile(
                      label: l10n.nearLimitWallets,
                      value: isLoading
                          ? null
                          : _formatCountValue(
                              branchWallets?.nearLimitWalletsCount ?? 0,
                            ),
                      icon: Icons.warning_amber_rounded,
                      tone: _MetricTone.warning,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.walletConsumptions,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (isLoading)
            const Column(
              children: [
                _AttentionRowPlaceholder(),
                SizedBox(height: AppSpacing.sm),
                _AttentionRowPlaceholder(),
              ],
            )
          else if (walletConsumptions.isEmpty)
            AppEmptyState(
              title: l10n.walletConsumptions,
              message: l10n.walletConsumptionsEmptyMessage,
              icon: Icons.show_chart_rounded,
            )
          else
            Column(
              children: [
                for (
                  var index = 0;
                  index < walletConsumptions.length;
                  index++
                ) ...[
                  _WalletConsumptionCard(item: walletConsumptions[index]),
                  if (index != walletConsumptions.length - 1)
                    const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _UserDashboardRecentTransactionsSection extends StatelessWidget {
  const _UserDashboardRecentTransactionsSection({required this.state});

  final UserDashboardRecentTransactionsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return _SurfaceSectionCard(
      title: l10n.lastTransactions,
      child: Builder(
        builder: (context) {
          if (state.isLoading && !state.hasLoadedOnce) {
            return const _RecentTransactionsLoadingState();
          }

          if (state.error != null && !state.isLoading) {
            return AppErrorState(
              message: ErrorMessageMapper.getLocalizedMessage(
                context,
                state.error,
                fallbackMessage: l10n.noTransactionsAvailable,
              ),
              compact: true,
            );
          }

          if (state.items.isEmpty) {
            return AppEmptyState(
              title: l10n.noTransactionsAvailable,
              message: l10n.transactionsEmptyMessage,
              icon: Icons.receipt_long_outlined,
            );
          }

          return Column(
            children: [
              for (var index = 0; index < state.items.length; index++) ...[
                _UserTransactionTile(item: state.items[index]),
                if (index != state.items.length - 1)
                  const Divider(height: AppSpacing.lg, thickness: 0.6),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _UserTransactionTile extends StatelessWidget {
  const _UserTransactionTile({required this.item});

  final TransactionRecord item;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final isCredit = item.type == TransactionEntryType.credit;

    return CompactTransactionListItem(
      walletName: item.walletName,
      amount: item.amount,
      isCredit: isCredit,
      typeLabel: isCredit ? l10n.credit : l10n.debit,
      recordedAt: item.occurredAt ?? item.createdAt ?? item.date,
      description: item.note,
    );
  }
}

class _RecentTransactionsLoadingState extends StatelessWidget {
  const _RecentTransactionsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AttentionRowPlaceholder(),
        SizedBox(height: AppSpacing.sm),
        _AttentionRowPlaceholder(),
        SizedBox(height: AppSpacing.sm),
        _AttentionRowPlaceholder(),
      ],
    );
  }
}

class _WalletConsumptionCard extends StatelessWidget {
  const _WalletConsumptionCard({required this.item});

  final UserDashboardWalletConsumption item;

  @override
  Widget build(BuildContext context) {
    final subtitle = item.branchName?.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.walletName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const _SoftIconBox(
                size: 34,
                backgroundColor: AppColors.primarySoft,
                iconColor: AppColors.primary,
                icon: Icons.show_chart_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _ConsumptionMetric(
                  label: appL10n(context).daily,
                  value: _formatPercentValue(item.dailyPercent),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ConsumptionMetric(
                  label: appL10n(context).monthly,
                  value: _formatPercentValue(item.monthlyPercent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsumptionMetric extends StatelessWidget {
  const _ConsumptionMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceSectionCard extends StatelessWidget {
  const _SurfaceSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.055),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _DashboardPeriodSelector extends StatelessWidget {
  const _DashboardPeriodSelector({
    required this.selectedPeriod,
    required this.onSelected,
  });

  final DashboardOverviewPeriod selectedPeriod;
  final ValueChanged<DashboardOverviewPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final options = [
      (DashboardOverviewPeriod.daily, l10n.daily),
      (DashboardOverviewPeriod.monthly, l10n.monthly),
      (DashboardOverviewPeriod.yearly, l10n.yearly),
    ];

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _PeriodButton(
                label: option.$2,
                selected: option.$1 == selectedPeriod,
                onTap: () => onSelected(option.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.14)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: selected
            ? Border.all(color: Colors.white.withValues(alpha: 0.08))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: selected ? null : onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.5),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.70),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroMetricTile extends StatelessWidget {
  const _HeroMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.isLoading,
  });

  final String label;
  final String? value;
  final IconData icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIconBox(
            size: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.07),
            iconColor: Colors.white,
            icon: icon,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
              fontWeight: FontWeight.w400,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 5),
          if (isLoading)
            const _ValuePlaceholder(
              width: 76,
              height: 14,
              color: Colors.white24,
            )
          else
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                alignment: AlignmentDirectional.centerStart,
                fit: BoxFit.scaleDown,
                child: Text(
                  value ?? '--',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletSummaryTile extends StatelessWidget {
  const _WalletSummaryTile({
    required this.isLoading,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final bool isLoading;
  final String label;
  final String? value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.54),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.60)),
      ),
      child: Row(
        children: [
          _SoftIconBox(
            size: 38,
            backgroundColor: iconBackground,
            iconColor: iconColor,
            icon: icon,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (isLoading)
            const _ValuePlaceholder(width: 72)
          else
            Text(
              value ?? '--',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletMetricTile extends StatelessWidget {
  const _WalletMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String? value;
  final IconData icon;
  final _MetricTone tone;

  @override
  Widget build(BuildContext context) {
    final resolvedTone = _metricToneColors(tone);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIconBox(
            size: 32,
            backgroundColor: resolvedTone.background,
            iconColor: resolvedTone.foreground,
            icon: icon,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.24,
            ),
          ),
          const SizedBox(height: 7),
          if (value == null)
            const _ValuePlaceholder(width: 64)
          else
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                alignment: AlignmentDirectional.centerStart,
                fit: BoxFit.scaleDown,
                child: Text(
                  value!,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SoftIconBox extends StatelessWidget {
  const _SoftIconBox({
    required this.size,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });

  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _AttentionRowPlaceholder extends StatelessWidget {
  const _AttentionRowPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: const Row(
        children: [
          _ValuePlaceholder(width: 36, height: 36),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: _ValuePlaceholder(width: double.infinity)),
        ],
      ),
    );
  }
}

class _HeroValuePlaceholder extends StatelessWidget {
  const _HeroValuePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const _ValuePlaceholder(
      width: 220,
      height: 34,
      color: Colors.white24,
    );
  }
}

class _ValuePlaceholder extends StatelessWidget {
  const _ValuePlaceholder({required this.width, this.height = 16, this.color});

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

enum _MetricTone { neutral, warning }

class _ToneColors {
  const _ToneColors({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

_ToneColors _metricToneColors(_MetricTone tone) {
  return switch (tone) {
    _MetricTone.warning => const _ToneColors(
      foreground: AppColors.warning,
      background: AppColors.warningSoft,
    ),
    _MetricTone.neutral => const _ToneColors(
      foreground: AppColors.primary,
      background: AppColors.primarySoft,
    ),
  };
}

String _formatCurrencyValue(num value) => formatCurrency(value);

String _formatCountValue(num value) {
  final formatter = NumberFormat.decimalPattern(Intl.getCurrentLocale());
  return formatter.format(value);
}

String _formatPercentValue(num value) {
  final hasFraction = value % 1 != 0;
  final formatter = NumberFormat.decimalPatternDigits(
    locale: Intl.getCurrentLocale(),
    decimalDigits: hasFraction ? 1 : 0,
  );
  return '${formatter.format(value)}%';
}

void _noopPeriodSelected(DashboardOverviewPeriod _) {}
