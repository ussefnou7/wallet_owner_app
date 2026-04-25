import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/branch.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({
    required this.branch,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Branch branch;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                child: const Icon(
                  Icons.business_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      branch.code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
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
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _MetaTile(
                icon: Icons.people_alt_outlined,
                label: l10n.usersCount(branch.usersCount),
              ),
              _MetaTile(
                icon: Icons.account_balance_wallet_outlined,
                label: l10n.walletsCount(branch.walletsCount),
              ),
              if (branch.location != null && branch.location!.trim().isNotEmpty)
                _MetaTile(
                  icon: Icons.location_on_outlined,
                  label: branch.location!,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ActionButton(
                label: l10n.editBranch,
                icon: Icons.edit_outlined,
                onPressed: onEdit,
                isPrimary: true,
              ),
              _ActionButton(
                label: l10n.deleteBranch,
                icon: Icons.delete_outline_rounded,
                onPressed: onDelete,
                foregroundColor: AppColors.danger,
                backgroundColor: AppColors.dangerSoft,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({required this.icon, required this.label});

  final IconData icon;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedForeground =
        foregroundColor ??
        (isPrimary ? AppColors.primary : AppColors.textPrimary);
    final resolvedBackground =
        backgroundColor ??
        (isPrimary ? AppColors.primarySoft : AppColors.surfaceVariant);

    return Material(
      color: resolvedBackground,
      borderRadius: BorderRadius.circular(AppRadii.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: resolvedForeground),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: resolvedForeground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
