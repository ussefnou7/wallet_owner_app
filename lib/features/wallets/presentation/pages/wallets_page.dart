import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/icon_action_button.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../domain/entities/wallet.dart';
import '../controllers/wallets_controller.dart';
import '../widgets/collect_profit_sheet.dart';
import '../widgets/wallet_card.dart';

class WalletsPage extends ConsumerStatefulWidget {
  const WalletsPage({this.readOnly = false, super.key});

  final bool readOnly;

  @override
  ConsumerState<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends ConsumerState<WalletsPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(walletsSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletsControllerProvider);
    final filteredWallets = ref.watch(filteredWalletsProvider);
    final searchQuery = ref.watch(walletsSearchQueryProvider);
    final authState = ref.watch(authControllerProvider);
    final canManageWallets = !widget.readOnly;
    final canCollectProfit =
        canManageWallets && (authState.session?.isOwner ?? false);
    final l10n = appL10n(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: l10n.walletDirectory,
          subtitle: canManageWallets
              ? l10n.walletDirectoryManageSubtitle
              : l10n.walletDirectoryReadOnlySubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        if (walletState.error != null) ...[
          AppErrorState(
            message: _getErrorMessage(walletState.error!),
            onRetry: () =>
                ref.read(walletsControllerProvider.notifier).reload(),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _searchController,
                label: l10n.searchWallets,
                hintText: l10n.searchWalletsHint,
                prefixIcon: const Icon(Icons.search_rounded),
                onChanged: ref
                    .read(walletsControllerProvider.notifier)
                    .updateQuery,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconActionButton(
              icon: Icons.refresh_rounded,
              tooltip: l10n.refresh,
              onPressed: walletState.isLoading
                  ? null
                  : () => ref.read(walletsControllerProvider.notifier).reload(),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (canManageWallets)
              IconActionButton(
                icon: Icons.add_rounded,
                tooltip: l10n.createWallet,
                filled: true,
                onPressed: walletState.isLoading || walletState.isCreating
                    ? null
                    : () => _showWalletFormDialog(context),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: walletState.isLoading
              ? AppLoadingView(message: l10n.loadingWallets)
              : filteredWallets.isEmpty
              ? AppEmptyState(
                  title: searchQuery.trim().isEmpty
                      ? l10n.noWalletsFound
                      : l10n.noMatchingWallets,
                  message: searchQuery.trim().isEmpty
                      ? l10n.walletsEmptyMessage
                      : l10n.walletsSearchEmptyMessage,
                  icon: Icons.account_balance_wallet_outlined,
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                    bottom:
                        bottomInset +
                        AppDimensions.floatingBottomNavContentPadding,
                  ),
                  itemCount: filteredWallets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final wallet = filteredWallets[index];
                    return WalletCard(
                      wallet: wallet,
                      onCollectProfit: canCollectProfit
                          ? () => _showCollectProfitSheet(context, wallet)
                          : null,
                      onEdit: canManageWallets
                          ? () => _showWalletFormDialog(context, wallet: wallet)
                          : null,
                      onDelete: canManageWallets
                          ? () => _confirmDeleteWallet(context, wallet)
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _showWalletFormDialog(
    BuildContext context, {
    Wallet? wallet,
  }) async {
    if (wallet != null) {
      final l10n = appL10n(context);
      final messenger = ScaffoldMessenger.of(context);

      final submitted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => _EditWalletDialog(wallet: wallet),
      );

      if (submitted != true || !mounted) {
        return;
      }

      messenger.showSnackBar(SnackBar(content: Text(l10n.walletUpdated)));
      return;
    }

    // Create mode: show comprehensive form
    final l10n = appL10n(context);
    final messenger = ScaffoldMessenger.of(context);

    final submitted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _CreateWalletDialog(),
    );

    if (submitted != true || !mounted) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(l10n.walletCreated)));
  }

  Future<void> _confirmDeleteWallet(BuildContext context, Wallet wallet) async {
    final l10n = appL10n(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteWallet),
          content: Text(l10n.deleteWalletConfirmation(wallet.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(walletsControllerProvider.notifier).deleteWallet(wallet.id);

    if (!context.mounted) {
      return;
    }

    final state = ref.read(walletsControllerProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_getErrorMessage(state.error!))));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.walletDeleted)));
  }

  Future<void> _showCollectProfitSheet(
    BuildContext context,
    Wallet wallet,
  ) async {
    final l10n = appL10n(context);
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CollectProfitSheet(wallet: wallet),
    );

    if (submitted != true || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.collectProfitSuccess)));
  }

  String _getErrorMessage(AppException error) {
    return ErrorMessageMapper.getMessage(error);
  }
}

class _CreateWalletDialog extends ConsumerStatefulWidget {
  const _CreateWalletDialog();

  @override
  ConsumerState<_CreateWalletDialog> createState() =>
      _CreateWalletDialogState();
}

class _CreateWalletDialogState extends ConsumerState<_CreateWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _balanceController = TextEditingController();
  final _dailyLimitController = TextEditingController();
  final _monthlyLimitController = TextEditingController();

  String? _selectedBranchId;
  String? _selectedType;
  bool _isSubmitting = false;
  AppException? _submitError;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _balanceController.dispose();
    _dailyLimitController.dispose();
    _monthlyLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final branchesAsync = ref.watch(branchesControllerProvider);
    final walletTypesAsync = ref.watch(walletTypesProvider);

    return PopScope(
      canPop: !_isSubmitting,
      child: AlertDialog(
        title: Text(l10n.createWallet),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: l10n.walletName,
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.walletNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _numberController,
                    label: l10n.number,
                    prefixIcon: const Icon(Icons.phone_rounded),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.walletNumberRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _balanceController,
                    label: l10n.balance,
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_decimalInputFormatter],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.balanceRequired;
                      }
                      if (double.tryParse(value) == null) {
                        return l10n.validAmountRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _dailyLimitController,
                          label: l10n.dailyLimitLabel,
                          prefixIcon: const Icon(Icons.today_outlined),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_decimalInputFormatter],
                          validator: (value) => _validateLimitField(
                            value,
                            l10n.dailyLimitRequired,
                            l10n.validLimitRequired,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          controller: _monthlyLimitController,
                          label: l10n.monthlyLimitLabel,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_decimalInputFormatter],
                          validator: (value) => _validateLimitField(
                            value,
                            l10n.monthlyLimitRequired,
                            l10n.validLimitRequired,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  branchesAsync.when(
                    data: (branches) => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: l10n.branchName,
                        prefixIcon: const Icon(Icons.account_tree_outlined),
                      ),
                      initialValue: _selectedBranchId,
                      hint: Text(l10n.selectBranch),
                      items: branches
                          .map(
                            (branch) => DropdownMenuItem(
                              value: branch.id,
                              child: Text(branch.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedBranchId = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.branchRequired;
                        }
                        return null;
                      },
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (error, stackTrace) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox.shrink(),
                    ),
                  ),
                  if (branchesAsync.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        l10n.failedToLoadBranches,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  walletTypesAsync.when(
                    data: (types) {
                      if (types.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(l10n.noWalletTypesAvailable),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: l10n.walletTypeLabel,
                          prefixIcon: const Icon(Icons.category_outlined),
                        ),
                        initialValue: _selectedType,
                        hint: Text(l10n.selectWalletType),
                        items: types
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedType = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.walletTypeRequired;
                          }
                          return null;
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (error, stackTrace) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox.shrink(),
                    ),
                  ),
                  if (walletTypesAsync.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        l10n.failedToLoadWalletTypes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (_submitError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppErrorState(
                      key: const Key('wallet_inline_error'),
                      message: ErrorMessageMapper.getLocalizedMessage(
                        context,
                        _submitError,
                      ),
                      compact: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : () => _close(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _close([bool? result]) {
    FocusScope.of(context).unfocus();
    final goRouter = GoRouter.maybeOf(context);
    if (goRouter != null && context.canPop()) {
      context.pop(result);
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop(result);
      return;
    }

    if (goRouter != null) {
      context.go(AppRoutes.ownerWallets);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final authState = ref.read(authControllerProvider);
    final tenantId = authState.session?.tenantId;

    if (tenantId == null) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appL10n(context).sessionExpiredLoginAgain)),
      );
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final notifier = ref.read(walletsControllerProvider.notifier);
    await notifier.createWallet(
      name: _nameController.text.trim(),
      number: _numberController.text.trim(),
      branchId: _selectedBranchId!,
      balance: double.parse(_balanceController.text.trim()),
      dailyLimit: double.parse(_dailyLimitController.text.trim()),
      monthlyLimit: double.parse(_monthlyLimitController.text.trim()),
      type: _selectedType!,
      tenantId: tenantId,
    );

    if (!mounted) {
      return;
    }

    final state = ref.read(walletsControllerProvider);
    if (state.error != null) {
      setState(() {
        _isSubmitting = false;
        _submitError = state.error;
      });
      return;
    }

    _close(true);
  }
}

class _EditWalletDialog extends ConsumerStatefulWidget {
  const _EditWalletDialog({required this.wallet});

  final Wallet wallet;

  @override
  ConsumerState<_EditWalletDialog> createState() => _EditWalletDialogState();
}

class _EditWalletDialogState extends ConsumerState<_EditWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dailyLimitController;
  late final TextEditingController _monthlyLimitController;
  late bool _active;
  bool _isSubmitting = false;
  AppException? _submitError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.wallet.name);
    _dailyLimitController = TextEditingController(
      text: widget.wallet.dailyLimit.toStringAsFixed(
        widget.wallet.dailyLimit.truncateToDouble() == widget.wallet.dailyLimit
            ? 0
            : 2,
      ),
    );
    _monthlyLimitController = TextEditingController(
      text: widget.wallet.monthlyLimit.toStringAsFixed(
        widget.wallet.monthlyLimit.truncateToDouble() ==
                widget.wallet.monthlyLimit
            ? 0
            : 2,
      ),
    );
    _active = widget.wallet.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dailyLimitController.dispose();
    _monthlyLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return PopScope(
      canPop: !_isSubmitting,
      child: AlertDialog(
        title: Text(l10n.editWallet),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: l10n.walletName,
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.walletNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.walletStatusLabel,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile.adaptive(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      title: Text(l10n.active),
                      value: _active,
                      onChanged: _isSubmitting
                          ? null
                          : (value) {
                              if (!mounted) {
                                return;
                              }
                              setState(() => _active = value);
                            },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _dailyLimitController,
                          label: l10n.dailyLimitLabel,
                          prefixIcon: const Icon(Icons.today_outlined),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_decimalInputFormatter],
                          validator: (value) => _validateLimitField(
                            value,
                            l10n.dailyLimitRequired,
                            l10n.validLimitRequired,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          controller: _monthlyLimitController,
                          label: l10n.monthlyLimitLabel,
                          prefixIcon: const Icon(
                            Icons.calendar_month_outlined,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_decimalInputFormatter],
                          validator: (value) => _validateLimitField(
                            value,
                            l10n.monthlyLimitRequired,
                            l10n.validLimitRequired,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_submitError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppErrorState(
                      key: const Key('edit_wallet_inline_error'),
                      message: ErrorMessageMapper.getLocalizedMessage(
                        context,
                        _submitError,
                      ),
                      compact: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : () => _close(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _close([bool? result]) {
    if (!mounted) {
      return;
    }

    FocusScope.of(context).unfocus();
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop(result);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final name = _nameController.text.trim();
    final dailyLimit = double.parse(_dailyLimitController.text.trim());
    final monthlyLimit = double.parse(_monthlyLimitController.text.trim());
    final active = _active;

    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final notifier = ref.read(walletsControllerProvider.notifier);
    await notifier.updateWallet(
      walletId: widget.wallet.id,
      name: name,
      active: active,
      dailyLimit: dailyLimit,
      monthlyLimit: monthlyLimit,
    );

    if (!mounted) {
      return;
    }

    final state = ref.read(walletsControllerProvider);
    if (state.error != null) {
      setState(() {
        _isSubmitting = false;
        _submitError = state.error;
      });
      return;
    }

    _close(true);
  }
}

final _decimalInputFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*\.?\d{0,2}$'),
);

String? _validateLimitField(
  String? value,
  String requiredMessage,
  String invalidMessage,
) {
  if (value == null || value.trim().isEmpty) {
    return requiredMessage;
  }
  if (double.tryParse(value.trim()) == null) {
    return invalidMessage;
  }
  return null;
}
