import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'owner@example.com');
  final _passwordController = TextEditingController(text: 'password');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isSubmitting = authState.status == AuthStatus.loading;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Center(
              child: SingleChildScrollView(
                padding: AppDimensions.screenPadding,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.compactContentMaxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                'Sign in',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Use your owner account to access wallet controls and reporting.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              AppTextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                label: 'Email',
                                hintText: 'owner@example.com',
                                prefixIcon: const Icon(Icons.mail_outline),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppTextField(
                                controller: _passwordController,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                label: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                validator: _validatePassword,
                              ),
                              if (authState.errorMessage != null) ...[
                                const SizedBox(height: AppSpacing.md),
                                AppErrorState(
                                  message: authState.errorMessage!,
                                  compact: true,
                                ),
                              ],
                              const SizedBox(height: AppSpacing.lg),
                              SizedBox(
                                width: double.infinity,
                                child: AppPrimaryButton(
                                  label: 'Continue as Owner',
                                  isLoading: isSubmitting,
                                  onPressed: _submit,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Phase 2 still uses a mock session and local storage only.',
                                style: Theme.of(context).textTheme.bodySmall,
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
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@')) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.trim().length < 4) {
      return 'Password is too short';
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
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }
}

class _LoginBrandHeader extends StatelessWidget {
  const _LoginBrandHeader();

  @override
  Widget build(BuildContext context) {
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
        Text('Wallet Owner', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Mobile access for owner-level wallet oversight, transaction recording, and reporting.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
