import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';

class TransactionRecordTile extends StatelessWidget {
  const TransactionRecordTile({required this.transaction, super.key});

  final TransactionRecord transaction;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionEntryType.credit;
    final typeLabel = switch (transaction.type) {
      TransactionEntryType.credit => 'Credit',
      TransactionEntryType.debit => 'Debit',
      TransactionEntryType.unknown => 'Unknown',
    };
    final statusColor = transaction.status == TransactionRecordStatus.recorded
        ? AppColors.success
        : AppColors.warning;
    final statusBackground =
        transaction.status == TransactionRecordStatus.recorded
        ? AppColors.successSoft
        : AppColors.warningSoft;

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
              CircleAvatar(
                backgroundColor: isCredit
                    ? AppColors.primarySoft
                    : AppColors.dangerSoft,
                child: Icon(
                  isCredit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isCredit ? AppColors.success : AppColors.danger,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.walletName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${formatDate(transaction.date)} • ${_formatTime(transaction.date)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: transaction.status == TransactionRecordStatus.recorded
                    ? 'Recorded'
                    : 'Pending',
                foregroundColor: statusColor,
                backgroundColor: statusBackground,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                typeLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isCredit ? AppColors.success : AppColors.danger,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                formatCurrency(transaction.amount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isCredit ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
          if (transaction.note != null && transaction.note!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              transaction.note!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Created by ${transaction.createdBy}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
