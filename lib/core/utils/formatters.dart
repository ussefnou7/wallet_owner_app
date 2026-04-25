import 'package:intl/intl.dart';

String formatCurrency(num value) {
  final locale = Intl.getCurrentLocale();
  if (locale.startsWith('ar')) {
    return '${NumberFormat('#,###').format(value)} ج.م';
  }
  return 'EGP ${NumberFormat('#,###').format(value)}';
}

final _compactNumberFormatter = NumberFormat.compact();
final _dateFormatter = DateFormat('dd MMM yyyy');
final _dateTimeFormatter = DateFormat('dd MMM yyyy, hh:mm a');

String formatCompactNumber(num value) => _compactNumberFormatter.format(value);

String formatDate(DateTime value) => _dateFormatter.format(value);

String formatDateTime(DateTime value) => _dateTimeFormatter.format(value);
