import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';
import '../providers/app_version_provider.dart';

class AppDrawerVersionLabel extends ConsumerWidget {
  const AppDrawerVersionLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionAsync = ref.watch(appVersionProvider);

    return versionAsync.when(
      data: (version) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${appL10n(context).versionLabel} $version',
              key: const Key('drawer_app_version_text'),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
