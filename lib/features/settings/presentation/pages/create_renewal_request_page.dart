import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../domain/entities/renewal_request_payload.dart';
import '../controllers/renewal_controller.dart';
import '../controllers/renewal_requests_controller.dart';

class CreateRenewalRequestPage extends ConsumerStatefulWidget {
  const CreateRenewalRequestPage({super.key});

  @override
  ConsumerState<CreateRenewalRequestPage> createState() =>
      _CreateRenewalRequestPageState();
}

class _CreateRenewalRequestPageState
    extends ConsumerState<CreateRenewalRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _periodController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final state = ref.watch(renewalControllerProvider);

    return AppPageScaffold(
      title: l10n.newRequest,
      embedded: true,
      maxWidth: AppDimensions.compactContentMaxWidth,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: l10n.newRequest,
              subtitle: l10n.renewalRequestSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppFormSection(
              title: l10n.renewalRequest,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      fieldKey: const Key('renewal_phone_field'),
                      controller: _phoneController,
                      label: l10n.phoneNumber,
                      hintText: '01xxxxxxxxx',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.phone_android_rounded),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.phoneNumberRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      fieldKey: const Key('renewal_amount_field'),
                      controller: _amountController,
                      label: l10n.amount,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.payments_outlined),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.amountRequired;
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return l10n.positiveAmountRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      fieldKey: const Key('renewal_period_field'),
                      controller: _periodController,
                      label: l10n.periodMonths,
                      hintText: '1, 3, 6, 12...',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.periodMonthsRequired;
                        }
                        final period = int.tryParse(value);
                        if (period == null || period <= 0) {
                          return l10n.positivePeriodRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _PeriodSuggestions(
                      onSelected: (value) => setState(() {
                        _periodController.text = value;
                      }),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (state.error != null) ...[
                      AppErrorState(
                        key: const Key('renewal_inline_error'),
                        message: ErrorMessageMapper.getLocalizedMessage(
                          context,
                          state.error,
                          fallbackMessage: l10n.unableToSubmitRenewalRequest,
                        ),
                        compact: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        buttonKey: const Key('renewal_submit_button'),
                        label: l10n.submitRenewalRequest,
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
    if (_formKey.currentState?.validate() != true) return;

    final payload = RenewalRequestPayload(
      phoneNumber: _phoneController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      periodMonths: int.parse(_periodController.text.trim()),
    );

    final success = await ref
        .read(renewalControllerProvider.notifier)
        .createRenewalRequest(payload);

    if (!success || !mounted) {
      return;
    }

    await ref.read(renewalRequestsControllerProvider.notifier).reload();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(appL10n(context).renewalRequestSubmitted)),
    );
    await Navigator.of(context).maybePop();
  }
}

class _PeriodSuggestions extends StatelessWidget {
  const _PeriodSuggestions({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: ['1', '3', '6', '12'].map((period) {
          return ActionChip(
            label: Text('$period ${l10n.periodMonths}'),
            onPressed: () => onSelected(period),
          );
        }).toList(),
      ),
    );
  }
}
