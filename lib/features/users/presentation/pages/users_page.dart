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
import '../controllers/users_controller.dart';
import '../widgets/user_card.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(usersSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersControllerProvider);
    final filteredUsers = ref.watch(filteredUsersProvider);
    final searchQuery = ref.watch(usersSearchQueryProvider);
    final statusFilter = ref.watch(usersStatusFilterProvider);
    final roleFilter = ref.watch(usersRoleFilterProvider);
    final l10n = appL10n(context);

    return AppPageScaffold(
      title: l10n.users,
      actions: [
        IconButton(
          onPressed: () => ref.read(usersControllerProvider.notifier).reload(),
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
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.users),
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.userDirectory,
            subtitle: l10n.userDirectorySubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _searchController,
            label: l10n.searchUsers,
            hintText: l10n.searchUsersHint,
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: ref.read(usersControllerProvider.notifier).updateQuery,
          ),
          const SizedBox(height: AppSpacing.md),
          FilterChipRow<UserStatusFilter>(
            selectedValue: statusFilter,
            onSelected: ref
                .read(usersControllerProvider.notifier)
                .updateStatusFilter,
            options: [
              FilterChipOption(
                value: UserStatusFilter.all,
                label: l10n.allStatus,
              ),
              FilterChipOption(
                value: UserStatusFilter.active,
                label: l10n.active,
              ),
              FilterChipOption(
                value: UserStatusFilter.inactive,
                label: l10n.inactive,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FilterChipRow<UserRoleFilter>(
            selectedValue: roleFilter,
            onSelected: ref
                .read(usersControllerProvider.notifier)
                .updateRoleFilter,
            options: [
              FilterChipOption(value: UserRoleFilter.all, label: l10n.allRoles),
              FilterChipOption(value: UserRoleFilter.owner, label: l10n.owner),
              FilterChipOption(value: UserRoleFilter.user, label: l10n.user),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppResultSummary(count: filteredUsers.length, label: l10n.users),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: usersState.when(
              loading: () => AppLoadingView(message: l10n.loadingUsers),
              error: (error, stackTrace) => AppErrorState(
                message: l10n.unableToLoadUsers,
                onRetry: () =>
                    ref.read(usersControllerProvider.notifier).reload(),
              ),
              data: (_) {
                if (filteredUsers.isEmpty) {
                  return AppEmptyState(
                    title: searchQuery.trim().isEmpty
                        ? l10n.noUsersAvailable
                        : l10n.noMatchingUsers,
                    message: searchQuery.trim().isEmpty
                        ? l10n.usersEmptyMessage
                        : l10n.usersSearchEmptyMessage,
                    icon: Icons.people_outline_rounded,
                  );
                }

                return ListView.separated(
                  itemCount: filteredUsers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return UserCard(user: filteredUsers[index]);
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
