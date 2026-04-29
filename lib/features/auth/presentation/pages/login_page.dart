import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../reports/presentation/controllers/reports_controller.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../wallets/presentation/controllers/wallets_controller.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isSubmitting = authState.status == AuthStatus.loading;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final screenPadding = AppDimensions.screenPadding.resolve(
      Directionality.of(context),
    );
    final l10n = appL10n(context);

    ref.listen(authControllerProvider, (previous, current) {
      if (current.status == AuthStatus.authenticated) {
        _invalidateCachedProviders();
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(
                  screenPadding.left,
                  screenPadding.top,
                  screenPadding.right,
                  screenPadding.bottom + bottomInset,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimensions.compactContentMaxWidth,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: LanguageSwitcher(),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const _LoginBrandHeader(),
                          const SizedBox(height: AppSpacing.xl),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadii.xl),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppShadows.card,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.signIn,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    l10n.signInSubtitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  AppTextField(
                                    controller: _usernameController,
                                    textInputAction: TextInputAction.next,
                                    label: l10n.username,
                                    hintText: l10n.usernamePlaceholder,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                    validator: (value) =>
                                        _validateUsername(value, l10n),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  AppTextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    label: l10n.password,
                                    hintText: l10n.passwordPlaceholder,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    validator: (value) =>
                                        _validatePassword(value, l10n),
                                  ),
                                  if (authState.error != null) ...[
                                    const SizedBox(height: AppSpacing.md),
                                    AppErrorState(
                                      key: const Key('login_inline_error'),
                                      message:
                                          ErrorMessageMapper.getLocalizedMessage(
                                            context,
                                            authState.error,
                                          ),
                                      compact: true,
                                    ),
                                  ],
                                  const SizedBox(height: AppSpacing.lg),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AppPrimaryButton(
                                      label: l10n.login,
                                      isLoading: isSubmitting,
                                      onPressed: _submit,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    l10n.authStorageNote,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? _validateUsername(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.usernameRequired;
    }

    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.passwordRequired;
    }

    if (value.trim().length < 4) {
      return l10n.passwordTooShort;
    }

    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
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

class _LoginBrandHeader extends StatelessWidget {
  const _LoginBrandHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: AppDimensions.iconLg,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.appName, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.loginHeroSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
