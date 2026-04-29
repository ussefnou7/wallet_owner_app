import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../reports/presentation/controllers/reports_controller.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../wallets/presentation/controllers/wallets_controller.dart';
import '../controllers/auth_controller.dart';

class UnauthorizedRolePage extends ConsumerWidget {
  const UnauthorizedRolePage({super.key});

  void _invalidateCachedProviders(WidgetRef ref) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    final roleLabel = session?.roleLabel ?? 'UNKNOWN';
    final l10n = appL10n(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.dangerSoft,
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                    ),
                    child: const Icon(
                      Icons.block_rounded,
                      color: AppColors.danger,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.unsupportedAccountRole,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.unsupportedAccountRoleMessage(roleLabel),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      label: l10n.signOut,
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                        _invalidateCachedProviders(ref);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
