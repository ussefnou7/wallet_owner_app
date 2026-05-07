import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_result_summary.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/filter_chip_row.dart';
import '../../../../core/widgets/icon_action_button.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../branches/domain/entities/branch.dart';
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
  final Set<String> _unassigningUserIds = <String>{};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(usersSearchQueryProvider),
    );
    Future<void>.microtask(
      () => ref.read(branchesControllerProvider.notifier).ensureLoaded(),
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
    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight;

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
              Expanded(
                child: AppTextField(
                  controller: _searchController,
                  label: l10n.searchUsers,
                  hintText: l10n.searchUsersHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  onChanged: ref
                      .read(usersControllerProvider.notifier)
                      .updateQuery,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconActionButton(
                icon: Icons.refresh_rounded,
                tooltip: l10n.refresh,
                onPressed: usersState.isLoading
                    ? null
                    : () => ref.read(usersControllerProvider.notifier).reload(),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconActionButton(
                icon: Icons.add_rounded,
                tooltip: l10n.createUser,
                filled: true,
                onPressed: () => _showUserFormDialog(context),
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
                  padding: EdgeInsets.only(bottom: bottomContentPadding),
                  itemCount: filteredUsers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return UserCard(
                      user: user,
                      onEdit: () => _showUserFormDialog(context, user: user),
                      onDelete: () => _confirmDeleteUser(context, user),
                      onAssignBranch: () =>
                          _showAssignBranchDialog(context, user),
                      onUnassignBranch: () =>
                          _confirmUnassignBranch(context, user),
                      isUnassigning: _unassigningUserIds.contains(user.id),
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
    final action = await showDialog<_UserFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _UserFormDialog(user: user),
    );

    if (action == null || !context.mounted) {
      return;
    }

    final l10n = appL10n(context);
    switch (action) {
      case _UserFormResult.created:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.userCreatedSuccessfully)));
      case _UserFormResult.updated:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.userUpdatedSuccessfully)));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.userDeletedSuccessfully)));
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMessageMapper.getMessage(error))),
        );
      }
    }
  }

  Future<void> _showAssignBranchDialog(
    BuildContext context,
    AppUser user,
  ) async {
    unawaited(ref.read(branchesControllerProvider.notifier).ensureLoaded());

    final submitted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AssignBranchDialog(user: user),
    );

    if (submitted != true || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appL10n(context).userAssignedToBranchSuccessfully),
      ),
    );
  }

  Future<void> _confirmUnassignBranch(
    BuildContext context,
    AppUser user,
  ) async {
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

    setState(() {
      _unassigningUserIds.add(user.id);
    });

    try {
      await ref
          .read(usersControllerProvider.notifier)
          .unassignUserFromBranch(user.id);
      await ref.read(branchesControllerProvider.notifier).reload();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userUnassignedFromBranchSuccessfully)),
      );
    } on AppException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMessageMapper.getMessage(error))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _unassigningUserIds.remove(user.id);
        });
      }
    }
  }
}

enum _UserFormResult { created, updated }

class _UserFormDialog extends ConsumerStatefulWidget {
  const _UserFormDialog({this.user});

  final AppUser? user;

  @override
  ConsumerState<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late bool _active;
  bool _isSubmitting = false;
  AppException? _submitError;

  bool get _isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.user?.username ?? '',
    );
    _passwordController = TextEditingController();
    _active = widget.user?.active ?? true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return PopScope(
      canPop: !_isSubmitting,
      child: _StyledDialog(
        title: _isEditMode ? l10n.editUser : l10n.createUser,
        actions: _DialogActions(
          cancelLabel: l10n.cancel,
          confirmLabel: l10n.save,
          isBusy: _isSubmitting,
          onCancel: _cancel,
          onConfirm: _submit,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _usernameController,
                label: l10n.username,
                prefixIcon: const Icon(Icons.person_outline_rounded),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.usernameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _passwordController,
                label: l10n.password,
                hintText: _isEditMode ? l10n.password_optional_hint : null,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                textInputAction: TextInputAction.done,
                obscureText: true,
                validator: (value) {
                  if (!_isEditMode && (value == null || value.isEmpty)) {
                    return l10n.passwordRequired;
                  }
                  return null;
                },
              ),
              if (_isEditMode) ...[
                const SizedBox(height: AppSpacing.md),
                _DialogToggleCard(
                  label: l10n.active,
                  value: _active,
                  onChanged: (value) {
                    setState(() => _active = value);
                  },
                ),
              ],
              if (_submitError != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppErrorState(
                  key: const Key('user_inline_error'),
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
    );
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final notifier = ref.read(usersControllerProvider.notifier);
      if (_isEditMode) {
        await notifier.updateUser(
          widget.user!.id,
          _usernameController.text.trim(),
          _passwordController.text.trim(),
          _active,
        );
      } else {
        await notifier.createUser(
          _usernameController.text.trim(),
          _passwordController.text,
        );
      }

      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).pop(_isEditMode ? _UserFormResult.updated : _UserFormResult.created);
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
        _submitError = error;
      });
    }
  }
}

class _AssignBranchDialog extends ConsumerStatefulWidget {
  const _AssignBranchDialog({required this.user});

  final AppUser user;

  @override
  ConsumerState<_AssignBranchDialog> createState() =>
      _AssignBranchDialogState();
}

class _AssignBranchDialogState extends ConsumerState<_AssignBranchDialog> {
  String? _selectedBranchId;
  bool _isSubmitting = false;
  AppException? _submitError;

  @override
  void initState() {
    super.initState();
    _selectedBranchId = widget.user.branchId;
    Future<void>.microtask(
      () => ref.read(branchesControllerProvider.notifier).ensureLoaded(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchesControllerProvider);
    final l10n = appL10n(context);
    final branches = branchesAsync.asData?.value ?? const <Branch>[];
    final selectedBranchId =
        _selectedBranchId != null &&
            branches.isNotEmpty &&
            !branches.any((branch) => branch.id == _selectedBranchId)
        ? null
        : _selectedBranchId;

    final canSubmit =
        !_isSubmitting &&
        !branchesAsync.isLoading &&
        selectedBranchId != null &&
        branches.isNotEmpty;

    return PopScope(
      canPop: !_isSubmitting,
      child: _StyledDialog(
        title: l10n.assignBranch,
        actions: _DialogActions(
          cancelLabel: l10n.cancel,
          confirmLabel: l10n.save,
          isBusy: _isSubmitting,
          isConfirmEnabled: canSubmit,
          onCancel: () => Navigator.of(context).pop(false),
          onConfirm: _submit,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AssignBranchBody(
              branchesAsync: branchesAsync,
              selectedBranchId: selectedBranchId,
              onChanged: _isSubmitting
                  ? null
                  : (value) => setState(() => _selectedBranchId = value),
              onRetry: () =>
                  ref.read(branchesControllerProvider.notifier).reload(),
            ),
            if (_submitError != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppErrorState(
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
    );
  }

  Future<void> _submit() async {
    final branchId = _selectedBranchId;
    if (branchId == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref
          .read(usersControllerProvider.notifier)
          .assignUserToBranch(widget.user.id, branchId);

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
        _submitError = error;
      });
    }
  }
}

class _AssignBranchBody extends StatelessWidget {
  const _AssignBranchBody({
    required this.branchesAsync,
    required this.selectedBranchId,
    required this.onChanged,
    required this.onRetry,
  });

  final AsyncValue<List<Branch>> branchesAsync;
  final String? selectedBranchId;
  final ValueChanged<String?>? onChanged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return branchesAsync.when(
      loading: () => SizedBox(
        height: 160,
        child: AppLoadingView(message: l10n.loadingBranches),
      ),
      error: (_, stackTrace) =>
          AppErrorState(message: l10n.failedToLoadBranches, onRetry: onRetry),
      data: (branches) {
        if (branches.isEmpty) {
          return const _DialogInfoState(
            icon: Icons.account_tree_outlined,
            titleKey: 'noBranches',
          );
        }

        return DropdownButtonFormField<String>(
          initialValue: selectedBranchId,
          isExpanded: true,
          menuMaxHeight: 320,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: l10n.selectBranch,
            prefixIcon: const Icon(Icons.account_tree_outlined),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
          items: branches
              .map(
                (branch) => DropdownMenuItem<String>(
                  value: branch.id,
                  child: Text(branch.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}

class _StyledDialog extends StatelessWidget {
  const _StyledDialog({
    required this.title,
    required this.child,
    required this.actions,
  });

  final String title;
  final Widget child;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(child: child),
      ),
      actions: [actions],
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.isBusy,
    required this.onCancel,
    required this.onConfirm,
    this.isConfirmEnabled = true,
  });

  final String cancelLabel;
  final String confirmLabel;
  final bool isBusy;
  final bool isConfirmEnabled;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isBusy ? null : onCancel,
              child: Text(cancelLabel),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: FilledButton(
              onPressed: isBusy || !isConfirmEnabled ? null : onConfirm,
              child: isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(confirmLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogToggleCard extends StatelessWidget {
  const _DialogToggleCard({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleSmall),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _DialogInfoState extends StatelessWidget {
  const _DialogInfoState({required this.icon, required this.titleKey});

  final IconData icon;
  final String titleKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = appL10n(context);
    final title = switch (titleKey) {
      'noBranches' => l10n.noBranchesAvailable,
      _ => '',
    };
    final message = switch (titleKey) {
      'noBranches' => l10n.branchesEmptyMessage,
      _ => '',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
