import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../domain/entities/app_notification.dart';
import '../providers/notifications_provider.dart';
import '../screens/notifications_screen.dart';

class NotificationBadgeIcon extends ConsumerStatefulWidget {
  const NotificationBadgeIcon({super.key});

  @override
  ConsumerState<NotificationBadgeIcon> createState() =>
      _NotificationBadgeIconState();
}

class _NotificationBadgeIconState extends ConsumerState<NotificationBadgeIcon> {
  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(
      notificationsProvider.select((state) => state.unreadCount),
    );
    final l10n = appL10n(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: () async {
          final selectedNotification = await showModalBottomSheet<AppNotification>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.black.withValues(alpha: 0.36),
            builder: (context) => const NotificationsScreen.sheet(),
          );
          if (!mounted) {
            return;
          }
          await ref.read(notificationsProvider.notifier).loadUnreadCount();
          if (!context.mounted || selectedNotification == null) {
            return;
          }
          navigateFromNotification(context, selectedNotification);
        },
        child: Tooltip(
          message: l10n.notificationsTitle,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 7,
                    right: 4,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
