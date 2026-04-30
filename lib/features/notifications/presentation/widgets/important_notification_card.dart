import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_notification.dart';
import 'notifications_localizer.dart';

class ImportantNotificationCard extends StatelessWidget {
  const ImportantNotificationCard({
    required this.notification,
    required this.l10n,
    required this.onTap,
    this.enabled = true,
    super.key,
  });

  final AppNotification notification;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(notification.severity);

    return Material(
      color: palette.background,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: enabled ? onTap : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: palette.iconBackground,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(palette.icon, color: palette.foreground, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      resolveNotificationTitle(l10n, notification),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      resolveNotificationMessage(l10n, notification),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDateTime(notification.createdAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationPalette {
  const _NotificationPalette({
    required this.background,
    required this.border,
    required this.iconBackground,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color iconBackground;
  final Color foreground;
  final IconData icon;
}

_NotificationPalette _paletteFor(NotificationSeverity severity) {
  return switch (severity) {
    NotificationSeverity.danger => const _NotificationPalette(
      background: Color(0xFFFFF3F1),
      border: Color(0xFFF2C6C0),
      iconBackground: AppColors.dangerSoft,
      foreground: AppColors.danger,
      icon: Icons.priority_high_rounded,
    ),
    NotificationSeverity.warning => const _NotificationPalette(
      background: Color(0xFFFFF9EC),
      border: Color(0xFFF4D48D),
      iconBackground: AppColors.warningSoft,
      foreground: AppColors.warning,
      icon: Icons.warning_amber_rounded,
    ),
    NotificationSeverity.info => const _NotificationPalette(
      background: Color(0xFFF4F8FF),
      border: Color(0xFFC9D9F6),
      iconBackground: AppColors.primarySoft,
      foreground: AppColors.primary,
      icon: Icons.notifications_active_outlined,
    ),
  };
}
