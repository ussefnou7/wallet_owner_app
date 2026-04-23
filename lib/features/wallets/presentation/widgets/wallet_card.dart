import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/wallet.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    required this.wallet,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final Wallet wallet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = wallet.status == WalletStatus.active;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      wallet.branchName ?? 'No branch assigned',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.successSoft
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Inactive',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isActive
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (onEdit != null || onDelete != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    PopupMenuButton<_WalletAction>(
                      tooltip: 'Wallet actions',
                      onSelected: (action) {
                        switch (action) {
                          case _WalletAction.edit:
                            onEdit?.call();
                            break;
                          case _WalletAction.delete:
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: _WalletAction.edit,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Edit'),
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: _WalletAction.delete,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.danger,
                              ),
                              title: Text('Delete'),
                            ),
                          ),
                      ],
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Current Balance', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatCurrency(wallet.balance),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              _MetaChip(label: 'Code', value: wallet.code),
              _MetaChip(
                label: 'Transactions',
                value: wallet.transactionCount.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _WalletAction { edit, delete }

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
