import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../plans/presentation/controllers/plans_controller.dart';
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
    final plansState = ref.watch(plansControllerProvider);

    if (session == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Loading settings...'),
      );
    }

    return AppPageScaffold(
      title: 'Settings',
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
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: '',
        onDestinationSelected: context.go,
      ),
      maxWidth: AppDimensions.contentMaxWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeader(
              title: 'Owner Settings',
              subtitle:
                  'Review account identity, workspace status, app preferences, and session actions from one place.',
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
              title: 'Account',
              subtitle: 'Current owner identity and workspace assignment.',
              child: Column(
                children: [
                  SettingsActionTile(
                    title: 'Owner name',
                    subtitle: session.displayName,
                    leading: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: 'Email',
                    subtitle: session.email ?? 'Not available',
                    leading: const Icon(Icons.mail_outline_rounded),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: 'Role',
                    subtitle: session.roleLabel,
                    leading: const Icon(Icons.badge_outlined),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: 'Workspace',
                    subtitle: session.tenantName,
                    leading: const Icon(Icons.apartment_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            plansState.when(
              loading: () => const AppLoadingView(
                message: 'Loading workspace subscription...',
              ),
              error: (error, stackTrace) => AppErrorState(
                message: 'Unable to load subscription summary right now.',
                onRetry: () =>
                    ref.read(plansControllerProvider.notifier).reload(),
              ),
              data: (catalog) {
                final summary = catalog.currentSubscription;
                return SettingsSectionCard(
                  title: 'Workspace & Subscription',
                  subtitle: 'Read-only workspace subscription overview.',
                  child: Column(
                    children: [
                      SettingsActionTile(
                        title: 'Current plan',
                        subtitle: summary.planName,
                        leading: const Icon(Icons.workspace_premium_outlined),
                        trailing: AppStatusBadge(label: summary.statusLabel),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SettingsActionTile(
                        title: 'Renewal date',
                        subtitle: formatDate(summary.renewalDate),
                        leading: const Icon(Icons.event_outlined),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SettingsActionTile(
                        title: 'Workspace',
                        subtitle: session.tenantName,
                        leading: const Icon(Icons.business_outlined),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SettingsActionTile(
                        title: 'Open Plans',
                        subtitle: 'Review available plan tiers and limits.',
                        leading: const Icon(Icons.open_in_new_rounded),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go(AppRoutes.plans),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SettingsActionTile(
                        title: 'Request Renewal',
                        subtitle: 'Send a mock renewal or upgrade request.',
                        leading: const Icon(Icons.autorenew_rounded),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go(AppRoutes.requestRenewal),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: 'Preferences',
              subtitle: 'Lightweight app preferences for this frontend phase.',
              child: Column(
                children: [
                  SettingsActionTile(
                    title: 'Notifications',
                    subtitle: _notificationsEnabled
                        ? 'Enabled for mock owner alerts'
                        : 'Disabled for mock owner alerts',
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
                    title: 'Theme',
                    subtitle: 'System default',
                    leading: const Icon(Icons.palette_outlined),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showPlaceholderMessage(
                      context,
                      'Theme settings will be added after backend integration planning.',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: const Icon(Icons.language_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showPlaceholderMessage(
                      context,
                      'Language switching will be added in a later phase.',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const SettingsActionTile(
                    title: 'App version',
                    subtitle: '1.0.0+1',
                    leading: Icon(Icons.info_outline_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsSectionCard(
              title: 'Security & Session',
              subtitle: 'Mock account security actions and session controls.',
              child: Column(
                children: [
                  SettingsActionTile(
                    title: 'Change password',
                    subtitle: 'Available later with backend integration.',
                    leading: const Icon(Icons.lock_outline_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showPlaceholderMessage(
                      context,
                      'Password management will be connected in a later phase.',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: 'Session',
                    subtitle:
                        'Signed in as ${session.email ?? session.displayName}',
                    leading: const Icon(Icons.verified_user_outlined),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsActionTile(
                    title: 'Logout',
                    subtitle: 'Sign out from the current owner session.',
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
    if (!mounted) {
      return;
    }

    context.go(AppRoutes.login);
  }
}
