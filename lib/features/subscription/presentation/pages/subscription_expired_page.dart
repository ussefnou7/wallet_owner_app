import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/formatters/app_date_formatter.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/subscription_expired_controller.dart';

class SubscriptionExpiredPage extends ConsumerWidget {
  const SubscriptionExpiredPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    final state = ref.watch(subscriptionExpiredControllerProvider);
    final controller = ref.read(subscriptionExpiredControllerProvider.notifier);
    final l10n = appL10n(context);
    final theme = Theme.of(context);

    if (session == null) {
      return const SizedBox.shrink();
    }

    final locale = Localizations.localeOf(context).languageCode;
    final expireDate = session.subscriptionExpireDate;
    final title = session.isOwner
        ? l10n.subscriptionExpiredTitle
        : l10n.organizationSubscriptionExpiredTitle;
    final message = session.isOwner
        ? l10n.subscriptionExpiredMessageOwner
        : l10n.subscriptionExpiredMessageUser;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8FBFF), Color(0xFFE9F2FF)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.warningSoft,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              size: 36,
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(title, style: theme.textTheme.headlineSmall),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            message,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (!session.isOwner) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.contactAccountOwner,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                          if (expireDate != null ||
                              (session.planName?.trim().isNotEmpty ??
                                  false)) ...[
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(
                                  AppRadii.md,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (expireDate != null)
                                    _InfoRow(
                                      label: l10n.subscriptionExpiredDateLabel,
                                      value: AppDateFormatter.full(
                                        expireDate.toLocal(),
                                        locale: locale,
                                      ),
                                    ),
                                  if (session.planName?.trim().isNotEmpty ??
                                      false) ...[
                                    if (expireDate != null)
                                      const SizedBox(height: AppSpacing.sm),
                                    _InfoRow(
                                      label: l10n.subscriptionPlanLabel,
                                      value: session.planName!.trim(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                          if (state.feedback != null ||
                              state.error != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            _FeedbackBanner(state: state),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          if (session.isOwner) ...[
                            AppPrimaryButton(
                              label: l10n.requestRenewal,
                              onPressed: () async {
                                final result = await context.push<String>(
                                  AppRoutes.subscriptionRenewalRequest,
                                );
                                if (!context.mounted) {
                                  return;
                                }

                                controller.handleRenewalFlowResult(result);
                              },
                            ),
                            const SizedBox(height: AppSpacing.sm),
                          ],
                          AppSecondaryButton(
                            label: l10n.recheckStatus,
                            onPressed: state.isRechecking
                                ? null
                                : controller.recheckStatus,
                            icon: state.isRechecking
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.refresh_rounded, size: 18),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextButton(
                            onPressed: () => ref
                                .read(authControllerProvider.notifier)
                                .signOut(),
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.state});

  final SubscriptionExpiredState state;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final theme = Theme.of(context);
    final isError = state.feedback == SubscriptionExpiredFeedback.genericError;
    final isSuccess =
        state.feedback == SubscriptionExpiredFeedback.renewalSent ||
        state.feedback == SubscriptionExpiredFeedback.reactivated;
    final background = isError
        ? AppColors.dangerSoft
        : isSuccess
        ? AppColors.successSoft
        : AppColors.warningSoft;
    final foreground = isError
        ? AppColors.danger
        : isSuccess
        ? AppColors.success
        : AppColors.warning;

    final message = switch (state.feedback) {
      SubscriptionExpiredFeedback.renewalSent => l10n.renewalRequestSent,
      SubscriptionExpiredFeedback.renewalPending => l10n.renewalRequestPending,
      SubscriptionExpiredFeedback.stillExpired => l10n.subscriptionStillExpired,
      SubscriptionExpiredFeedback.reactivated => l10n.subscriptionReactivated,
      SubscriptionExpiredFeedback.genericError ||
      null => ErrorMessageMapper.getLocalizedMessage(
        context,
        state.error,
        fallbackMessage: l10n.somethingWentWrong,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError
                ? Icons.info_outline
                : isSuccess
                ? Icons.check_circle_outline
                : Icons.hourglass_bottom_rounded,
            color: foreground,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
