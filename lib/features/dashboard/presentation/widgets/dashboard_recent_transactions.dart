import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../transactions/domain/entities/recent_transaction.dart';
import '../../../transactions/presentation/widgets/compact_transaction_list_item.dart';

class DashboardRecentTransactions extends StatelessWidget {
  const DashboardRecentTransactions({
    required this.items,
    this.onSeeAll,
    super.key,
  });

  final List<RecentTransaction> items;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

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
            title: l10n.latestTransactions,
            subtitle: l10n.latestTransactionsSubtitle,
            actionLabel: onSeeAll == null ? null : l10n.viewAll,
            onActionPressed: onSeeAll,
          ),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty)
            AppEmptyState(
              title: l10n.noTransactionsAvailable,
              message: l10n.transactionsEmptyMessage,
              icon: Icons.receipt_long_outlined,
            )
          else
            for (var index = 0; index < items.length; index++) ...[
              _TransactionTile(item: items[index]),
              if (index != items.length - 1)
                const Divider(height: AppSpacing.lg, thickness: 0.6),
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
    final l10n = appL10n(context);
    final isCredit = item.type == TransactionType.credit;
    final typeLabel = isCredit ? l10n.credit : l10n.debit;
    return CompactTransactionListItem(
      walletName: item.walletName,
      amount: item.amount,
      isCredit: isCredit,
      typeLabel: typeLabel,
      recordedAt: item.recordedAt,
    );
  }
}
