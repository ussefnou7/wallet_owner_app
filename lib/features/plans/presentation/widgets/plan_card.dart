import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../domain/entities/plan.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({required this.plan, this.onPressed, super.key});

  final Plan plan;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
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
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.planPrice(plan.price),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _PlanLimitBlock(
                  label: l10n.maxUsers,
                  value: plan.maxUsers,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PlanLimitBlock(
                  label: l10n.maxWallets,
                  value: plan.maxWallets,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PlanLimitBlock(
                  label: l10n.maxBranches,
                  value: plan.maxBranches,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
