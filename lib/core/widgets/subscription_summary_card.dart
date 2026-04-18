import 'package:flutter/material.dart';

import '../../features/plans/domain/entities/subscription_summary.dart';
import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';
import '../utils/formatters.dart';
import 'app_status_badge.dart';

class SubscriptionSummaryCard extends StatelessWidget {
  const SubscriptionSummaryCard({
    required this.summary,
    this.title = 'Current Subscription',
    this.subtitle,
    super.key,
  });

  final SubscriptionSummary summary;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              AppStatusBadge(
                label: summary.statusLabel,
                foregroundColor: _foregroundColor(summary.status),
                backgroundColor: _backgroundColor(summary.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            summary.planName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Renews on ${formatDate(summary.renewalDate)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _UsageChip(
                label: 'Users',
                value: '${summary.activeUsers}/${summary.maxUsers}',
              ),
              _UsageChip(
                label: 'Wallets',
                value: '${summary.activeWallets}/${summary.maxWallets}',
              ),
              _UsageChip(
                label: 'Branches',
                value: '${summary.activeBranches}/${summary.maxBranches}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _foregroundColor(SubscriptionStatus status) => switch (status) {
    SubscriptionStatus.active => AppColors.success,
    SubscriptionStatus.expiringSoon => AppColors.warning,
    SubscriptionStatus.expired => AppColors.danger,
  };

  Color _backgroundColor(SubscriptionStatus status) => switch (status) {
    SubscriptionStatus.active => AppColors.successSoft,
    SubscriptionStatus.expiringSoon => AppColors.warningSoft,
    SubscriptionStatus.expired => AppColors.dangerSoft,
  };
}

class _UsageChip extends StatelessWidget {
  const _UsageChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
