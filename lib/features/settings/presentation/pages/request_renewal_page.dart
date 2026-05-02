import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatters/app_date_formatter.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_route_back_button.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/renewal_request_item.dart';
import '../controllers/renewal_requests_controller.dart';

class RequestRenewalPage extends ConsumerWidget {
  const RequestRenewalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = appL10n(context);
    final requestsState = ref.watch(renewalRequestsControllerProvider);

    return AppPageScaffold(
      title: l10n.renewalRequests,
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppRouteBackButton(fallbackRoute: AppRoutes.settings),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: requestsState.when(
              loading: () => AppLoadingView(message: '${l10n.loading}...'),
              error: (error, stackTrace) => _RenewalRequestsErrorState(
                onRetry: () => ref
                    .read(renewalRequestsControllerProvider.notifier)
                    .reload(),
              ),
              data: (requests) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSectionHeader(
                        title: l10n.renewalRequests,
                        subtitle: l10n.renewalRequestSubtitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: AppPrimaryButton(
                          buttonKey: const Key('renewal_new_request_button'),
                          label: l10n.newRequest,
                          icon: const Icon(Icons.add_rounded),
                          onPressed: () =>
                              context.push(AppRoutes.ownerCreateRenewalRequest),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (requests.isEmpty)
                        _RenewalRequestsEmptyState(
                          onCreatePressed: () =>
                              context.push(AppRoutes.ownerCreateRenewalRequest),
                        )
                      else
                        Column(
                          key: const Key('renewal_request_card'),
                          children: [
                            for (
                              var index = 0;
                              index < requests.length;
                              index++
                            ) ...[
                              _RenewalRequestCard(request: requests[index]),
                              if (index != requests.length - 1)
                                const SizedBox(height: AppSpacing.md),
                            ],
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RenewalRequestsErrorState extends StatelessWidget {
  const _RenewalRequestsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.renewalRequests,
            subtitle: l10n.renewalRequestSubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          AppErrorState(
            message: l10n.unableToLoadRenewalRequests,
            onRetry: onRetry,
          ),
        ],
      ),
    );
  }
}

class _RenewalRequestsEmptyState extends StatelessWidget {
  const _RenewalRequestsEmptyState({required this.onCreatePressed});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      children: [
        AppEmptyState(
          title: l10n.renewalRequests,
          message: l10n.noRenewalRequestsYet,
          icon: Icons.autorenew_rounded,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSecondaryButton(label: l10n.newRequest, onPressed: onCreatePressed),
      ],
    );
  }
}

class _RenewalRequestCard extends StatelessWidget {
  const _RenewalRequestCard({required this.request});

  final RenewalRequestItem request;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      key: ValueKey('renewal_request_card_${request.requestId}'),
      width: double.infinity,
      padding: AppDimensions.sectionPadding,
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
              Expanded(
                child: Text(
                  request.phoneNumber,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppStatusBadge(
                label: _statusLabel(request.status),
                foregroundColor: _statusForegroundColor(request.status),
                backgroundColor: _statusBackgroundColor(request.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: l10n.amount, value: formatCurrency(request.amount)),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: l10n.periodMonths,
            value: request.periodMonths.toString(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: l10n.requestedAt,
            value: AppDateFormatter.smart(request.createdAt, locale: locale),
          ),
          if (_shouldShowReviewedAt(request)) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              label: l10n.reviewedAt,
              value: AppDateFormatter.smart(
                request.reviewedAt!,
                locale: locale,
              ),
            ),
          ],
          if ((request.adminNote ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(l10n.adminNote, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              request.adminNote!.trim(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  bool _shouldShowReviewedAt(RenewalRequestItem request) {
    final normalizedStatus = request.status.toUpperCase();
    return request.reviewedAt != null &&
        (normalizedStatus == 'APPROVED' || normalizedStatus == 'REJECTED');
  }

  String _statusLabel(String status) {
    final normalized = status.trim();
    if (normalized.isEmpty) {
      return status;
    }

    return normalized
        .toLowerCase()
        .split('_')
        .map((part) {
          if (part.isEmpty) {
            return part;
          }
          return '${part[0].toUpperCase()}${part.substring(1)}';
        })
        .join(' ');
  }

  Color _statusForegroundColor(String status) {
    return switch (status.toUpperCase()) {
      'APPROVED' => AppColors.success,
      'REJECTED' => AppColors.danger,
      _ => AppColors.warning,
    };
  }

  Color _statusBackgroundColor(String status) {
    return switch (status.toUpperCase()) {
      'APPROVED' => AppColors.successSoft,
      'REJECTED' => AppColors.dangerSoft,
      _ => AppColors.warningSoft,
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
