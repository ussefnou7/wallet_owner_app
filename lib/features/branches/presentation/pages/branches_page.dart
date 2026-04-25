import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_result_summary.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/filter_chip_row.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../domain/entities/branch.dart';
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AppPageScaffold(
      title: l10n.branches,
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
      ],
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.ownerBranches),
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.branchDirectory,
            subtitle: l10n.branchDirectorySubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppPrimaryButton(
                label: l10n.createBranch,
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _showBranchFormDialog(context),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton.outlined(
                onPressed: () =>
                    ref.read(branchesControllerProvider.notifier).reload(),
                icon: const Icon(Icons.refresh_rounded),
                tooltip: l10n.refresh,
              ),
            ],
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
                  padding: EdgeInsets.only(
                    bottom: bottomInset + AppDimensions.floatingBottomNavContentPadding,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final branch = filteredBranches[index];
                    return BranchCard(
                      branch: branch,
                      onEdit: () => _showBranchFormDialog(context, branch: branch),
                      onDelete: () => _confirmDeleteBranch(context, branch),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBranchFormDialog(
    BuildContext context, {
    Branch? branch,
  }) async {
    final l10n = appL10n(context);
    final controller = TextEditingController(text: branch?.name ?? '');
    var active = branch?.status == BranchStatus.active;
    final formKey = GlobalKey<FormState>();

    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(branch == null ? l10n.createBranch : l10n.editBranch),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: l10n.branchName,
                        prefixIcon: const Icon(Icons.storefront_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.branchNameRequired;
                        }
                        return null;
                      },
                    ),
                    if (branch != null) ...[
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
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted != true || !context.mounted) {
      controller.dispose();
      return;
    }

    try {
      if (branch == null) {
        await ref
            .read(branchesControllerProvider.notifier)
            .createBranch(controller.text.trim());
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.branchCreatedSuccessfully)),
        );
      } else {
        await ref
            .read(branchesControllerProvider.notifier)
            .updateBranch(branch.id, controller.text.trim(), active);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.branchUpdatedSuccessfully)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToLoadBranches)),
        );
      }
    } finally {
      controller.dispose();
    }
  }

  Future<void> _confirmDeleteBranch(BuildContext context, Branch branch) async {
    final l10n = appL10n(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteBranch),
          content: Text(l10n.confirmDelete),
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
      await ref.read(branchesControllerProvider.notifier).deleteBranch(branch.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.branchDeletedSuccessfully)),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToLoadBranches)),
        );
      }
    }
  }
}
