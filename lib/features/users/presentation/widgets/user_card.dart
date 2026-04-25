import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignBranch,
    required this.onUnassignBranch,
    super.key,
  });

  final AppUser user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAssignBranch;
  final VoidCallback onUnassignBranch;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

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
              _UserAvatar(name: user.username),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user.tenantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (user.branchName != null &&
                        user.branchName!.trim().isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l10n.branchName}: ${user.branchName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppStatusBadge(
                label: user.active ? l10n.active : l10n.inactive,
                foregroundColor: user.active
                    ? AppColors.success
                    : AppColors.textSecondary,
                backgroundColor: user.active
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
              _MetaPill(
                icon: user.role == UserRole.owner
                    ? Icons.verified_user_outlined
                    : Icons.person_outline_rounded,
                label: user.role == UserRole.owner
                    ? l10n.ownerRole
                    : l10n.userRole,
              ),
              _MetaPill(
                icon: Icons.account_tree_outlined,
                label: user.branchName?.trim().isNotEmpty == true
                    ? user.branchName!
                    : l10n.notAvailable,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ActionButton(
                label: l10n.editUser,
                icon: Icons.edit_outlined,
                onPressed: onEdit,
                isPrimary: true,
              ),
              _ActionButton(
                label: l10n.assignBranch,
                icon: Icons.assignment_ind_outlined,
                onPressed: onAssignBranch,
              ),
              _ActionButton(
                label: l10n.unassignBranch,
                icon: Icons.link_off_rounded,
                onPressed: user.branchId == null ? null : onUnassignBranch,
                foregroundColor: AppColors.textSecondary,
              ),
              _ActionButton(
                label: l10n.deleteUser,
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

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

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: AppInitialsAvatar(name: name),
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
  final VoidCallback? onPressed;
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

    return Opacity(
      opacity: onPressed == null ? 0.55 : 1,
      child: Material(
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
      ),
    );
  }
}
