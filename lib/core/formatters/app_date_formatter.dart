import 'package:intl/intl.dart';

/// Centralized date/time formatter supporting English and Arabic locales.
///
/// All methods require explicit locale input and do NOT rely on `Intl.defaultLocale`.
/// Supported locales: 'en', 'ar'. Any other locale defaults to 'en'.
///
/// Usage:
/// ```dart
/// final locale = Localizations.localeOf(context).languageCode;
/// final formatted = AppDateFormatter.smart(date, locale: locale);
/// ```
class AppDateFormatter {
  /// Returns time only in HH:MM AM/PM format.
  ///
  /// Examples:
  /// - English: "01:20 AM"
  /// - Arabic: "01:20 ص"
  static String timeOnly(DateTime date, {required String locale}) {
    final normalizedLocale = _normalizeLocale(locale);
    return DateFormat('hh:mm a', normalizedLocale).format(date);
  }

  /// Returns compact format (no year if current year).
  ///
  /// Examples:
  /// - English: "May 1 • 01:20 AM"
  /// - Arabic: "1 مايو • 01:20 ص"
  static String compact(DateTime date, {required String locale}) {
    final normalizedLocale = _normalizeLocale(locale);

    if (normalizedLocale == 'ar') {
      final day = DateFormat('d', 'en').format(date);
      final month = DateFormat('MMMM', 'ar').format(date);
      final time = DateFormat('hh:mm a', 'ar').format(date);
      return '$day $month • $time';
    }

    // English: "May 1 • 01:20 AM"
    final monthDay = DateFormat('MMM d', 'en').format(date);
    final time = DateFormat('hh:mm a', 'en').format(date);
    return '$monthDay • $time';
  }

  /// Returns full format with year.
  ///
  /// Examples:
  /// - English: "May 1, 2025 • 01:20 AM"
  /// - Arabic: "1 مايو، 2025 • 01:20 ص"
  static String full(DateTime date, {required String locale}) {
    final normalizedLocale = _normalizeLocale(locale);

    if (normalizedLocale == 'ar') {
      final day = DateFormat('d', 'en').format(date);
      final month = DateFormat('MMMM', 'ar').format(date);
      final year = DateFormat('yyyy', 'en').format(date);
      final time = DateFormat('hh:mm a', 'ar').format(date);
      return '$day $month، $year • $time';
    }

    // English: "May 1, 2025 • 01:20 AM"
    final monthDay = DateFormat('MMM d', 'en').format(date);
    final year = DateFormat('yyyy', 'en').format(date);
    final time = DateFormat('hh:mm a', 'en').format(date);
    return '$monthDay, $year • $time';
  }

  /// Smart format selection based on date context.
  ///
  /// Rules:
  /// - If date is today: use [timeOnly]
  /// - If date is in current year: use [compact]
  /// - If date is from another year: use [full]
  static String smart(DateTime date, {required String locale}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return timeOnly(date, locale: locale);
    }

    if (date.year == now.year) {
      return compact(date, locale: locale);
    }

    return full(date, locale: locale);
  }

  /// Safe parsing of [timeOnly] from string.
  ///
  /// Returns '-' if value is null, empty, or parsing fails.
  static String timeOnlyFromString(String? value, {required String locale}) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return '-';
    }

    return timeOnly(date.toLocal(), locale: locale);
  }

  /// Safe parsing of [compact] from string.
  ///
  /// Returns '-' if value is null, empty, or parsing fails.
  static String compactFromString(String? value, {required String locale}) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return '-';
    }

    return compact(date.toLocal(), locale: locale);
  }

  /// Safe parsing of [full] from string.
  ///
  /// Returns '-' if value is null, empty, or parsing fails.
  static String fullFromString(String? value, {required String locale}) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return '-';
    }

    return full(date.toLocal(), locale: locale);
  }

  /// Safe parsing of [smart] from string.
  ///
  /// Returns '-' if value is null, empty, or parsing fails.
  static String smartFromString(String? value, {required String locale}) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return '-';
    }

    return smart(date.toLocal(), locale: locale);
  }

  /// Normalizes locale code to supported locales.
  ///
  /// Supported: 'en', 'ar'
  /// Default fallback: 'en'
  static String _normalizeLocale(String? locale) {
    if (locale == null || locale.isEmpty) {
      return 'en';
    }

    final lang = locale.toLowerCase();
    if (lang == 'ar' || lang.startsWith('ar_')) {
      return 'ar';
    }

    return 'en';
  }
}
