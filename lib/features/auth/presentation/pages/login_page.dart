import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  static const _forgotPasswordSubmittedResponseMsg =
      'If the account exists, a reset request has been submitted.';

  final _loginFormKey = GlobalKey<FormState>();
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameControllerForReset = TextEditingController();
  bool _showPassword = false;
  bool _showForgotPasswordForm = false;
  bool _isSubmittingForgotPassword = false;
  Object? _forgotPasswordError;

  late AnimationController _logoAnimationController;
  late AnimationController _descriptionAnimationController;
  late AnimationController _cardAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _descriptionFadeAnimation;
  late Animation<Offset> _descriptionSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _descriptionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _descriptionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _descriptionAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _descriptionSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _descriptionAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _cardAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  void _startAnimations() {
    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _descriptionAnimationController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _cardAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameControllerForReset.dispose();
    _logoAnimationController.dispose();
    _descriptionAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isSubmitting = authState.status == AuthStatus.loading;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final l10n = appL10n(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = (screenWidth * 0.75).clamp(280.0, 340.0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFE0F4FF)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset + AppSpacing.md),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          _AnimatedLogo(
                            scaleAnimation: _logoScaleAnimation,
                            fadeAnimation: _logoFadeAnimation,
                            logoWidth: logoWidth,
                          ),
                          const SizedBox(height: 0),
                          _AnimatedDescription(
                            fadeAnimation: _descriptionFadeAnimation,
                            slideAnimation: _descriptionSlideAnimation,
                          ),
                          const SizedBox(height: 12),
                          _AnimatedLoginCard(
                            fadeAnimation: _cardFadeAnimation,
                            slideAnimation: _cardSlideAnimation,
                            loginFormKey: _loginFormKey,
                            forgotPasswordFormKey: _forgotPasswordFormKey,
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                            usernameControllerForReset:
                                _usernameControllerForReset,
                            authState: authState,
                            isSubmitting: isSubmitting,
                            isSubmittingForgotPassword:
                                _isSubmittingForgotPassword,
                            forgotPasswordError: _forgotPasswordError,
                            showForgotPasswordForm: _showForgotPasswordForm,
                            showPassword: _showPassword,
                            onShowPasswordChanged: (value) {
                              setState(() => _showPassword = value);
                            },
                            onSubmit: _submit,
                            onForgotPasswordPressed: _openForgotPasswordForm,
                            onBackToLoginPressed: _backToLogin,
                            onForgotPasswordSubmit: _submitForgotPassword,
                            l10n: l10n,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_loginFormKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _openForgotPasswordForm() {
    FocusScope.of(context).unfocus();
    setState(() {
      _showForgotPasswordForm = true;
      _forgotPasswordError = null;
    });
  }

  void _backToLogin() {
    FocusScope.of(context).unfocus();
    setState(() {
      _showForgotPasswordForm = false;
      _forgotPasswordError = null;
    });
  }

  Future<void> _submitForgotPassword() async {
    FocusScope.of(context).unfocus();

    if (_forgotPasswordFormKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmittingForgotPassword = true;
      _forgotPasswordError = null;
    });

    try {
      final responseMessage = await ref
          .read(authRepositoryProvider)
          .forgotPassword(
            username: _usernameControllerForReset.text.trim(),
          );

      if (!mounted) {
        return;
      }

      final l10n = appL10n(context);
      final resolvedMessage = _resolveForgotPasswordResponseMessage(
        l10n,
        responseMessage,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(resolvedMessage)));

      setState(() {
        _showForgotPasswordForm = false;
        _usernameControllerForReset.clear();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _forgotPasswordError = error);
    } finally {
      if (mounted) {
        setState(() => _isSubmittingForgotPassword = false);
      }
    }
  }

  String _resolveForgotPasswordResponseMessage(
    AppLocalizations l10n,
    String? responseMessage,
  ) {
    final trimmedMessage = responseMessage?.trim();
    if (trimmedMessage == null || trimmedMessage.isEmpty) {
      return l10n.resetRequestSubmittedFallback;
    }

    if (trimmedMessage == _forgotPasswordSubmittedResponseMsg) {
      return l10n.resetRequestSubmittedFallback;
    }

    return trimmedMessage;
  }
}

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.logoWidth,
  });

  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scaleAnimation, fadeAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Image.asset(
              'assets/images/logo.png',
              width: logoWidth,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedDescription extends StatelessWidget {
  const _AnimatedDescription({
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnimation, slideAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: SlideTransition(
            position: slideAnimation,
            child: Text(
              appL10n(context).loginHeroSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedLoginCard extends StatelessWidget {
  const _AnimatedLoginCard({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.loginFormKey,
    required this.forgotPasswordFormKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameControllerForReset,
    required this.authState,
    required this.isSubmitting,
    required this.isSubmittingForgotPassword,
    required this.forgotPasswordError,
    required this.showForgotPasswordForm,
    required this.showPassword,
    required this.onShowPasswordChanged,
    required this.onSubmit,
    required this.onForgotPasswordPressed,
    required this.onBackToLoginPressed,
    required this.onForgotPasswordSubmit,
    required this.l10n,
  });

  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final GlobalKey<FormState> loginFormKey;
  final GlobalKey<FormState> forgotPasswordFormKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController usernameControllerForReset;
  final AuthState authState;
  final bool isSubmitting;
  final bool isSubmittingForgotPassword;
  final Object? forgotPasswordError;
  final bool showForgotPasswordForm;
  final bool showPassword;
  final ValueChanged<bool> onShowPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onBackToLoginPressed;
  final VoidCallback onForgotPasswordSubmit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnimation, slideAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: SlideTransition(
            position: slideAnimation,
            child: _LoginCard(
              loginFormKey: loginFormKey,
              forgotPasswordFormKey: forgotPasswordFormKey,
              usernameController: usernameController,
              passwordController: passwordController,
              usernameControllerForReset: usernameControllerForReset,
              authState: authState,
              isSubmitting: isSubmitting,
              isSubmittingForgotPassword: isSubmittingForgotPassword,
              forgotPasswordError: forgotPasswordError,
              showForgotPasswordForm: showForgotPasswordForm,
              showPassword: showPassword,
              onShowPasswordChanged: onShowPasswordChanged,
              onSubmit: onSubmit,
              onForgotPasswordPressed: onForgotPasswordPressed,
              onBackToLoginPressed: onBackToLoginPressed,
              onForgotPasswordSubmit: onForgotPasswordSubmit,
              l10n: l10n,
            ),
          ),
        );
      },
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.loginFormKey,
    required this.forgotPasswordFormKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameControllerForReset,
    required this.authState,
    required this.isSubmitting,
    required this.isSubmittingForgotPassword,
    required this.forgotPasswordError,
    required this.showForgotPasswordForm,
    required this.showPassword,
    required this.onShowPasswordChanged,
    required this.onSubmit,
    required this.onForgotPasswordPressed,
    required this.onBackToLoginPressed,
    required this.onForgotPasswordSubmit,
    required this.l10n,
  });

  final GlobalKey<FormState> loginFormKey;
  final GlobalKey<FormState> forgotPasswordFormKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController usernameControllerForReset;
  final AuthState authState;
  final bool isSubmitting;
  final bool isSubmittingForgotPassword;
  final Object? forgotPasswordError;
  final bool showForgotPasswordForm;
  final bool showPassword;
  final ValueChanged<bool> onShowPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onBackToLoginPressed;
  final VoidCallback onForgotPasswordSubmit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: showForgotPasswordForm ? forgotPasswordFormKey : loginFormKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          child: showForgotPasswordForm
              ? _ForgotPasswordForm(
                  key: const ValueKey('forgot_password_form'),
                  controller: usernameControllerForReset,
                  isSubmitting: isSubmittingForgotPassword,
                  error: forgotPasswordError,
                  onSubmit: onForgotPasswordSubmit,
                  onBackToLoginPressed: onBackToLoginPressed,
                  l10n: l10n,
                )
              : _LoginForm(
                  key: const ValueKey('login_form'),
                  usernameController: usernameController,
                  passwordController: passwordController,
                  authState: authState,
                  isSubmitting: isSubmitting,
                  showPassword: showPassword,
                  onShowPasswordChanged: onShowPasswordChanged,
                  onSubmit: onSubmit,
                  onForgotPasswordPressed: onForgotPasswordPressed,
                  l10n: l10n,
                ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.usernameController,
    required this.passwordController,
    required this.authState,
    required this.isSubmitting,
    required this.showPassword,
    required this.onShowPasswordChanged,
    required this.onSubmit,
    required this.onForgotPasswordPressed,
    required this.l10n,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthState authState;
  final bool isSubmitting;
  final bool showPassword;
  final ValueChanged<bool> onShowPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPasswordPressed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.signIn,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.signInSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        _AuthTextField(
          controller: usernameController,
          label: l10n.username,
          hint: l10n.usernamePlaceholder,
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.usernameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _AuthPasswordField(
          controller: passwordController,
          label: l10n.password,
          hint: l10n.passwordPlaceholder,
          showPassword: showPassword,
          onToggleVisibility: onShowPasswordChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.passwordRequired;
            }
            if (value.trim().length < 4) {
              return l10n.passwordTooShort;
            }
            return null;
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: isSubmitting ? null : onForgotPasswordPressed,
            child: Text(l10n.forgotPassword),
          ),
        ),
        if (authState.error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _InlineErrorBanner(
            message: ErrorMessageMapper.getLocalizedMessage(
              context,
              authState.error,
            ),
            bannerKey: const Key('login_inline_error'),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        _PrimaryGradientButton(
          label: l10n.login,
          isLoading: isSubmitting,
          onTap: onSubmit,
        ),
      ],
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm({
    required this.controller,
    required this.isSubmitting,
    required this.error,
    required this.onSubmit,
    required this.onBackToLoginPressed,
    required this.l10n,
    super.key,
  });

  final TextEditingController controller;
  final bool isSubmitting;
  final Object? error;
  final VoidCallback onSubmit;
  final VoidCallback onBackToLoginPressed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.forgotPasswordTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: isSubmitting ? null : onBackToLoginPressed,
              child: Text(l10n.backToLogin),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.forgotPasswordSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        _AuthTextField(
          controller: controller,
          label: l10n.username,
          hint: l10n.usernamePlaceholder,
          icon: Icons.alternate_email_rounded,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.usernameRequired;
            }
            return null;
          },
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.md),
          _InlineErrorBanner(
            message: ErrorMessageMapper.getLocalizedMessage(
              context,
              error,
              fallbackMessage: l10n.unableToSubmitResetRequest,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _PrimaryGradientButton(
          label: l10n.submitResetRequest,
          isLoading: isSubmitting,
          onTap: onSubmit,
        ),
      ],
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          textInputAction: TextInputAction.next,
          validator: validator,
          decoration: _authInputDecoration(
            context,
            hint: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _AuthPasswordField extends StatelessWidget {
  const _AuthPasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.showPassword,
    required this.onToggleVisibility,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool showPassword;
  final ValueChanged<bool> onToggleVisibility;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          obscureText: !showPassword,
          textInputAction: TextInputAction.done,
          validator: validator,
          decoration: _authInputDecoration(
            context,
            hint: hint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: GestureDetector(
              onTap: () => onToggleVisibility(!showPassword),
              child: Icon(
                showPassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

InputDecoration _authInputDecoration(
  BuildContext context, {
  required String hint,
  required Widget prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFEF4444)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
    ),
    filled: true,
    fillColor: const Color(0xFFFAFAFA),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    hintStyle: Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
  );
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({required this.message, this.bannerKey});

  final String message;
  final Key? bannerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bannerKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: const Color(0xFFB71C1C)),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isLoading ? null : onTap,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
