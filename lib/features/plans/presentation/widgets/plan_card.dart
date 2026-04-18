import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/plan.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({required this.plan, this.onPressed, super.key});

  final Plan plan;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final badgeLabel = switch (plan.badge) {
      PlanBadge.current => 'Current',
      PlanBadge.recommended => 'Recommended',
      PlanBadge.available => 'Available',
    };

    final actionLabel = switch (plan.badge) {
      PlanBadge.current => 'Current Plan',
      PlanBadge.recommended => 'Upgrade',
      PlanBadge.available => 'Choose Plan',
    };

    final button = plan.isCurrent
        ? AppSecondaryButton(label: actionLabel, onPressed: null)
        : AppPrimaryButton(label: actionLabel, onPressed: onPressed);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: plan.isCurrent ? AppColors.primarySoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: plan.isCurrent ? AppColors.primary : AppColors.border,
        ),
        boxShadow: AppShadows.card,
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
                      plan.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      plan.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: badgeLabel,
                foregroundColor: _badgeForeground(plan.badge),
                backgroundColor: _badgeBackground(plan.badge),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _PlanLimitBlock(
                  label: 'Max Users',
                  value: plan.maxUsers,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PlanLimitBlock(
                  label: 'Max Wallets',
                  value: plan.maxWallets,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PlanLimitBlock(
                  label: 'Max Branches',
                  value: plan.maxBranches,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(width: double.infinity, child: button),
        ],
      ),
    );
  }

  Color _badgeForeground(PlanBadge badge) => switch (badge) {
    PlanBadge.current => AppColors.primary,
    PlanBadge.recommended => AppColors.success,
    PlanBadge.available => AppColors.textSecondary,
  };

  Color _badgeBackground(PlanBadge badge) => switch (badge) {
    PlanBadge.current => AppColors.primarySoft,
    PlanBadge.recommended => AppColors.successSoft,
    PlanBadge.available => AppColors.surfaceVariant,
  };
}

class _PlanLimitBlock extends StatelessWidget {
  const _PlanLimitBlock({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value.toString(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
