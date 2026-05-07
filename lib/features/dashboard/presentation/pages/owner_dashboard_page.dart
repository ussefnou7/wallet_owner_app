import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/entities/owner_dashboard_overview.dart';
import '../controllers/owner_dashboard_controller.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_recent_transactions.dart';

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> {
  bool _isAttentionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(ownerDashboardControllerProvider);
    final recentTransactions = ref.watch(dashboardRecentTransactionsProvider);
    final l10n = appL10n(context);
    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight +
        AppSpacing.lg;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(ownerDashboardControllerProvider.notifier).refresh(),
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
              title: l10n.portfolioOverview,
              subtitle: l10n.portfolioOverviewSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (dashboardState.error != null && !dashboardState.isLoading) ...[
              AppErrorState(
                message: ErrorMessageMapper.getMessage(dashboardState.error),
                compact: true,
                onRetry: () =>
                    ref.read(ownerDashboardControllerProvider.notifier).retry(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (dashboardState.isLoading && !dashboardState.hasLoadedOnce) ...[
              _DashboardLoadingState(
                selectedPeriod: dashboardState.selectedPeriod,
              ),
            ] else ...[
              _ProfitSnapshotHero(
                overview: dashboardState.overview,
                selectedPeriod: dashboardState.selectedPeriod,
                isRefreshing: dashboardState.isRefreshing,
                onPeriodSelected: _handlePeriodSelected,
              ),
              const SizedBox(height: AppSpacing.lg),
              _WalletHealthCard(
                health: dashboardState.overview.walletHealth,
                isExpanded: _isAttentionExpanded,
                onToggleExpanded:
                    dashboardState
                            .overview
                            .walletHealth
                            .walletsNeedAttentionCount >
                        0
                    ? () => setState(
                        () => _isAttentionExpanded = !_isAttentionExpanded,
                      )
                    : null,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            recentTransactions.when(
              loading: () => const AppLoadingView(
                message: 'Loading recent transactions...',
              ),
              error: (error, stackTrace) => AppErrorState(
                message: ErrorMessageMapper.getMessage(error),
                compact: true,
                onRetry: () =>
                    ref.invalidate(dashboardRecentTransactionsProvider),
              ),
              data: (items) => DashboardRecentTransactions(
                items: items,
                onSeeAll: () => context.go(AppRoutes.ownerTransactions),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePeriodSelected(DashboardOverviewPeriod period) {
    if (period == ref.read(ownerDashboardControllerProvider).selectedPeriod) {
      return;
    }

    if (_isAttentionExpanded) {
      setState(() => _isAttentionExpanded = false);
    }

    unawaited(
      ref.read(ownerDashboardControllerProvider.notifier).selectPeriod(period),
    );
  }
}

class _DashboardLoadingState extends StatelessWidget {
  const _DashboardLoadingState({required this.selectedPeriod});

  final DashboardOverviewPeriod selectedPeriod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfitSnapshotHero.loading(selectedPeriod: selectedPeriod),
        const SizedBox(height: AppSpacing.lg),
        const _WalletHealthCard.loading(),
      ],
    );
  }
}

class _ProfitSnapshotHero extends StatelessWidget {
  const _ProfitSnapshotHero({
    required this.overview,
    required this.selectedPeriod,
    required this.isRefreshing,
    required this.onPeriodSelected,
  }) : isLoading = false;

  const _ProfitSnapshotHero.loading({required this.selectedPeriod})
    : overview = null,
      isRefreshing = false,
      isLoading = true,
      onPeriodSelected = _noopPeriodSelected;

  final OwnerDashboardOverview? overview;
  final DashboardOverviewPeriod selectedPeriod;
  final bool isRefreshing;
  final bool isLoading;
  final ValueChanged<DashboardOverviewPeriod> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final snapshot = overview?.profitSnapshot;
    final heroMetrics = [
      _HeroMetricData(
        label: l10n.dashboardCollectedProfit,
        value: snapshot == null
            ? null
            : _formatCurrencyValue(snapshot.totalCollectedProfit),
        icon: Icons.call_received_rounded,
      ),
      _HeroMetricData(
        label: l10n.dashboardUncollectedProfit,
        value: snapshot == null
            ? null
            : _formatCurrencyValue(snapshot.totalUncollectedProfit),
        icon: Icons.hourglass_bottom_rounded,
      ),
      _HeroMetricData(
        label: l10n.transactions,
        value: snapshot == null
            ? null
            : _formatCountValue(snapshot.totalTransactions),
        icon: Icons.receipt_long_outlined,
      ),
      _HeroMetricData(
        label: l10n.dashboardTransactionVolume,
        value: snapshot == null
            ? null
            : _formatCurrencyValue(snapshot.totalTransactionVolume),
        icon: Icons.show_chart_rounded,
      ),
    ];

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
                            l10n.dashboardProfitSnapshot,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.totalProfitLabel,
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
                      l10n.totalProfitLabel,
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
                              _formatCurrencyValue(snapshot?.totalProfit ?? 0),
                              key: ValueKey<double>(snapshot?.totalProfit ?? 0),
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
                      for (final metric in heroMetrics)
                        SizedBox(
                          width: tileWidth,
                          child: _HeroMetricTile(
                            label: metric.label,
                            value: metric.value,
                            icon: metric.icon,
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

class _WalletHealthCard extends StatelessWidget {
  const _WalletHealthCard({
    required this.health,
    required this.isExpanded,
    required this.onToggleExpanded,
  }) : isLoading = false;

  const _WalletHealthCard.loading()
    : health = const DashboardWalletHealth(
        totalWallets: 0,
        activeWallets: 0,
        inactiveWallets: 0,
        activeWalletsBalance: 0,
        nearDailyLimitCount: 0,
        nearMonthlyLimitCount: 0,
        limitReachedCount: 0,
        walletsNeedAttentionCount: 0,
        healthStatus: DashboardHealthStatus.unknown,
        attentionItems: <DashboardWalletAttentionItem>[],
      ),
      isExpanded = false,
      onToggleExpanded = null,
      isLoading = true;

  final DashboardWalletHealth health;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final statusTone = _statusToneFor(health.healthStatus);
    final l10n = appL10n(context);

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
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.dashboardWalletHealth,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isLoading)
                const _ChipPlaceholder(width: 88)
              else
                _StatusChip(
                  label: _healthStatusLabel(context, health.healthStatus),
                  foregroundColor: statusTone.foregroundColor,
                  backgroundColor: statusTone.backgroundColor,
                  borderColor: statusTone.foregroundColor.withValues(
                    alpha: 0.12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _WalletSummaryTile(
            isLoading: isLoading,
            label: l10n.activeWallets,
            value: isLoading
                ? null
                : '${_formatCountValue(health.activeWallets)} / ${_formatCountValue(health.totalWallets)}',
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
                      label: l10n.dashboardActiveBalance,
                      value: isLoading
                          ? null
                          : _formatCurrencyValue(health.activeWalletsBalance),
                      icon: Icons.payments_rounded,
                      tone: _MetricTone.neutral,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _WalletMetricTile(
                      label: l10n.dashboardNearDailyLimit,
                      value: isLoading
                          ? null
                          : _formatCountValue(health.nearDailyLimitCount),
                      icon: Icons.today_outlined,
                      tone: _MetricTone.warning,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _WalletMetricTile(
                      label: l10n.dashboardNearMonthlyLimit,
                      value: isLoading
                          ? null
                          : _formatCountValue(health.nearMonthlyLimitCount),
                      icon: Icons.calendar_month_outlined,
                      tone: _MetricTone.warning,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _WalletMetricTile(
                      label: l10n.dashboardLimitReached,
                      value: isLoading
                          ? null
                          : _formatCountValue(health.limitReachedCount),
                      icon: Icons.report_gmailerrorred_outlined,
                      tone: health.limitReachedCount > 0
                          ? _MetricTone.danger
                          : _MetricTone.neutral,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (isLoading)
            const _AttentionRowPlaceholder()
          else if (health.walletsNeedAttentionCount > 0) ...[
            Material(
              color: statusTone.backgroundColor.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(AppRadii.lg),
              child: InkWell(
                onTap: onToggleExpanded,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(
                      color: statusTone.foregroundColor.withValues(alpha: 0.08),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      _SoftIconBox(
                        size: 36,
                        backgroundColor: statusTone.foregroundColor.withValues(
                          alpha: 0.10,
                        ),
                        iconColor: statusTone.foregroundColor,
                        icon: Icons.insights_outlined,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.dashboardReviewWalletsNeedingAttention(
                            health.walletsNeedAttentionCount,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: statusTone.foregroundColor.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Column(
                        children: [
                          for (
                            var index = 0;
                            index < health.attentionItems.length;
                            index++
                          ) ...[
                            _AttentionItemCard(
                              item: health.attentionItems[index],
                            ),
                            if (index != health.attentionItems.length - 1)
                              const SizedBox(height: AppSpacing.sm),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ] else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.successSoft.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  _SoftIconBox(
                    size: 36,
                    backgroundColor: AppColors.success.withValues(alpha: 0.12),
                    iconColor: AppColors.success,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.dashboardAllWalletsHealthy,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
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
            const _ValuePlaceholder(width: 76, height: 14)
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
                    letterSpacing: -0.1,
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
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                letterSpacing: 0.05,
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
    final iconBackground = switch (tone) {
      _MetricTone.neutral => resolvedTone.background,
      _MetricTone.warning => resolvedTone.background.withValues(alpha: 0.74),
      _MetricTone.danger => resolvedTone.background.withValues(alpha: 0.68),
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.018),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIconBox(
            size: 32,
            backgroundColor: iconBackground,
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

class _AttentionItemCard extends StatelessWidget {
  const _AttentionItemCard({required this.item});

  final DashboardWalletAttentionItem item;

  @override
  Widget build(BuildContext context) {
    final severityTone = _attentionToneFor(item.severity);
    final branchName = item.branchName;
    final subtitle = branchName == null || branchName.isEmpty
        ? item.walletName
        : '${item.walletName} • $branchName';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: severityTone.backgroundColor.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: severityTone.borderColor.withValues(alpha: 0.75),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIconBox(
            size: 38,
            backgroundColor: severityTone.foregroundColor.withValues(
              alpha: 0.12,
            ),
            iconColor: severityTone.foregroundColor,
            icon: item.severity == DashboardAttentionSeverity.critical
                ? Icons.priority_high_rounded
                : Icons.warning_amber_rounded,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatusChip(
                      label: _attentionSeverityLabel(context, item.severity),
                      foregroundColor: severityTone.foregroundColor,
                      backgroundColor: severityTone.foregroundColor.withValues(
                        alpha: 0.10,
                      ),
                      borderColor: severityTone.foregroundColor.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _attentionMessage(context, item),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _formatPercentValue(item.currentPercent),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: severityTone.foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.borderColor,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
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
          _ChipPlaceholder(width: 36, height: 36),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: _ValuePlaceholder(width: double.infinity)),
        ],
      ),
    );
  }
}

class _ChipPlaceholder extends StatelessWidget {
  const _ChipPlaceholder({required this.width, this.height = 28});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _ValuePlaceholder(width: width, height: height);
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

class _HeroMetricData {
  const _HeroMetricData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String? value;
  final IconData icon;
}

class _StatusTone {
  const _StatusTone({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
}

enum _MetricTone { neutral, warning, danger }

class _ToneColors {
  const _ToneColors({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

_StatusTone _statusToneFor(DashboardHealthStatus status) {
  return switch (status) {
    DashboardHealthStatus.good => const _StatusTone(
      foregroundColor: AppColors.success,
      backgroundColor: AppColors.successSoft,
      borderColor: AppColors.border,
    ),
    DashboardHealthStatus.warning => const _StatusTone(
      foregroundColor: AppColors.warning,
      backgroundColor: AppColors.warningSoft,
      borderColor: Color(0xFFF0D48A),
    ),
    DashboardHealthStatus.critical => const _StatusTone(
      foregroundColor: AppColors.danger,
      backgroundColor: Color(0xFFFDF2F2),
      borderColor: Color(0xFFF8DEDB),
    ),
    DashboardHealthStatus.unknown => const _StatusTone(
      foregroundColor: AppColors.textSecondary,
      backgroundColor: AppColors.surfaceVariant,
      borderColor: AppColors.border,
    ),
  };
}

_StatusTone _attentionToneFor(DashboardAttentionSeverity severity) {
  return switch (severity) {
    DashboardAttentionSeverity.critical => const _StatusTone(
      foregroundColor: AppColors.danger,
      backgroundColor: Color(0xFFFDF2F2),
      borderColor: Color(0xFFF8DEDB),
    ),
    DashboardAttentionSeverity.warning => const _StatusTone(
      foregroundColor: AppColors.warning,
      backgroundColor: AppColors.warningSoft,
      borderColor: Color(0xFFF0D48A),
    ),
    DashboardAttentionSeverity.info => const _StatusTone(
      foregroundColor: AppColors.primary,
      backgroundColor: AppColors.primarySoft,
      borderColor: AppColors.border,
    ),
    DashboardAttentionSeverity.unknown => const _StatusTone(
      foregroundColor: AppColors.textSecondary,
      backgroundColor: AppColors.surfaceVariant,
      borderColor: AppColors.border,
    ),
  };
}

_ToneColors _metricToneColors(_MetricTone tone) {
  return switch (tone) {
    _MetricTone.warning => const _ToneColors(
      foreground: AppColors.warning,
      background: AppColors.warningSoft,
    ),
    _MetricTone.danger => const _ToneColors(
      foreground: AppColors.danger,
      background: AppColors.dangerSoft,
    ),
    _MetricTone.neutral => const _ToneColors(
      foreground: AppColors.primary,
      background: AppColors.primarySoft,
    ),
  };
}

String _healthStatusLabel(BuildContext context, DashboardHealthStatus status) {
  final l10n = appL10n(context);
  return switch (status) {
    DashboardHealthStatus.good => l10n.dashboardHealthStatusGood,
    DashboardHealthStatus.warning => l10n.dashboardHealthStatusWarning,
    DashboardHealthStatus.critical => l10n.dashboardHealthStatusCritical,
    DashboardHealthStatus.unknown => l10n.status,
  };
}

String _attentionSeverityLabel(
  BuildContext context,
  DashboardAttentionSeverity severity,
) {
  final l10n = appL10n(context);
  return switch (severity) {
    DashboardAttentionSeverity.critical => l10n.dashboardSeverityCritical,
    DashboardAttentionSeverity.warning => l10n.dashboardSeverityWarning,
    DashboardAttentionSeverity.info => l10n.dashboardSeverityInfo,
    DashboardAttentionSeverity.unknown => l10n.status,
  };
}

String _attentionMessage(
  BuildContext context,
  DashboardWalletAttentionItem item,
) {
  final l10n = appL10n(context);
  final normalizedType = item.type.trim().toUpperCase();
  final normalizedMessage = item.message.trim().toLowerCase();

  if (normalizedType.contains('DAILY') &&
      (normalizedType.contains('EXCEEDED') ||
          normalizedType.contains('REACHED'))) {
    return l10n.dashboardDailyLimitReached;
  }
  if (normalizedType.contains('DAILY') && normalizedType.contains('NEAR')) {
    return l10n.dashboardNearDailyLimit;
  }
  if (normalizedType.contains('MONTHLY') &&
      (normalizedType.contains('EXCEEDED') ||
          normalizedType.contains('REACHED'))) {
    return l10n.dashboardMonthlyLimitReached;
  }
  if (normalizedType.contains('MONTHLY') && normalizedType.contains('NEAR')) {
    return l10n.dashboardNearMonthlyLimit;
  }

  if (normalizedMessage == 'daily limit reached') {
    return l10n.dashboardDailyLimitReached;
  }
  if (normalizedMessage == 'near daily limit') {
    return l10n.dashboardNearDailyLimit;
  }
  if (normalizedMessage == 'monthly limit reached') {
    return l10n.dashboardMonthlyLimitReached;
  }
  if (normalizedMessage == 'near monthly limit') {
    return l10n.dashboardNearMonthlyLimit;
  }

  return item.message;
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
