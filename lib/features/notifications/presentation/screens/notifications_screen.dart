import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/app_notification.dart';
import '../providers/notifications_provider.dart';
import '../widgets/empty_notifications_view.dart';
import '../widgets/important_notification_card.dart';
import '../widgets/low_notification_card.dart';
import '../widgets/notification_section_header.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key, this.presentedAsSheet = false});

  const NotificationsScreen.sheet({super.key}) : presentedAsSheet = true;

  final bool presentedAsSheet;

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(notificationsProvider.notifier).loadUnreadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);
    final l10n = appL10n(context);
    final content = _NotificationsPanel(
      state: state,
      l10n: l10n,
      presentedAsSheet: widget.presentedAsSheet,
      onReadAll: state.isActionLoading ? null : () => _markAllAsRead(context),
      onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
      body: _buildBody(context, state, l10n),
    );

    if (widget.presentedAsSheet) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsState state,
    AppLocalizations l10n,
  ) {
    if (state.isLoading && !state.hasNotifications) {
      return ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 180),
          AppLoadingView(message: l10n.loading),
        ],
      );
    }

    if (state.errorMessage != null && !state.hasNotifications) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          AppErrorState(
            message: state.errorMessage ?? l10n.notificationsUnableToLoad,
            onRetry: () => ref
                .read(notificationsProvider.notifier)
                .loadUnreadNotifications(),
          ),
        ],
      );
    }

    if (!state.hasNotifications) {
      return ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
          EmptyNotificationsView(
            title: l10n.notificationsEmptyTitle,
            message: l10n.notificationsEmptyMessage,
          ),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (state.errorMessage != null) ...[
          AppErrorState(
            message: state.errorMessage ?? l10n.notificationsUnableToUpdate,
            compact: true,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.important.isNotEmpty) ...[
          NotificationSectionHeader(title: l10n.notificationsImportantSection),
          const SizedBox(height: AppSpacing.sm),
          ...state.important.map(
            (notification) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ImportantNotificationCard(
                notification: notification,
                l10n: l10n,
                enabled: !state.isActionLoading,
                onTap: () => _openNotification(context, notification),
              ),
            ),
          ),
        ],
        if (state.low.isNotEmpty) ...[
          if (state.important.isNotEmpty) const SizedBox(height: AppSpacing.sm),
          NotificationSectionHeader(
            title: l10n.notificationsLowPrioritySection,
            actionLabel: l10n.notificationsReadAllLow,
            enabled: !state.isActionLoading,
            onActionPressed: () => _markLowAsRead(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...state.low.map(
            (notification) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: LowNotificationCard(
                notification: notification,
                l10n: l10n,
                enabled: !state.isActionLoading,
                onTap: () => _openNotification(context, notification),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openNotification(
    BuildContext context,
    AppNotification notification,
  ) async {
    final l10n = appL10n(context);
    final success = await ref
        .read(notificationsProvider.notifier)
        .markOneAsRead(notification);
    if (!context.mounted) {
      return;
    }
    if (!success) {
      _showError(
        context,
        ref.read(notificationsProvider).errorMessage ??
            l10n.notificationsUnableToUpdate,
      );
      return;
    }

    if (widget.presentedAsSheet) {
      Navigator.of(context).pop(notification);
      return;
    }

    navigateFromNotification(context, notification);
  }

  Future<void> _markLowAsRead(BuildContext context) async {
    final l10n = appL10n(context);
    final success = await ref
        .read(notificationsProvider.notifier)
        .markLowAsRead();
    if (!context.mounted || success) {
      return;
    }
    _showError(
      context,
      ref.read(notificationsProvider).errorMessage ??
          l10n.notificationsUnableToUpdate,
    );
  }

  Future<void> _markAllAsRead(BuildContext context) async {
    final l10n = appL10n(context);
    final success = await ref
        .read(notificationsProvider.notifier)
        .markAllAsRead();
    if (!context.mounted || success) {
      return;
    }
    _showError(
      context,
      ref.read(notificationsProvider).errorMessage ??
          l10n.notificationsUnableToUpdate,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

void navigateFromNotification(
  BuildContext context,
  AppNotification notification,
) {
  switch (notification.targetType?.toUpperCase()) {
    case 'WALLET':
      // TODO(backend-routes): navigate to wallet details when the route exists.
      context.go(AppRoutes.ownerWallets);
      return;
    case 'TRANSACTION':
      // TODO(backend-routes): navigate to transaction details when the route exists.
      context.go(AppRoutes.ownerTransactions);
      return;
    default:
      if (notification.type == NotificationType.transactionCreated) {
        context.go(AppRoutes.ownerTransactions);
        return;
      }
      context.go(AppRoutes.ownerWallets);
  }
}

class _NotificationsPanel extends StatelessWidget {
  const _NotificationsPanel({
    required this.state,
    required this.l10n,
    required this.presentedAsSheet,
    required this.body,
    required this.onRefresh,
    this.onReadAll,
  });

  final NotificationsState state;
  final AppLocalizations l10n;
  final bool presentedAsSheet;
  final Widget body;
  final RefreshCallback onRefresh;
  final VoidCallback? onReadAll;

  @override
  Widget build(BuildContext context) {
    final panel = Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.borderStrong,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.notificationsTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (state.hasNotifications)
                  TextButton(
                    onPressed: onReadAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(l10n.notificationsReadAll),
                  ),
                if (presentedAsSheet)
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: body,
              ),
            ),
          ),
        ],
      ),
    );

    if (presentedAsSheet) {
      return SafeArea(top: false, child: panel);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.xl),
      child: panel,
    );
  }
}
