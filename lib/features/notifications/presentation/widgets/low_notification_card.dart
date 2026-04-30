import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_notification.dart';
import 'notifications_localizer.dart';

class LowNotificationCard extends StatelessWidget {
  const LowNotificationCard({
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
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: enabled ? onTap : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 14,
                  color: AppColors.textMuted,
                ),
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(notification),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.2,
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

  String _subtitle(AppNotification notification) {
    if (notification.type != NotificationType.transactionCreated) {
      return resolveNotificationMessage(l10n, notification);
    }

    final walletName =
        notification.payload['walletName']?.toString().trim().isNotEmpty == true
        ? notification.payload['walletName'].toString().trim()
        : l10n.notAvailable;
    final transactionType = _transactionTypeLabel(notification.payload['type']);
    final amount = _amountLabel(notification.payload['amount']);
    final createdBy = _createdBy(notification.payload);
    final parts = [walletName, transactionType, amount, createdBy];

    return parts.whereType<String>().join(' • ');
  }

  String _amountLabel(Object? value) {
    if (value is num) {
      return formatCurrency(value);
    }
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return formatCurrency(parsed);
      }
    }
    return l10n.notAvailable;
  }

  String _transactionTypeLabel(Object? value) {
    final raw = value?.toString().toUpperCase();
    if (raw == 'CREDIT') {
      return l10n.credit;
    }
    if (raw == 'DEBIT') {
      return l10n.debit;
    }
    return l10n.notAvailable;
  }

  String? _createdBy(Map<String, dynamic> payload) {
    final value = payload['createdByUsername']?.toString().trim();
    return value == null || value.isEmpty ? null : value;
  }
}
