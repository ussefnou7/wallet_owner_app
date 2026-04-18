import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
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

    return AppPageScaffold(
      title: 'Users',
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
          const AppSectionHeader(
            title: 'User Directory',
            subtitle:
                'Monitor owner and user accounts, branch assignment, and activity status.',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _searchController,
            label: 'Search users',
            hintText: 'Search by name, email, or branch',
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: ref.read(usersControllerProvider.notifier).updateQuery,
          ),
          const SizedBox(height: AppSpacing.md),
          FilterChipRow<UserStatusFilter>(
            selectedValue: statusFilter,
            onSelected: ref
                .read(usersControllerProvider.notifier)
                .updateStatusFilter,
            options: const [
              FilterChipOption(
                value: UserStatusFilter.all,
                label: 'All Status',
              ),
              FilterChipOption(value: UserStatusFilter.active, label: 'Active'),
              FilterChipOption(
                value: UserStatusFilter.inactive,
                label: 'Inactive',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FilterChipRow<UserRoleFilter>(
            selectedValue: roleFilter,
            onSelected: ref
                .read(usersControllerProvider.notifier)
                .updateRoleFilter,
            options: const [
              FilterChipOption(value: UserRoleFilter.all, label: 'All Roles'),
              FilterChipOption(value: UserRoleFilter.owner, label: 'Owner'),
              FilterChipOption(value: UserRoleFilter.user, label: 'User'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppResultSummary(count: filteredUsers.length, label: 'users'),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: usersState.when(
              loading: () => const AppLoadingView(message: 'Loading users...'),
              error: (error, stackTrace) => AppErrorState(
                message: 'Unable to load users right now.',
                onRetry: () =>
                    ref.read(usersControllerProvider.notifier).reload(),
              ),
              data: (_) {
                if (filteredUsers.isEmpty) {
                  return AppEmptyState(
                    title: searchQuery.trim().isEmpty
                        ? 'No users available'
                        : 'No matching users',
                    message: searchQuery.trim().isEmpty
                        ? 'Workspace users will appear here.'
                        : 'Try a different search or filter combination.',
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
