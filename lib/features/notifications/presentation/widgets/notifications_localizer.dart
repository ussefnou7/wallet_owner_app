import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_notification.dart';

String resolveNotificationTitle(
  AppLocalizations l10n,
  AppNotification notification,
) {
  return switch (notification.titleKey) {
    'notificationsWalletDailyLimitNearTitle' =>
      l10n.notificationsWalletDailyLimitNearTitle,
    'notificationsWalletDailyLimitExceededTitle' =>
      l10n.notificationsWalletDailyLimitExceededTitle,
    'notificationsWalletMonthlyLimitNearTitle' =>
      l10n.notificationsWalletMonthlyLimitNearTitle,
    'notificationsWalletMonthlyLimitExceededTitle' =>
      l10n.notificationsWalletMonthlyLimitExceededTitle,
    'notificationsTransactionCreatedTitle' =>
      l10n.notificationsTransactionCreatedTitle,
    _ => _fallbackTitle(l10n, notification),
  };
}

String resolveNotificationMessage(
  AppLocalizations l10n,
  AppNotification notification,
) {
  return switch (notification.messageKey) {
    'notificationsWalletDailyLimitNearMessage' =>
      l10n.notificationsWalletDailyLimitNearMessage,
    'notificationsWalletDailyLimitExceededMessage' =>
      l10n.notificationsWalletDailyLimitExceededMessage,
    'notificationsWalletMonthlyLimitNearMessage' =>
      l10n.notificationsWalletMonthlyLimitNearMessage,
    'notificationsWalletMonthlyLimitExceededMessage' =>
      l10n.notificationsWalletMonthlyLimitExceededMessage,
    'notificationsTransactionCreatedMessage' =>
      l10n.notificationsTransactionCreatedMessage,
    _ => _fallbackMessage(l10n, notification),
  };
}

String _fallbackTitle(AppLocalizations l10n, AppNotification notification) {
  final byType = switch (notification.type) {
    NotificationType.walletDailyLimitNear =>
      l10n.notificationsWalletDailyLimitNearTitle,
    NotificationType.walletDailyLimitExceeded =>
      l10n.notificationsWalletDailyLimitExceededTitle,
    NotificationType.walletMonthlyLimitNear =>
      l10n.notificationsWalletMonthlyLimitNearTitle,
    NotificationType.walletMonthlyLimitExceeded =>
      l10n.notificationsWalletMonthlyLimitExceededTitle,
    NotificationType.transactionCreated =>
      l10n.notificationsTransactionCreatedTitle,
    NotificationType.unknown => null,
  };

  if (byType != null && byType.isNotEmpty) {
    return byType;
  }

  return notification.titleKey.isNotEmpty
      ? notification.titleKey
      : l10n.notifications;
}

String _fallbackMessage(AppLocalizations l10n, AppNotification notification) {
  final byType = switch (notification.type) {
    NotificationType.walletDailyLimitNear =>
      l10n.notificationsWalletDailyLimitNearMessage,
    NotificationType.walletDailyLimitExceeded =>
      l10n.notificationsWalletDailyLimitExceededMessage,
    NotificationType.walletMonthlyLimitNear =>
      l10n.notificationsWalletMonthlyLimitNearMessage,
    NotificationType.walletMonthlyLimitExceeded =>
      l10n.notificationsWalletMonthlyLimitExceededMessage,
    NotificationType.transactionCreated =>
      l10n.notificationsTransactionCreatedMessage,
    NotificationType.unknown => null,
  };

  if (byType != null && byType.isNotEmpty) {
    return byType;
  }

  return notification.messageKey.isNotEmpty
      ? notification.messageKey
      : l10n.notifications;
}
