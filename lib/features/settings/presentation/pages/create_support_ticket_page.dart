import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/support_ticket.dart';
import '../controllers/support_controller.dart';
import '../controllers/support_tickets_controller.dart';

class CreateSupportTicketPage extends ConsumerStatefulWidget {
  const CreateSupportTicketPage({super.key});

  @override
  ConsumerState<CreateSupportTicketPage> createState() =>
      _CreateSupportTicketPageState();
}

class _CreateSupportTicketPageState
    extends ConsumerState<CreateSupportTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final state = ref.watch(supportControllerProvider);

    return AppPageScaffold(
      title: l10n.newTicket,
      embedded: true,
      maxWidth: AppDimensions.compactContentMaxWidth,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: l10n.newTicket,
              subtitle: l10n.supportSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppFormSection(
              title: l10n.support,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      fieldKey: const Key('support_subject_field'),
                      controller: _subjectController,
                      label: l10n.subject,
                      hintText: l10n.subject,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.subject_rounded),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.subjectRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      fieldKey: const Key('support_description_field'),
                      controller: _descriptionController,
                      label: l10n.supportMessage,
                      hintText: l10n.supportMessage,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      prefixIcon: const Icon(Icons.description_outlined),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.supportMessageRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.error != null) ...[
                      AppErrorState(
                        key: const Key('support_inline_error'),
                        message: ErrorMessageMapper.getLocalizedMessage(
                          context,
                          state.error,
                          fallbackMessage: l10n.unableToSubmitSupportRequest,
                        ),
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        buttonKey: const Key('support_submit_button'),
                        label: l10n.sendSupportRequest,
                        isLoading: state.isSubmitting,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final ticket = SupportTicket(
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: SupportPriority.medium,
    );

    final success = await ref
        .read(supportControllerProvider.notifier)
        .createTicket(ticket);

    if (!success || !mounted) {
      return;
    }

    await ref.read(supportTicketsControllerProvider.notifier).reload();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(appL10n(context).supportRequestSent)),
    );
    await Navigator.of(context).maybePop();
  }
}
