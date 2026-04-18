import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';

class UserCard extends StatelessWidget {
  const UserCard({required this.user, super.key});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == AppUserStatus.active;

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
              AppInitialsAvatar(name: user.fullName),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: isActive ? 'Active' : 'Inactive',
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
              _MetaPill(label: user.role == UserRole.owner ? 'OWNER' : 'USER'),
              _MetaPill(label: user.branchName ?? 'No branch'),
              _MetaPill(label: '${user.walletCount} wallets'),
            ],
          ),
          if (user.phone != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(user.phone!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

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
