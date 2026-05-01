import 'package:intl/intl.dart';

import '../formatters/app_date_formatter.dart';

String formatCurrency(num value) {
  final locale = Intl.getCurrentLocale();
  if (locale.startsWith('ar')) {
    return '${NumberFormat('#,###').format(value)} ج.م';
  }
  return 'EGP ${NumberFormat('#,###').format(value)}';
}

final _compactNumberFormatter = NumberFormat.compact();

String formatCompactNumber(num value) => _compactNumberFormatter.format(value);

/// Formats date using smart format (based on recency).
///
/// DEPRECATED: Use [AppDateFormatter.smart] instead.
/// Kept for backwards compatibility.
@Deprecated('Use AppDateFormatter.smart(date, locale: locale) instead')
String formatDateTime(DateTime value) =>
    AppDateFormatter.smart(value, locale: 'en');

/// Formats date/time as numeric format (dd/MM/yyyy, hh:mm a).
///
/// DEPRECATED: Use [AppDateFormatter.full] or [AppDateFormatter.smart] instead.
/// Kept for backwards compatibility.
@Deprecated('Use AppDateFormatter.full(date, locale: locale) instead')
String formatNumericDateTime(DateTime value) =>
    AppDateFormatter.full(value, locale: 'en');

/// Formats date only (dd MMM yyyy).
///
/// DEPRECATED: Use [AppDateFormatter.compact] instead.
/// Kept for backwards compatibility.
@Deprecated('Use AppDateFormatter.compact(date, locale: locale) instead')
String formatDate(DateTime value) =>
    AppDateFormatter.compact(value, locale: 'en');
