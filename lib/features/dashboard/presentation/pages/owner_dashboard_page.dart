import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../providers/dashboard_provider.dart';

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> {
  DashboardPeriod _selectedPeriod = DashboardPeriod.monthly;

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(dashboardSummaryProvider);
    final periodStats = _periodStats[_selectedPeriod]!;
    final l10n = appL10n(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.portfolioOverview,
            subtitle: l10n.portfolioOverviewSubtitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          _BalanceCard(
            totalBalance: periodStats.totalBalance,
            activeWallets: summary.activeWallets,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PeriodSelector(
            selectedPeriod: _selectedPeriod,
            onSelected: (period) {
              setState(() => _selectedPeriod = period);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _AmountSummaryCard(
                  label: l10n.totalCredits,
                  amount: periodStats.totalCredits,
                  icon: Icons.south_west_rounded,
                  toneColor: AppColors.success,
                  background: AppColors.successSoft,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _AmountSummaryCard(
                  label: l10n.totalDebits,
                  amount: periodStats.totalDebits,
                  icon: Icons.north_east_rounded,
                  toneColor: AppColors.danger,
                  background: AppColors.dangerSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum DashboardPeriod { daily, monthly, yearly }

const _periodStats = {
  DashboardPeriod.daily: _PeriodStats(
    totalBalance: 124850,
    totalCredits: 18320,
    totalDebits: 9420,
  ),
  DashboardPeriod.monthly: _PeriodStats(
    totalBalance: 428760,
    totalCredits: 301540,
    totalDebits: 196280,
  ),
  DashboardPeriod.yearly: _PeriodStats(
    totalBalance: 1984320,
    totalCredits: 2387510,
    totalDebits: 1604190,
  ),
};

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.totalBalance, required this.activeWallets});

  final double totalBalance;
  final int activeWallets;

  @override
  Widget build(BuildContext context) {
    final totalBalance = this.totalBalance;
    final activeWallets = this.activeWallets;
    final l10n = appL10n(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalBalance,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            formatCurrency(totalBalance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.activeWalletsCount(activeWallets),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onSelected,
  });

  final DashboardPeriod selectedPeriod;
  final ValueChanged<DashboardPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return Row(
      children: DashboardPeriod.values.map((period) {
        final isSelected = period == selectedPeriod;
        final label = switch (period) {
          DashboardPeriod.daily => l10n.daily,
          DashboardPeriod.monthly => l10n.monthly,
          DashboardPeriod.yearly => l10n.yearly,
        };

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: period == DashboardPeriod.yearly ? 0 : AppSpacing.sm,
            ),
            child: GestureDetector(
              onTap: () => onSelected(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AmountSummaryCard extends StatelessWidget {
  const _AmountSummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.toneColor,
    required this.background,
  });

  final String label;
  final double amount;
  final IconData icon;
  final Color toneColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(icon, color: toneColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatCurrency(amount),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PeriodStats {
  const _PeriodStats({
    required this.totalBalance,
    required this.totalCredits,
    required this.totalDebits,
  });

  final double totalBalance;
  final double totalCredits;
  final double totalDebits;
}
