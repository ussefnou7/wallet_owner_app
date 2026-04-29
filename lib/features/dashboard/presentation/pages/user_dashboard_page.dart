import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../../transactions/domain/entities/transaction_record.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../../../transactions/presentation/widgets/transaction_record_tile.dart';

class UserDashboardPage extends ConsumerStatefulWidget {
  const UserDashboardPage({super.key});

  @override
  ConsumerState<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends ConsumerState<UserDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.invalidate(transactionsControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsControllerProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: bottomInset + AppDimensions.floatingBottomNavContentPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Today',
            subtitle: 'Your transaction activity and quick actions.',
          ),
          const SizedBox(height: AppSpacing.lg),
          transactionsState.when(
            loading: () =>
                const AppLoadingView(message: 'Loading today activity...'),
            error: (error, stackTrace) => AppErrorState(
              message: 'Unable to load activity right now.',
              compact: true,
              onRetry: () =>
                  ref.read(transactionsControllerProvider.notifier).reload(),
            ),
            data: (transactions) {
              final todayTransactions = _todayTransactions(transactions);
              return Column(
                children: [
                  _UserSummaryCards(
                    creditAmount: _totalFor(
                      todayTransactions,
                      TransactionEntryType.credit,
                    ),
                    debitAmount: _totalFor(
                      todayTransactions,
                      TransactionEntryType.debit,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _QuickActionCard(
                    onTap: () => context.go(AppRoutes.userCreateTransaction),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _RecentTransactionsSection(transactions: transactions),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<TransactionRecord> _todayTransactions(
    List<TransactionRecord> transactions,
  ) {
    final now = DateTime.now();
    return transactions.where((transaction) {
      final date = transaction.date;
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }

  double _totalFor(
    List<TransactionRecord> transactions,
    TransactionEntryType type,
  ) {
    return transactions
        .where((transaction) => transaction.type == type)
        .fold<double>(0, (total, transaction) => total + transaction.amount);
  }
}

class _UserSummaryCards extends StatelessWidget {
  const _UserSummaryCards({
    required this.creditAmount,
    required this.debitAmount,
  });

  final double creditAmount;
  final double debitAmount;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldStack = constraints.maxWidth < 360 || textScale > 1.15;

        if (shouldStack) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: 3.1,
                child: _SummaryCard(
                  label: 'Credits',
                  amount: creditAmount,
                  icon: Icons.south_west_rounded,
                  toneColor: AppColors.success,
                  background: AppColors.successSoft,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AspectRatio(
                aspectRatio: 3.1,
                child: _SummaryCard(
                  label: 'Debits',
                  amount: debitAmount,
                  icon: Icons.north_east_rounded,
                  toneColor: AppColors.danger,
                  background: AppColors.dangerSoft,
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.28,
                child: _SummaryCard(
                  label: 'Credits',
                  amount: creditAmount,
                  icon: Icons.south_west_rounded,
                  toneColor: AppColors.success,
                  background: AppColors.successSoft,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.28,
                child: _SummaryCard(
                  label: 'Debits',
                  amount: debitAmount,
                  icon: Icons.north_east_rounded,
                  toneColor: AppColors.danger,
                  background: AppColors.dangerSoft,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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
          Row(
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
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                formatCurrency(amount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: toneColor,
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

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Create transaction',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection({required this.transactions});

  final List<TransactionRecord> transactions;

  @override
  Widget build(BuildContext context) {
    final recent = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    final visible = recent.take(3).toList();

    if (visible.isEmpty) {
      return const AppEmptyState(
        title: 'No recent transactions',
        message: 'Your recent activity will appear here.',
        icon: Icons.receipt_long_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        for (final transaction in visible) ...[
          TransactionRecordTile(transaction: transaction),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
