import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/domain/entities/session.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/settings_action_tile.dart';
import '../widgets/settings_profile_card.dart';
import '../widgets/settings_section_card.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).session;
    final l10n = appL10n(context);

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final workspaceName = session.tenantDisplayName.trim();
    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight;

    return AppPageScaffold(
      title: l10n.settings,
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
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.settings),
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomContentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: l10n.ownerSettings,
              subtitle: l10n.ownerSettingsSubtitle,
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsProfileCard(
              name: session.displayName,
              roleLabel: _localizedRoleLabel(session, l10n),
              tenantName: workspaceName.isEmpty ? null : workspaceName,
              workspaceLabel: l10n.workspace,
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: l10n.subscriptionAndPlans,
              subtitle: l10n.subscriptionAndPlansSubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    key: const Key('browse_plans_tile'),
                    title: l10n.browsePlans,
                    subtitle: l10n.browsePlansSubtitle,
                    leading: const Icon(Icons.workspace_premium_outlined),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.plans),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    key: const Key('request_renewal_tile'),
                    title: l10n.requestRenewal,
                    subtitle: l10n.requestRenewalSubtitle,
                    leading: const Icon(Icons.autorenew_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.requestRenewal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: l10n.preferences,
              subtitle: l10n.preferencesSubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    title: l10n.notifications,
                    subtitle: _notificationsEnabled
                        ? l10n.notificationsEnabledSubtitle
                        : l10n.notificationsDisabledSubtitle,
                    leading: const Icon(Icons.notifications_outlined),
                    trailing: Switch.adaptive(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                    onTap: () {
                      setState(
                        () => _notificationsEnabled = !_notificationsEnabled,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.theme,
                    subtitle: l10n.systemDefault,
                    leading: const Icon(Icons.palette_outlined),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        _showPlaceholderMessage(context, l10n.themeComingSoon),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.language,
                    subtitle: '${l10n.english} / ${l10n.arabic}',
                    leading: const Icon(Icons.language_rounded),
                    trailing: const LanguageSwitcher(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.appVersion,
                    subtitle: '1.0.0+1',
                    leading: const Icon(Icons.info_outline_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: l10n.legalInformation,
              subtitle: l10n.legalInformationSubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    key: const Key('about_page_tile'),
                    title: l10n.aboutTa2feela,
                    subtitle: l10n.aboutTa2feelaSubtitle,
                    leading: const Icon(Icons.info_outline_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.about),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    key: const Key('privacy_policy_page_tile'),
                    title: l10n.privacyPolicy,
                    subtitle: l10n.privacyPolicySubtitle,
                    leading: const Icon(Icons.privacy_tip_outlined),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.privacyPolicy),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    key: const Key('terms_and_conditions_page_tile'),
                    title: l10n.termsAndConditions,
                    subtitle: l10n.termsAndConditionsSubtitle,
                    leading: const Icon(Icons.gavel_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoutes.termsAndConditions),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: l10n.security,
              subtitle: l10n.securitySubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    key: const Key('change_password_tile'),
                    title: l10n.changePassword,
                    subtitle: l10n.changePasswordSubtitle,
                    leading: const Icon(Icons.lock_outline_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showChangePasswordSheet(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    key: const Key('logout_button'),
                    title: l10n.logout,
                    subtitle: l10n.logoutSubtitle,
                    leading: const Icon(Icons.logout_rounded),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.danger,
                    ),
                    foregroundColor: AppColors.danger,
                    onTap: _signOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _localizedRoleLabel(Session session, AppLocalizations l10n) {
    return switch (session.role) {
      UserRole.owner => l10n.owner,
      UserRole.user => l10n.user,
      UserRole.unknown => session.roleLabel,
    };
  }

  void _showPlaceholderMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showChangePasswordSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: _ChangePasswordSheet(
            onSubmit: ({required currentPassword, required newPassword}) {
              return ref
                  .read(authRepositoryProvider)
                  .changePassword(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                  );
            },
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();

    if (!mounted) {
      return;
    }

    context.go(AppRoutes.login);
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet({required this.onSubmit});

  final Future<void> Function({
    required String currentPassword,
    required String newPassword,
  })
  onSubmit;

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const BackButtonIcon(),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.changePassword,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.changePasswordSheetSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.currentPassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.currentPasswordRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.newPassword,
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.newPasswordRequired;
                  }
                  if (value.trim().length < 8) {
                    return l10n.newPasswordMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.confirmPassword,
                  prefixIcon: const Icon(Icons.verified_user_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.confirmPasswordRequired;
                  }
                  if (value != _newPasswordController.text) {
                    return l10n.confirmPasswordMismatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      label: l10n.cancel,
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppPrimaryButton(
                      label: l10n.save,
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = appL10n(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordChangedSuccessfully)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorMessageMapper.getLocalizedMessage(context, error)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
