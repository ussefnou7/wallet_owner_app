import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/branch.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({required this.branch, super.key});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final isActive = branch.status == BranchStatus.active;

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
                      branch.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      branch.code,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: isActive ? l10n.active : l10n.inactive,
                foregroundColor: isActive
                    ? AppColors.success
                    : AppColors.textSecondary,
                backgroundColor: isActive
                    ? AppColors.successSoft
                    : AppColors.surfaceVariant,
              ),
            ],
          ),
          if (branch.location != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              branch.location!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _MetaTile(label: l10n.usersCount(branch.usersCount)),
              _MetaTile(label: l10n.walletsCount(branch.walletsCount)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({required this.label});

  final String label;

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
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
