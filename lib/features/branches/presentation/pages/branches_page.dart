import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_result_summary.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/filter_chip_row.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../controllers/branches_controller.dart';
import '../widgets/branch_card.dart';

class BranchesPage extends ConsumerStatefulWidget {
  const BranchesPage({super.key});

  @override
  ConsumerState<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends ConsumerState<BranchesPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(branchesSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchesState = ref.watch(branchesControllerProvider);
    final filteredBranches = ref.watch(filteredBranchesProvider);
    final statusFilter = ref.watch(branchesStatusFilterProvider);
    final searchQuery = ref.watch(branchesSearchQueryProvider);
    final l10n = appL10n(context);

    return AppPageScaffold(
      title: l10n.branches,
      actions: [
        IconButton(
          onPressed: () =>
              ref.read(branchesControllerProvider.notifier).reload(),
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
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.branches),
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.branchDirectory,
            subtitle: l10n.branchDirectorySubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _searchController,
            label: l10n.searchBranches,
            hintText: l10n.searchBranchesHint,
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: ref
                .read(branchesControllerProvider.notifier)
                .updateQuery,
          ),
          const SizedBox(height: AppSpacing.md),
          FilterChipRow<BranchStatusFilter>(
            selectedValue: statusFilter,
            onSelected: ref
                .read(branchesControllerProvider.notifier)
                .updateStatusFilter,
            options: [
              FilterChipOption(
                value: BranchStatusFilter.all,
                label: l10n.allStatus,
              ),
              FilterChipOption(
                value: BranchStatusFilter.active,
                label: l10n.active,
              ),
              FilterChipOption(
                value: BranchStatusFilter.inactive,
                label: l10n.inactive,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppResultSummary(
            count: filteredBranches.length,
            label: l10n.branches,
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: branchesState.when(
              loading: () => AppLoadingView(message: l10n.loadingBranches),
              error: (error, stackTrace) => AppErrorState(
                message: l10n.unableToLoadBranches,
                onRetry: () =>
                    ref.read(branchesControllerProvider.notifier).reload(),
              ),
              data: (_) {
                if (filteredBranches.isEmpty) {
                  return AppEmptyState(
                    title: searchQuery.trim().isEmpty
                        ? l10n.noBranchesAvailable
                        : l10n.noMatchingBranches,
                    message: searchQuery.trim().isEmpty
                        ? l10n.branchesEmptyMessage
                        : l10n.branchesSearchEmptyMessage,
                    icon: Icons.storefront_outlined,
                  );
                }

                return ListView.separated(
                  itemCount: filteredBranches.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return BranchCard(branch: filteredBranches[index]);
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
