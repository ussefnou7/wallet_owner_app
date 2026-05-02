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
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/support_ticket_item.dart';
import '../controllers/support_tickets_controller.dart';

class SupportPage extends ConsumerWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = appL10n(context);
    final ticketsState = ref.watch(supportTicketsControllerProvider);
    final session = ref.watch(authControllerProvider).session;
    final createSupportRoute = session?.isUser == true
        ? AppRoutes.userCreateSupport
        : AppRoutes.ownerCreateSupport;

    return AppPageScaffold(
      title: l10n.supportTickets,
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: ticketsState.when(
        loading: () => AppLoadingView(message: '${l10n.loading}...'),
        error: (error, stackTrace) => _SupportTicketsErrorState(
          onRetry: () =>
              ref.read(supportTicketsControllerProvider.notifier).reload(),
        ),
        data: (tickets) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: l10n.supportTickets,
                  subtitle: l10n.supportSubtitle,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    buttonKey: const Key('support_new_ticket_button'),
                    label: l10n.newTicket,
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () => context.push(createSupportRoute),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (tickets.isEmpty)
                  _SupportTicketsEmptyState(
                    onCreatePressed: () => context.push(createSupportRoute),
                  )
                else
                  Column(
                    key: const Key('support_ticket_card'),
                    children: [
                      for (var index = 0; index < tickets.length; index++) ...[
                        _SupportTicketCard(ticket: tickets[index]),
                        if (index != tickets.length - 1)
                          const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SupportTicketsErrorState extends StatelessWidget {
  const _SupportTicketsErrorState({required this.onRetry});

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
            title: l10n.supportTickets,
            subtitle: l10n.supportSubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          AppErrorState(
            message: l10n.unableToLoadSupportTickets,
            onRetry: onRetry,
          ),
        ],
      ),
    );
  }
}

class _SupportTicketsEmptyState extends StatelessWidget {
  const _SupportTicketsEmptyState({required this.onCreatePressed});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      children: [
        AppEmptyState(
          title: l10n.supportTickets,
          message: l10n.noSupportTicketsYet,
          icon: Icons.support_agent_rounded,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSecondaryButton(label: l10n.newTicket, onPressed: onCreatePressed),
      ],
    );
  }
}

class _SupportTicketCard extends StatelessWidget {
  const _SupportTicketCard({required this.ticket});

  final SupportTicketItem ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      key: ValueKey('support_ticket_card_${ticket.ticketId}'),
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
          Text(ticket.subject, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            ticket.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppStatusBadge(
                label: _enumLabel(ticket.priority),
                foregroundColor: _priorityForegroundColor(ticket.priority),
                backgroundColor: _priorityBackgroundColor(ticket.priority),
              ),
              AppStatusBadge(
                label: _enumLabel(ticket.status),
                foregroundColor: _statusForegroundColor(ticket.status),
                backgroundColor: _statusBackgroundColor(ticket.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            label: l10n.createdAt,
            value: AppDateFormatter.smart(ticket.createdAt, locale: locale),
          ),
          if (_shouldShowResolvedAt(ticket)) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              label: l10n.resolvedAt,
              value: AppDateFormatter.smart(ticket.resolvedAt!, locale: locale),
            ),
          ],
        ],
      ),
    );
  }

  bool _shouldShowResolvedAt(SupportTicketItem ticket) {
    return ticket.status.toUpperCase() == 'RESOLVED' &&
        ticket.resolvedAt != null;
  }

  String _enumLabel(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return value;
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

  Color _priorityForegroundColor(String priority) {
    return switch (priority.toUpperCase()) {
      'HIGH' => AppColors.danger,
      'LOW' => AppColors.success,
      _ => AppColors.warning,
    };
  }

  Color _priorityBackgroundColor(String priority) {
    return switch (priority.toUpperCase()) {
      'HIGH' => AppColors.dangerSoft,
      'LOW' => AppColors.successSoft,
      _ => AppColors.warningSoft,
    };
  }

  Color _statusForegroundColor(String status) {
    return switch (status.toUpperCase()) {
      'RESOLVED' => AppColors.success,
      'OPEN' => AppColors.warning,
      _ => AppColors.textSecondary,
    };
  }

  Color _statusBackgroundColor(String status) {
    return switch (status.toUpperCase()) {
      'RESOLVED' => AppColors.successSoft,
      'OPEN' => AppColors.warningSoft,
      _ => AppColors.surfaceVariant,
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
