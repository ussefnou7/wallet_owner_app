import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BranchActionsColumn(
            isActive: isActive,
            activeLabel: l10n.active,
            inactiveLabel: l10n.inactive,
            editLabel: l10n.edit,
            editTooltip: l10n.editBranch,
            deleteLabel: l10n.delete,
            deleteTooltip: l10n.deleteBranch,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _BranchDetailsColumn(branch: branch)),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchDetailsColumn extends StatelessWidget {
  const _BranchDetailsColumn({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          branch.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.15,
          ),
        ),
        if (branch.code.trim().isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            branch.code,
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
        _BranchInfoLine(
          icon: Icons.people_alt_outlined,
          label: l10n.usersCount(branch.usersCount),
        ),
        const SizedBox(height: 6),
        _BranchInfoLine(
          icon: Icons.account_balance_wallet_outlined,
          label: l10n.walletsCount(branch.walletsCount),
        ),
      ],
    );
  }
}

class _BranchActionsColumn extends StatelessWidget {
  const _BranchActionsColumn({
    required this.isActive,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.editLabel,
    required this.editTooltip,
    required this.deleteLabel,
    required this.deleteTooltip,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;
  final String editLabel;
  final String editTooltip;
  final String deleteLabel;
  final String deleteTooltip;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _BranchStatus(
          isActive: isActive,
          label: isActive ? activeLabel : inactiveLabel,
        ),
        const SizedBox(height: 12),
        Wrap(
          direction: Axis.vertical,
          spacing: 8,
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
          ],
        ),
      ],
    );
  }
}

class _BranchStatus extends StatelessWidget {
  const _BranchStatus({required this.isActive, required this.label});

  final bool isActive;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.textMuted;
    final icon = isActive
        ? Icons.check_circle_rounded
        : Icons.pause_circle_rounded;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
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
  final VoidCallback onPressed;

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

class _BranchInfoLine extends StatelessWidget {
  const _BranchInfoLine({required this.icon, required this.label});

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
        Icon(icon, size: 16, color: AppColors.textMuted),
      ],
    );
  }
}
