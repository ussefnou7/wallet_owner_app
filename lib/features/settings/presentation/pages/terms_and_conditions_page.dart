import 'package:flutter/material.dart';

import '../../../../core/localization/app_l10n.dart';
import 'legal_content_page.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return LegalContentPage(
      title: l10n.termsAndConditions,
      subtitle: l10n.termsAndConditionsSubtitle,
      sections: [
        LegalContentSection(
          title: l10n.termsAcceptanceTitle,
          body: l10n.termsAcceptanceBody,
        ),
        LegalContentSection(
          title: l10n.termsUsageTitle,
          body: l10n.termsUsageBody,
        ),
        LegalContentSection(
          title: l10n.termsResponsibilityTitle,
          body: l10n.termsResponsibilityBody,
        ),
      ],
    );
  }
}
