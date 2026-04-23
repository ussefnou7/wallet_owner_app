import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

AppLocalizations appL10n(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}
