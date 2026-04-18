import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../controllers/wallets_controller.dart';
import '../widgets/wallet_card.dart';

class WalletsPage extends ConsumerStatefulWidget {
  const WalletsPage({super.key});

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

    return AppPageScaffold(
      title: 'Wallets',
      actions: [
        IconButton(
          onPressed: () =>
              ref.read(walletsControllerProvider.notifier).reload(),
          icon: const Icon(Icons.refresh_rounded),
        ),
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
      ],
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.wallets),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: AppRoutes.wallets,
        onDestinationSelected: context.go,
      ),
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Wallet Directory',
            subtitle: 'Review wallet balances, branch assignment, and status.',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _searchController,
                  label: 'Search wallets',
                  hintText: 'Search by name, code, or branch',
                  prefixIcon: const Icon(Icons.search_rounded),
                  onChanged: ref
                      .read(walletsControllerProvider.notifier)
                      .updateQuery,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filtering options will be added later.'),
                    ),
                  );
                },
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Filter'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: walletsState.when(
              loading: () =>
                  const AppLoadingView(message: 'Loading wallets...'),
              error: (error, stackTrace) => AppErrorState(
                message: 'Unable to load wallets right now.',
                onRetry: () =>
                    ref.read(walletsControllerProvider.notifier).reload(),
              ),
              data: (_) {
                if (filteredWallets.isEmpty) {
                  return AppEmptyState(
                    title: searchQuery.trim().isEmpty
                        ? 'No wallets found'
                        : 'No matching wallets',
                    message: searchQuery.trim().isEmpty
                        ? 'Wallet records will appear here once available.'
                        : 'Try a different search term or clear the filter.',
                    icon: Icons.account_balance_wallet_outlined,
                  );
                }

                return ListView.separated(
                  itemCount: filteredWallets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return WalletCard(wallet: filteredWallets[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
