import 'dart:ui';

const Locale englishAppLocale = Locale('en');
const Locale arabicEgyptAppLocale = Locale.fromSubtags(
  languageCode: 'ar',
  countryCode: 'EG',
);

const List<Locale> supportedAppLocales = <Locale>[
  englishAppLocale,
  arabicEgyptAppLocale,
];

const String englishLocaleCode = 'en';
const String arabicEgyptLocaleCode = 'ar-EG';

Locale normalizeAppLocale(Locale locale) {
  final localeTag = locale.toLanguageTag().toLowerCase();

  if (locale.languageCode == englishLocaleCode ||
      localeTag == englishLocaleCode) {
    return englishAppLocale;
  }

  if (locale.languageCode == 'ar' ||
      localeTag == 'ar' ||
      localeTag == 'ar-eg' ||
      localeTag == 'ar_eg') {
    return arabicEgyptAppLocale;
  }

  return arabicEgyptAppLocale;
}

Locale parseStoredAppLocale(String? value) {
  final normalizedValue = value?.trim().toLowerCase();

  if (normalizedValue == englishLocaleCode) {
    return englishAppLocale;
  }

  if (normalizedValue == 'ar' ||
      normalizedValue == 'ar-eg' ||
      normalizedValue == 'ar_eg') {
    return arabicEgyptAppLocale;
  }

  return arabicEgyptAppLocale;
}

bool isSupportedAppLocale(Locale locale) {
  final normalized = normalizeAppLocale(locale);
  return normalized == englishAppLocale || normalized == arabicEgyptAppLocale;
}

bool isArabicAppLocale(Locale locale) {
  return normalizeAppLocale(locale).languageCode == 'ar';
}

String toStoredAppLocaleCode(Locale locale) {
  final normalized = normalizeAppLocale(locale);
  return normalized == englishAppLocale
      ? englishLocaleCode
      : arabicEgyptLocaleCode;
}

String toAppLanguageTag(Locale locale) {
  final normalized = normalizeAppLocale(locale);
  return normalized == englishAppLocale
      ? englishLocaleCode
      : arabicEgyptLocaleCode;
}
