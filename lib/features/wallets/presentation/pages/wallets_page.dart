import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';
import '../controllers/wallets_controller.dart';
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
    final canManageWallets = !widget.readOnly;
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
            message: _getErrorMessage(walletState.error!, l10n),
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
            OutlinedButton.icon(
              onPressed: walletState.isLoading
                  ? null
                  : () => ref.read(walletsControllerProvider.notifier).reload(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.refresh),
            ),
            if (canManageWallets) ...[
              const SizedBox(width: AppSpacing.sm),
              FilledButton.icon(
                onPressed: walletState.isLoading || walletState.isCreating
                    ? null
                    : () => _showWalletFormDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.create),
              ),
            ],
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
                        bottom: bottomInset +
                            AppDimensions.floatingBottomNavContentPadding,
                      ),
                      itemCount: filteredWallets.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final wallet = filteredWallets[index];
                        return WalletCard(
                          wallet: wallet,
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
    // For edit mode only
    if (wallet != null) {
      final controller = TextEditingController(text: wallet.name);
      var active = wallet.active ?? true;
      final formKey = GlobalKey<FormState>();
      final l10n = appL10n(context);

      final submitted = await showDialog<bool>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(l10n.editWallet),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: l10n.walletName,
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.walletNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.active),
                        value: active,
                        onChanged: (value) {
                          setDialogState(() => active = value);
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Text(l10n.save),
                  ),
                ],
              );
            },
          );
        },
      );

      if (submitted != true || !mounted) {
        controller.dispose();
        return;
      }

      final name = controller.text.trim();
      controller.dispose();

      final notifier = ref.read(walletsControllerProvider.notifier);
      await notifier.updateWallet(
        walletId: wallet.id,
        name: name,
        active: active,
      );

      if (!mounted) {
        return;
      }

      final state = ref.read(walletsControllerProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getErrorMessage(state.error!, l10n),
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.walletUpdated)),
      );
      return;
    }

    // Create mode: show comprehensive form
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final balanceController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final l10n = appL10n(context);

    String? selectedBranchId;
    String? selectedType;

    final submitted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final branchesAsync = ref.watch(branchesControllerProvider);

            return AlertDialog(
              title: Text(l10n.createWallet),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: l10n.walletName,
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.walletNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                          labelText: l10n.number,
                          prefixIcon: const Icon(Icons.phone_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Wallet number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: balanceController,
                        decoration: InputDecoration(
                          labelText: l10n.balance,
                          prefixIcon: const Icon(Icons.attach_money_rounded),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Balance is required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      branchesAsync.when(
                        data: (branches) => DropdownButtonFormField<String>(
                          value: selectedBranchId,
                          hint: const Text('Select branch'),
                          items: branches
                              .map((branch) => DropdownMenuItem(
                                    value: branch.id,
                                    child: Text(branch.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(
                                () => selectedBranchId = value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Branch is required';
                            }
                            return null;
                          },
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        error: (_, __) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Failed to load branches'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ref.watch(walletTypesProvider).when(
                        data: (types) {
                          if (types.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No wallet types available'),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            initialValue: selectedType,
                            hint: const Text('Select wallet type'),
                            items: types
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setDialogState(() => selectedType = value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Wallet type is required';
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        error: (_, __) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Failed to load wallet types'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text(l10n.create),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted != true || !mounted) {
      nameController.dispose();
      numberController.dispose();
      balanceController.dispose();
      return;
    }

    final authState = ref.read(authControllerProvider);
    final tenantId = authState.session?.tenantId;

    if (tenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please log in again.'),
        ),
      );
      nameController.dispose();
      numberController.dispose();
      balanceController.dispose();
      return;
    }

    final notifier = ref.read(walletsControllerProvider.notifier);
    await notifier.createWallet(
      name: nameController.text.trim(),
      number: numberController.text.trim(),
      branchId: selectedBranchId!,
      balance: double.parse(balanceController.text.trim()),
      type: selectedType!,
      tenantId: tenantId,
    );

    nameController.dispose();
    numberController.dispose();
    balanceController.dispose();

    if (!mounted) {
      return;
    }

    final state = ref.read(walletsControllerProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _getErrorMessage(state.error!, l10n),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.walletCreated)),
    );
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

    await ref
        .read(walletsControllerProvider.notifier)
        .deleteWallet(wallet.id);

    if (!context.mounted) {
      return;
    }

    final state = ref.read(walletsControllerProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getErrorMessage(state.error!, l10n))),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.walletDeleted)),
    );
  }

  String _getErrorMessage(String error, AppLocalizations l10n) {
    return switch (error) {
      'wallet_load_error' => l10n.walletLoadError,
      'wallet_create_error' => l10n.walletCreateError,
      'wallet_update_error' => l10n.walletUpdateError,
      'wallet_delete_error' => l10n.walletDeleteError,
      _ => error,
    };
  }
}
