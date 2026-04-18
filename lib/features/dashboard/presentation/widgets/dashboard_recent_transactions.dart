import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../transactions/domain/entities/recent_transaction.dart';

class DashboardRecentTransactions extends StatelessWidget {
  const DashboardRecentTransactions({
    required this.items,
    required this.onSeeAll,
    super.key,
  });

  final List<RecentTransaction> items;
  final VoidCallback onSeeAll;

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
          AppSectionHeader(
            title: 'Recent Transactions',
            subtitle: 'Latest recorded activity',
            actionLabel: 'See All',
            onActionPressed: onSeeAll,
          ),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty)
            const AppEmptyState(
              title: 'No transactions yet',
              message: 'Recent transaction activity will appear here.',
              icon: Icons.receipt_long_outlined,
            )
          else
            for (var index = 0; index < items.length; index++) ...[
              _TransactionTile(item: items[index]),
              if (index != items.length - 1) const Divider(),
            ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item});

  final RecentTransaction item;

  @override
  Widget build(BuildContext context) {
    final isCredit = item.type == TransactionType.credit;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isCredit
            ? AppColors.primarySoft
            : AppColors.dangerSoft,
        child: Icon(
          isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: isCredit ? AppColors.success : AppColors.danger,
        ),
      ),
      title: Text(item.walletName),
      subtitle: Text(item.id, style: Theme.of(context).textTheme.bodySmall),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatCurrency(item.amount),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isCredit ? AppColors.success : AppColors.danger,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isCredit ? 'Credit' : 'Debit',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
