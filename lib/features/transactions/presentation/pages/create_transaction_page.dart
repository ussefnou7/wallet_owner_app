import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
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
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedWalletId;
  TransactionEntryType? _selectedType;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletsState = ref.watch(walletsControllerProvider);
    final submissionState = ref.watch(createTransactionControllerProvider);
    final session = ref.watch(authControllerProvider).session;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: walletsState.when(
        loading: () => const AppLoadingView(message: 'Loading wallet options...'),
        error: (error, stackTrace) => AppErrorState(
          message: 'Unable to load wallet options.',
          onRetry: () => ref.read(walletsControllerProvider.notifier).reload(),
        ),
        data: (wallets) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSectionHeader(
                  title: 'Record Transaction',
                  subtitle:
                      'Capture the details after the real-life transaction has already happened.',
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
                    message: submissionState.errorMessage!,
                    compact: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppFormSection(
                  title: 'Transaction Details',
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppDropdownField<String>(
                          value: _selectedWalletId,
                          label: 'Wallet',
                          hintText: 'Select a wallet',
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                          items: wallets
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
                              return 'Wallet is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppDropdownField<TransactionEntryType>(
                          value: _selectedType,
                          label: 'Transaction Type',
                          hintText: 'Select credit or debit',
                          prefixIcon: const Icon(Icons.swap_vert_rounded),
                          items: const [
                            DropdownMenuItem(
                              value: TransactionEntryType.credit,
                              child: Text('Credit'),
                            ),
                            DropdownMenuItem(
                              value: TransactionEntryType.debit,
                              child: Text('Debit'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedType = value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Transaction type is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _amountController,
                          label: 'Amount',
                          hintText: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefixIcon: const Icon(Icons.attach_money_rounded),
                          inputFormatters: [PositiveAmountInputFormatter()],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Amount is required';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Enter a positive amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _dateController,
                          label: 'Date',
                          readOnly: true,
                          prefixIcon: const Icon(
                            Icons.calendar_today_outlined,
                          ),
                          onTap: _pickDate,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Date is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          controller: _noteController,
                          label: 'Note',
                          hintText: 'Add a short note',
                          prefixIcon: const Icon(Icons.notes_rounded),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppFormSection(
                  title: 'Submission Summary',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryRow(
                        label: 'Created by',
                        value: session?.displayName ?? 'Owner User',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SummaryRow(
                        label: 'Role',
                        value: session?.roleLabel ?? 'OWNER',
                      ),
                      if (_selectedWalletId != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Wallet Balance',
                          value: formatCurrency(
                            wallets
                                .firstWhere(
                                  (wallet) => wallet.id == _selectedWalletId,
                                )
                                .balance,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    label: 'Save Transaction',
                    isLoading: submissionState.isSubmitting,
                    onPressed: () => _submit(wallets, session?.displayName),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = picked;
      _dateController.text = formatDate(picked);
    });
  }

  Future<void> _submit(List<Wallet> wallets, String? displayName) async {
    FocusScope.of(context).unfocus();
    ref.read(createTransactionControllerProvider.notifier).clearFeedback();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final draft = TransactionDraft(
      walletId: _selectedWalletId!,
      type: _selectedType!,
      amount: double.parse(_amountController.text.trim()),
      note: _noteController.text.trim(),
      date: _selectedDate,
      createdBy: displayName ?? 'Owner User',
    );

    final success = await ref
        .read(createTransactionControllerProvider.notifier)
        .submit(draft);

    if (!success || !mounted) {
      return;
    }

    ref.invalidate(transactionsControllerProvider);

    final selectedWallet = wallets.firstWhere(
      (wallet) => wallet.id == _selectedWalletId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved ${_selectedType!.name} transaction for ${selectedWallet.name}.',
        ),
      ),
    );

    _formKey.currentState?.reset();
    _amountController.clear();
    _noteController.clear();
    setState(() {
      _selectedWalletId = null;
      _selectedType = null;
      _selectedDate = DateTime.now();
      _dateController.text = formatDate(_selectedDate);
    });
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
