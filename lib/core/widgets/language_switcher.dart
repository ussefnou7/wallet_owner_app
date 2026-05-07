import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_radii.dart';
import '../localization/app_l10n.dart';
import '../localization/app_locale.dart';
import '../localization/locale_controller.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final l10n = appL10n(context);

    return SegmentedButton<Locale>(
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      segments: [
        ButtonSegment(value: englishAppLocale, label: Text(l10n.english)),
        ButtonSegment(value: arabicEgyptAppLocale, label: Text(l10n.arabic)),
      ],
      selected: {normalizeAppLocale(locale)},
      onSelectionChanged: (selection) {
        ref.read(localeControllerProvider.notifier).setLocale(selection.first);
      },
    );
  }
}
