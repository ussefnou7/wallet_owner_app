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
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../domain/entities/app_user.dart';
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
    final roleFilter = ref.watch(usersRoleFilterProvider);
    final l10n = appL10n(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AppPageScaffold(
      title: l10n.users,
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
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.ownerUsers),
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.userDirectory,
            subtitle: l10n.userDirectorySubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppPrimaryButton(
                label: l10n.createUser,
                icon: const Icon(Icons.person_add_alt_1_rounded),
                onPressed: () => _showUserFormDialog(context),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton.outlined(
                onPressed: () => ref.read(usersControllerProvider.notifier).reload(),
                icon: const Icon(Icons.refresh_rounded),
                tooltip: l10n.refresh,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _searchController,
            label: l10n.searchUsers,
            hintText: l10n.searchUsersHint,
            prefixIcon: const Icon(Icons.search_rounded),
            onChanged: ref.read(usersControllerProvider.notifier).updateQuery,
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
                  padding: EdgeInsets.only(
                    bottom: bottomInset + AppDimensions.floatingBottomNavContentPadding,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return UserCard(
                      user: user,
                      onEdit: () => _showUserFormDialog(context, user: user),
                      onDelete: () => _confirmDeleteUser(context, user),
                      onAssignBranch: () => _showAssignBranchDialog(context, user),
                      onUnassignBranch: () => _confirmUnassignBranch(context, user),
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

  Future<void> _showUserFormDialog(
    BuildContext context, {
    AppUser? user,
  }) async {
    final l10n = appL10n(context);
    final usernameController = TextEditingController(text: user?.username ?? '');
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var active = user?.active ?? true;

    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(user == null ? l10n.createUser : l10n.editUser),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: l10n.username,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.usernameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.passwordRequired;
                        }
                        return null;
                      },
                    ),
                    if (user != null) ...[
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
      usernameController.dispose();
      passwordController.dispose();
      return;
    }

    try {
      if (user == null) {
        await ref
            .read(usersControllerProvider.notifier)
            .createUser(
              usernameController.text.trim(),
              passwordController.text,
            );
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.userCreatedSuccessfully)),
        );
      } else {
        await ref
            .read(usersControllerProvider.notifier)
            .updateUser(
              user.id,
              usernameController.text.trim(),
              passwordController.text,
              active,
            );
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.userUpdatedSuccessfully)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToLoadUsers)),
        );
      }
    } finally {
      usernameController.dispose();
      passwordController.dispose();
    }
  }

  Future<void> _confirmDeleteUser(BuildContext context, AppUser user) async {
    final l10n = appL10n(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteUser),
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
      await ref.read(usersControllerProvider.notifier).deleteUser(user.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userDeletedSuccessfully)),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToLoadUsers)),
        );
      }
    }
  }

  Future<void> _showAssignBranchDialog(BuildContext context, AppUser user) async {
    final l10n = appL10n(context);
    String? selectedBranchId = user.branchId;
    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final branchesAsync = ref.watch(branchesControllerProvider);
            return AlertDialog(
              title: Text(l10n.assignBranch),
              content: branchesAsync.when(
                data: (branches) => DropdownButtonFormField<String>(
                  initialValue: selectedBranchId,
                  decoration: InputDecoration(
                    labelText: l10n.selectBranch,
                    prefixIcon: const Icon(Icons.account_tree_outlined),
                  ),
                  items: branches
                      .map(
                        (branch) => DropdownMenuItem<String>(
                          value: branch.id,
                          child: Text(branch.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedBranchId = value);
                  },
                ),
                loading: () => AppLoadingView(message: l10n.loadingBranches),
                error: (_, stackTrace) => AppErrorState(
                  message: l10n.unableToLoadBranches,
                  compact: true,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: selectedBranchId == null
                      ? null
                      : () => Navigator.of(context).pop(true),
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted != true || selectedBranchId == null || !context.mounted) {
      return;
    }

    try {
      await ref
          .read(usersControllerProvider.notifier)
          .assignUserToBranch(user.id, selectedBranchId!);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userAssignedToBranchSuccessfully)),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToLoadUsers)),
        );
      }
    }
  }

  Future<void> _confirmUnassignBranch(BuildContext context, AppUser user) async {
    final l10n = appL10n(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.unassignBranch),
          content: Text(l10n.confirmUnassign),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.unassignBranch),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(usersControllerProvider.notifier).unassignUserFromBranch(
            user.id,
          );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userUnassignedFromBranchSuccessfully)),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.unableToLoadUsers)),
        );
      }
    }
  }
}
