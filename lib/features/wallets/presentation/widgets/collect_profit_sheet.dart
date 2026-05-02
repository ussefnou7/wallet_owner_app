import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/wallet.dart';
import '../controllers/wallets_controller.dart';

class CollectProfitSheet extends ConsumerStatefulWidget {
  const CollectProfitSheet({required this.wallet, super.key});

  final Wallet wallet;

  @override
  ConsumerState<CollectProfitSheet> createState() => _CollectProfitSheetState();
}

class _CollectProfitSheetState extends ConsumerState<CollectProfitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _walletProfitController = TextEditingController(text: '0');
  final _cashProfitController = TextEditingController(text: '0');
  final _noteController = TextEditingController();
  AppException? _submitError;
  String? _amountError;

  @override
  void dispose() {
    _walletProfitController.dispose();
    _cashProfitController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final state = ref.watch(walletsControllerProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final theme = Theme.of(context);
    final compactTheme = theme.copyWith(
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        isDense: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.72,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.xl),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.10),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Theme(
                data: compactTheme,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.borderStrong,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.collectProfit,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.wallet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: _ProfitMetricCard(
                                title: l10n.currentWalletProfit,
                                value: widget.wallet.walletProfit,
                                icon: Icons.account_balance_wallet_outlined,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _ProfitMetricCard(
                                title: l10n.currentCashProfit,
                                value: widget.wallet.cashProfit,
                                icon: Icons.payments_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppTextField(
                          controller: _walletProfitController,
                          label: l10n.walletProfitAmount,
                          hintText: '0',
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: AppDimensions.iconSm,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_decimalInputFormatter],
                          validator: (value) => _validateAmount(
                            value,
                            maxAmount: widget.wallet.walletProfit,
                            requiredMessage: l10n.validAmountRequired,
                            exceedMessage: l10n.walletProfitAmountExceeds,
                          ),
                          onChanged: (_) => _clearInlineErrors(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppTextField(
                          controller: _cashProfitController,
                          label: l10n.cashProfitAmount,
                          hintText: '0',
                          prefixIcon: const Icon(
                            Icons.payments_rounded,
                            size: AppDimensions.iconSm,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_decimalInputFormatter],
                          validator: (value) => _validateAmount(
                            value,
                            maxAmount: widget.wallet.cashProfit,
                            requiredMessage: l10n.validAmountRequired,
                            exceedMessage: l10n.cashProfitAmountExceeds,
                          ),
                          onChanged: (_) => _clearInlineErrors(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppTextField(
                          controller: _noteController,
                          label: l10n.note,
                          hintText: l10n.optionalNote,
                          prefixIcon: const Icon(
                            Icons.notes_rounded,
                            size: AppDimensions.iconSm,
                          ),
                          maxLines: 2,
                          onChanged: (_) {
                            if (_submitError != null) {
                              setState(() => _submitError = null);
                            }
                          },
                        ),
                        if (_amountError != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _amountError!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                        if (_submitError != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            ErrorMessageMapper.getLocalizedMessage(
                              context,
                              _submitError,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: state.isCollectingProfit
                                  ? null
                                  : () => Navigator.of(context).pop(false),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 40),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: 10,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: Text(l10n.cancel),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            FilledButton(
                              onPressed: state.isCollectingProfit ? null : _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 40),
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: 10,
                                ),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.md,
                                  ),
                                ),
                              ),
                              child: state.isCollectingProfit
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(l10n.collectProfit),
                            ),
                          ],
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
    );
  }

  String? _validateAmount(
    String? value, {
    required double maxAmount,
    required String requiredMessage,
    required String exceedMessage,
  }) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return requiredMessage;
    }

    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed < 0) {
      return requiredMessage;
    }

    if (parsed > maxAmount) {
      return exceedMessage;
    }

    return null;
  }

  void _clearInlineErrors() {
    if (_amountError == null && _submitError == null) {
      return;
    }

    setState(() {
      _amountError = null;
      _submitError = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final walletProfitAmount =
        double.tryParse(_walletProfitController.text.trim()) ?? 0;
    final cashProfitAmount =
        double.tryParse(_cashProfitController.text.trim()) ?? 0;

    if (walletProfitAmount <= 0 && cashProfitAmount <= 0) {
      setState(() {
        _amountError = appL10n(context).collectProfitAmountRequired;
        _submitError = null;
      });
      return;
    }

    setState(() {
      _amountError = null;
      _submitError = null;
    });

    final success = await ref
        .read(walletsControllerProvider.notifier)
        .collectProfit(
          walletId: widget.wallet.id,
          walletProfitAmount: walletProfitAmount,
          cashProfitAmount: cashProfitAmount,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (!success) {
      setState(() {
        _submitError = ref.read(walletsControllerProvider).error;
      });
      return;
    }

    Navigator.of(context).pop(true);
  }
}

class _ProfitMetricCard extends StatelessWidget {
  const _ProfitMetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final double value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.successSoft,
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Icon(icon, size: 16, color: AppColors.success),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  formatCurrency(value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final _decimalInputFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*\.?\d{0,2}$'),
);
