import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  symbol: '\$',
  decimalDigits: 0,
);
final _compactNumberFormatter = NumberFormat.compact();
final _dateFormatter = DateFormat('dd MMM yyyy');

String formatCurrency(num value) => _currencyFormatter.format(value);

String formatCompactNumber(num value) => _compactNumberFormatter.format(value);

String formatDate(DateTime value) => _dateFormatter.format(value);
