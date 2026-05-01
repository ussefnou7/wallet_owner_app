import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../wallets/domain/entities/wallet.dart';
import '../../../wallets/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/transaction_draft.dart';
import '../controllers/create_transaction_controller.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/transaction_success_banner.dart';

class CreateTransactionPage extends ConsumerStatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  ConsumerState<CreateTransactionPage> createState() =>
      _CreateTransactionPageState();
}

class _CreateTransactionPageState extends ConsumerState<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFieldKey = GlobalKey();
  final _descriptionFieldKey = GlobalKey();
  final _scrollController = ScrollController();
  final _amountController = TextEditingController();
  final _percentController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final FocusNode _phoneFocusNode;
  late final FocusNode _descriptionFocusNode;

  String? _selectedWalletId;
  TransactionEntryType? _selectedType;
  bool _cash = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode = FocusNode();
    _phoneFocusNode.addListener(_handlePhoneFocusChange);
    _descriptionFocusNode = FocusNode();
    _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
  }

  void _handlePhoneFocusChange() {
    if (_phoneFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Scrollable.ensureVisible(
          _phoneFieldKey.currentContext!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: 0.25,
        );
      });
    }
  }

  void _handleDescriptionFocusChange() {
    if (_descriptionFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Scrollable.ensureVisible(
          _descriptionFieldKey.currentContext!,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: 0.25,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _phoneFocusNode.removeListener(_handlePhoneFocusChange);
    _phoneFocusNode.dispose();
    _descriptionFocusNode.removeListener(_handleDescriptionFocusChange);
    _descriptionFocusNode.dispose();
    _amountController.dispose();
    _percentController.dispose();
    _phoneNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletsState = ref.watch(walletsControllerProvider);
    final submissionState = ref.watch(createTransactionControllerProvider);
    final l10n = appL10n(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final bottomPadding = keyboardInset + safeBottom + 140;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: walletsState.isLoading
          ? AppLoadingView(message: l10n.loadingWalletOptions)
          : walletsState.error != null
          ? AppErrorState(
              message: l10n.unableToLoadWalletOptions,
              onRetry: () =>
                  ref.read(walletsControllerProvider.notifier).reload(),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionHeader(
                    title: l10n.recordTransaction,
                    subtitle: l10n.recordTransactionSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (submissionState.lastResult != null) ...[
                    TransactionSuccessBanner(
                      referenceId: submissionState.lastResult!.referenceId,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (submissionState.errorMessage != null) ...[
                    AppErrorState(
                      message: ErrorMessageMapper.getMessage(
                        submissionState.errorMessage!,
                      ),
                      compact: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AppFormSection(
                    title: l10n.transactionDetails,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppDropdownField<String>(
                            value: _selectedWalletId,
                            label: '${l10n.wallet} *',
                            hintText: l10n.selectWallet,
                            prefixIcon: const Icon(
                              Icons.account_balance_wallet_outlined,
                            ),
                            items: walletsState.data
                                .map(
                                  (wallet) => DropdownMenuItem<String>(
                                    value: wallet.id,
                                    child: Text(wallet.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedWalletId = value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.walletRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppDropdownField<TransactionEntryType>(
                            value: _selectedType,
                            label: '${l10n.transactionType} *',
                            hintText: l10n.selectCreditOrDebit,
                            prefixIcon: const Icon(Icons.swap_vert_rounded),
                            items: [
                              DropdownMenuItem(
                                value: TransactionEntryType.credit,
                                child: Text(l10n.credit),
                              ),
                              DropdownMenuItem(
                                value: TransactionEntryType.debit,
                                child: Text(l10n.debit),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                                if (value != TransactionEntryType.credit) {
                                  _cash = false;
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return l10n.transactionTypeRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _amountController,
                            label: '${l10n.amount} *',
                            hintText: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefixIcon: const Icon(Icons.attach_money_rounded),
                            inputFormatters: [PositiveAmountInputFormatter()],
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
                            controller: _percentController,
                            label: '${l10n.percent} *',
                            hintText: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefixIcon: const Icon(Icons.percent_rounded),
                            inputFormatters: [PositiveAmountInputFormatter()],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.percentRequired;
                              }
                              final percent = double.tryParse(value);
                              if (percent == null || percent < 0) {
                                return l10n.validPercentRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: _phoneFieldKey,
                            controller: _phoneNumberController,
                            focusNode: _phoneFocusNode,
                            label: '${l10n.phoneNumber} *',
                            hintText: '01000256987',
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_outlined),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.phoneNumberRequired;
                              }
                              if (value.trim().length < 8) {
                                return l10n.validPhoneNumberRequired;
                              }
                              return null;
                            },
                          ),
                          if (_selectedType == TransactionEntryType.credit)
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.cash),
                              value: _cash,
                              onChanged: (value) {
                                setState(() => _cash = value);
                              },
                            ),
                          if (_selectedType == TransactionEntryType.credit)
                            const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            key: _descriptionFieldKey,
                            controller: _descriptionController,
                            focusNode: _descriptionFocusNode,
                            label: l10n.description,
                            hintText: l10n.optionalDescription,
                            prefixIcon: const Icon(Icons.notes_rounded),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      label: l10n.saveTransaction,
                      isLoading: submissionState.isSubmitting,
                      onPressed: () => _submit(walletsState.data),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _submit(List<Wallet> wallets) async {
    FocusScope.of(context).unfocus();
    ref.read(createTransactionControllerProvider.notifier).clearFeedback();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final draft = TransactionDraft(
      walletId: _selectedWalletId!,
      type: _selectedType!,
      amount: double.parse(_amountController.text.trim()),
      percent: double.parse(_percentController.text.trim()),
      externalTransactionId: _generateUuid(),
      occurredAt: DateTime.now(),
      phoneNumber: _phoneNumberController.text.trim(),
      cash: _selectedType == TransactionEntryType.credit ? _cash : false,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final success = await ref
        .read(createTransactionControllerProvider.notifier)
        .submit(draft);

    if (!success || !mounted) {
      return;
    }

    await ref.read(transactionsControllerProvider.notifier).reload();
    if (!mounted) {
      return;
    }
    ref.invalidate(walletsControllerProvider);
    ref.invalidate(dashboardOverviewProvider);
    ref.invalidate(dashboardTransactionSummaryProvider);
    ref.invalidate(dashboardRecentTransactionsProvider);

    final selectedWallet = wallets.firstWhere(
      (wallet) => wallet.id == _selectedWalletId,
    );
    final l10n = appL10n(context);
    final typeLabel = _selectedType == TransactionEntryType.credit
        ? l10n.credit
        : l10n.debit;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.savedTransactionForWallet(typeLabel, selectedWallet.name),
        ),
      ),
    );

    _formKey.currentState?.reset();
    _amountController.clear();
    _percentController.clear();
    _phoneNumberController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedWalletId = null;
      _selectedType = null;
      _cash = false;
    });
  }

  String _generateUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
