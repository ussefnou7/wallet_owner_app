import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_l10n.dart';
import '../../../../core/providers/app_version_provider.dart';
import 'legal_content_page.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = appL10n(context);
    final version = ref.watch(
      appVersionProvider.select((value) => value.valueOrNull ?? '1.0.0'),
    );

    return LegalContentPage(
      title: l10n.aboutTa2feela,
      subtitle: l10n.aboutTa2feelaSubtitle,
      sections: [
        LegalContentSection(
          title: l10n.aboutOverviewTitle,
          body: l10n.aboutOverviewBody,
        ),
        LegalContentSection(
          title: l10n.aboutMissionTitle,
          body: l10n.aboutMissionBody,
        ),
        LegalContentSection(
          title: l10n.aboutContactTitle,
          body: l10n.aboutContactBody(version),
        ),
      ],
    );
  }
}
