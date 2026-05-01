import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_status_indicator.dart';
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
    final branchName = user.branchName?.trim() ?? '';
    final hasAssignedBranch = branchName.isNotEmpty;
    final subtitle = user.tenantName;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UserActionsColumn(
            isActive: user.active,
            activeLabel: l10n.active,
            inactiveLabel: l10n.inactive,
            editLabel: l10n.edit,
            editTooltip: l10n.editUser,
            deleteLabel: l10n.delete,
            deleteTooltip: l10n.deleteUser,
            assignLabel: l10n.assignBranch,
            assignTooltip: l10n.assignBranch,
            unassignLabel: l10n.unassignBranch,
            unassignTooltip: l10n.unassignBranch,
            canUnassign: user.branchId != null,
            onEdit: onEdit,
            onDelete: onDelete,
            onAssignBranch: onAssignBranch,
            onUnassignBranch: user.branchId == null ? null : onUnassignBranch,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _UserDetailsColumn(
              username: user.username,
              subtitle: subtitle,
              roleLabel: user.role == UserRole.owner
                  ? l10n.ownerRole
                  : l10n.userRole,
              branchLabel: hasAssignedBranch
                  ? '${l10n.branchName}: $branchName'
                  : l10n.notAvailable,
              hasAssignedBranch: hasAssignedBranch,
            ),
          ),
          const SizedBox(width: 12),
          _UserAvatar(name: user.username),
        ],
      ),
    );
  }
}

class _UserDetailsColumn extends StatelessWidget {
  const _UserDetailsColumn({
    required this.username,
    required this.subtitle,
    required this.roleLabel,
    required this.branchLabel,
    required this.hasAssignedBranch,
  });

  final String username;
  final String subtitle;
  final String roleLabel;
  final String branchLabel;
  final bool hasAssignedBranch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        if (subtitle.trim().isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
        const SizedBox(height: 10),
        _UserInfoLine(icon: Icons.verified_user_outlined, label: roleLabel),
        const SizedBox(height: 6),
        _UserInfoLine(
          icon: hasAssignedBranch
              ? Icons.account_tree_outlined
              : Icons.link_off_rounded,
          label: branchLabel,
        ),
      ],
    );
  }
}

class _UserActionsColumn extends StatelessWidget {
  const _UserActionsColumn({
    required this.isActive,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.editLabel,
    required this.editTooltip,
    required this.deleteLabel,
    required this.deleteTooltip,
    required this.assignLabel,
    required this.assignTooltip,
    required this.unassignLabel,
    required this.unassignTooltip,
    required this.canUnassign,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignBranch,
    required this.onUnassignBranch,
  });

  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;
  final String editLabel;
  final String editTooltip;
  final String deleteLabel;
  final String deleteTooltip;
  final String assignLabel;
  final String assignTooltip;
  final String unassignLabel;
  final String unassignTooltip;
  final bool canUnassign;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAssignBranch;
  final VoidCallback? onUnassignBranch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppStatusIndicator(
          label: isActive ? activeLabel : inactiveLabel,
          isActive: isActive,
          inactiveColor: AppColors.textMuted,
          iconSize: 16,
        ),
        const SizedBox(height: 12),
        Wrap(
          direction: Axis.vertical,
          spacing: 8,
          runSpacing: 8,
          children: [
            _CompactActionButton(
              label: editLabel,
              tooltip: editTooltip,
              icon: Icons.edit_outlined,
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primarySoft,
              onPressed: onEdit,
            ),
            _CompactActionButton(
              label: deleteLabel,
              tooltip: deleteTooltip,
              icon: Icons.delete_outline_rounded,
              foregroundColor: AppColors.danger,
              backgroundColor: AppColors.dangerSoft,
              onPressed: onDelete,
            ),
            _CompactActionButton(
              label: assignLabel,
              tooltip: assignTooltip,
              icon: Icons.assignment_ind_outlined,
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primarySoft,
              onPressed: onAssignBranch,
            ),
            _CompactActionButton(
              label: unassignLabel,
              tooltip: unassignTooltip,
              icon: Icons.link_off_rounded,
              foregroundColor: canUnassign
                  ? AppColors.textSecondary
                  : AppColors.textMuted,
              backgroundColor: canUnassign
                  ? AppColors.surfaceVariant
                  : AppColors.surfaceVariant.withValues(alpha: 0.75),
              onPressed: onUnassignBranch,
            ),
          ],
        ),
      ],
    );
  }
}

class _UserInfoLine extends StatelessWidget {
  const _UserInfoLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Icon(icon, size: 17, color: AppColors.textMuted),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFor(name);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static String _initialsFor(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'U';
    }
    if (parts.length == 1) {
      final name = parts.first;
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _CompactActionButton extends StatelessWidget {
  const _CompactActionButton({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        height: 32,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 14, color: foregroundColor),
          label: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
