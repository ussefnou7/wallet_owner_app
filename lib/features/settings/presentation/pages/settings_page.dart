import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../reports/presentation/controllers/reports_controller.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../wallets/presentation/controllers/wallets_controller.dart';
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              email: session.email,
              roleLabel: session.roleLabel,
              tenantName: session.tenantName,
            ),
            const SizedBox(height: AppSpacing.xl),
            SettingsSectionCard(
              title: l10n.account,
              subtitle: l10n.accountSubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    title: l10n.ownerName,
                    subtitle: session.displayName,
                    leading: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.email,
                    subtitle: session.email ?? l10n.notAvailable,
                    leading: const Icon(Icons.mail_outline_rounded),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.role,
                    subtitle: session.roleLabel,
                    leading: const Icon(Icons.badge_outlined),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.workspace,
                    subtitle: session.tenantName,
                    leading: const Icon(Icons.apartment_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: l10n.workspaceSubscription,
              subtitle: l10n.workspaceSubscriptionSubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    title: l10n.openPlans,
                    subtitle: l10n.openPlansSubtitle,
                    leading: const Icon(Icons.workspace_premium_outlined),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.go(AppRoutes.plans),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.requestRenewal,
                    subtitle: l10n.requestRenewalSubtitle,
                    leading: const Icon(Icons.autorenew_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.go(AppRoutes.requestRenewal),
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
                    subtitle: '${l10n.english} / العربية',
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
              title: l10n.securitySession,
              subtitle: l10n.securitySessionSubtitle,
              child: Column(
                children: [
                  SettingsActionTile(
                    title: l10n.changePassword,
                    subtitle: l10n.changePasswordSubtitle,
                    leading: const Icon(Icons.lock_outline_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showPlaceholderMessage(
                      context,
                      l10n.changePasswordComingSoon,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: l10n.session,
                    subtitle: l10n.signedInAs(
                      session.email ?? session.displayName,
                    ),
                    leading: const Icon(Icons.verified_user_outlined),
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

  void _showPlaceholderMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    _invalidateCachedProviders();

    if (!mounted) {
      return;
    }

    context.go(AppRoutes.login);
  }

  void _invalidateCachedProviders() {
    ref.invalidate(walletsControllerProvider);
    ref.invalidate(transactionsControllerProvider);
    ref.invalidate(branchesControllerProvider);
    ref.invalidate(usersControllerProvider);
    ref.invalidate(dashboardOverviewProvider);
    ref.invalidate(dashboardTransactionSummaryProvider);
    ref.invalidate(dashboardRecentTransactionsProvider);
    ref.invalidate(reportsControllerProvider);
    ref.invalidate(reportsSelectedTypeProvider);
    ref.invalidate(reportsAppliedFiltersProvider);
  }
}
