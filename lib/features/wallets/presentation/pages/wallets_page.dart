import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/wallet.dart';
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
    final walletsState = ref.watch(walletsControllerProvider);
    final filteredWallets = ref.watch(filteredWalletsProvider);
    final searchQuery = ref.watch(walletsSearchQueryProvider);
    final canManageWallets = !widget.readOnly;
    final l10n = appL10n(context);

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
              onPressed: walletsState.isLoading
                  ? null
                  : () => ref.read(walletsControllerProvider.notifier).reload(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.refresh),
            ),
            if (canManageWallets) ...[
              const SizedBox(width: AppSpacing.sm),
              FilledButton.icon(
                onPressed: walletsState.isLoading
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
          child: walletsState.when(
            loading: () => AppLoadingView(message: l10n.loadingWallets),
            error: (error, stackTrace) => AppErrorState(
              message: l10n.unableToLoadWallets,
              onRetry: () =>
                  ref.read(walletsControllerProvider.notifier).reload(),
            ),
            data: (_) {
              if (filteredWallets.isEmpty) {
                return AppEmptyState(
                  title: searchQuery.trim().isEmpty
                      ? l10n.noWalletsFound
                      : l10n.noMatchingWallets,
                  message: searchQuery.trim().isEmpty
                      ? l10n.walletsEmptyMessage
                      : l10n.walletsSearchEmptyMessage,
                  icon: Icons.account_balance_wallet_outlined,
                );
              }

              return ListView.separated(
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
    final controller = TextEditingController(text: wallet?.name ?? '');
    var active = wallet?.active ?? true;
    final formKey = GlobalKey<FormState>();
    final l10n = appL10n(context);

    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(wallet == null ? l10n.createWallet : l10n.editWallet),
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
                    if (wallet != null) ...[
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
                  child: Text(wallet == null ? l10n.create : l10n.save),
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

    try {
      final notifier = ref.read(walletsControllerProvider.notifier);
      if (wallet == null) {
        await notifier.createWallet(name: name);
      } else {
        await notifier.updateWallet(
          walletId: wallet.id,
          name: name,
          active: active,
        );
      }

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wallet == null ? l10n.walletCreated : l10n.walletUpdated,
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wallet == null ? l10n.walletCreateFailed : l10n.walletUpdateFailed,
          ),
        ),
      );
    }
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

    try {
      await ref
          .read(walletsControllerProvider.notifier)
          .deleteWallet(wallet.id);
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.walletDeleted)));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.walletDeleteFailed)));
    }
  }
}
