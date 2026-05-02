import 'package:flutter/material.dart';

import '../../../../core/localization/app_l10n.dart';
import 'legal_content_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return LegalContentPage(
      title: l10n.privacyPolicy,
      subtitle: l10n.privacyPolicySubtitle,
      sections: [
        LegalContentSection(
          title: l10n.privacyCollectionTitle,
          body: l10n.privacyCollectionBody,
        ),
        LegalContentSection(
          title: l10n.privacyUsageTitle,
          body: l10n.privacyUsageBody,
        ),
        LegalContentSection(
          title: l10n.privacySecurityTitle,
          body: l10n.privacySecurityBody,
        ),
      ],
    );
  }
}
