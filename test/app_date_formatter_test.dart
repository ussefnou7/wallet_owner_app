import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ta2feela_app/core/formatters/app_date_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en_US', null);
    await initializeDateFormatting('ar', null);
  });

  group('AppDateFormatter', () {
    group('timeOnly', () {
      test('English time format', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final result = AppDateFormatter.timeOnly(date, locale: 'en');
        expect(result, '01:20 AM');
      });

      test('English time format PM', () {
        final date = DateTime(2026, 5, 1, 13, 45);
        final result = AppDateFormatter.timeOnly(date, locale: 'en');
        expect(result, '01:45 PM');
      });

      test('Arabic time format', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final result = AppDateFormatter.timeOnly(date, locale: 'ar');
        expect(result, '01:20 ص');
      });

      test('Arabic time format PM', () {
        final date = DateTime(2026, 5, 1, 13, 45);
        final result = AppDateFormatter.timeOnly(date, locale: 'ar');
        expect(result, '01:45 م');
      });

      test('Midnight', () {
        final date = DateTime(2026, 5, 1, 0, 0);
        final result = AppDateFormatter.timeOnly(date, locale: 'en');
        expect(result, '12:00 AM');
      });

      test('Noon', () {
        final date = DateTime(2026, 5, 1, 12, 0);
        final result = AppDateFormatter.timeOnly(date, locale: 'en');
        expect(result, '12:00 PM');
      });
    });

    group('compact', () {
      test('English compact format', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'May 1 • 01:20 AM');
      });

      test('Arabic compact format', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final result = AppDateFormatter.compact(date, locale: 'ar');
        expect(result, '1 مايو • 01:20 ص');
      });

      test('English compact with double-digit day', () {
        final date = DateTime(2026, 5, 15, 14, 30);
        final result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'May 15 • 02:30 PM');
      });

      test('Arabic compact with double-digit day', () {
        final date = DateTime(2026, 5, 15, 14, 30);
        final result = AppDateFormatter.compact(date, locale: 'ar');
        expect(result, '15 مايو • 02:30 م');
      });

      test('Different months', () {
        // January
        var date = DateTime(2026, 1, 5, 9, 15);
        var result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'Jan 5 • 09:15 AM');

        // December
        date = DateTime(2026, 12, 31, 23, 59);
        result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'Dec 31 • 11:59 PM');
      });
    });

    group('full', () {
      test('English full format', () {
        final date = DateTime(2025, 5, 1, 1, 20);
        final result = AppDateFormatter.full(date, locale: 'en');
        expect(result, 'May 1, 2025 • 01:20 AM');
      });

      test('Arabic full format', () {
        final date = DateTime(2025, 5, 1, 1, 20);
        final result = AppDateFormatter.full(date, locale: 'ar');
        expect(result, '1 مايو، 2025 • 01:20 ص');
      });

      test('English full format with year at correct position', () {
        final date = DateTime(2020, 3, 15, 14, 45);
        final result = AppDateFormatter.full(date, locale: 'en');
        expect(result, 'Mar 15, 2020 • 02:45 PM');
      });

      test('Arabic full format year after month, not after time', () {
        final date = DateTime(2020, 3, 15, 14, 45);
        final result = AppDateFormatter.full(date, locale: 'ar');
        expect(result, '15 مارس، 2020 • 02:45 م');
        // Make sure year is NOT after time
        expect(result.endsWith('م'), true);
        expect(result.contains('2020 • '), true);
      });

      test('Year appears before time in format', () {
        final date = DateTime(2019, 7, 20, 8, 0);
        final result = AppDateFormatter.full(date, locale: 'en');
        final parts = result.split(' • ');
        expect(parts[0], contains('2019'));
        expect(parts[0], 'Jul 20, 2019');
        expect(parts[1], '08:00 AM');
      });
    });

    group('smart', () {
      test('Today returns timeOnly', () {
        final now = DateTime.now();
        final result = AppDateFormatter.smart(now, locale: 'en');
        // Result should be time only (contain AM/PM but no month)
        expect(result, isNotEmpty);
        expect(result, matches(RegExp(r'\d{2}:\d{2} (AM|PM)$')));
      });

      test('Same year returns compact', () {
        final now = DateTime.now();
        final pastDate = DateTime(
          now.year,
          1,
          15,
          10,
          30,
        ); // Jan 15 of current year
        if (pastDate.isBefore(now)) {
          final result = AppDateFormatter.smart(pastDate, locale: 'en');
          // Should contain month and day
          expect(
            result,
            matches(
              RegExp(
                r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{1,2} • \d{2}:\d{2} (AM|PM)$',
              ),
            ),
          );
        }
      });

      test('Different year returns full', () {
        final pastDate = DateTime(2020, 5, 15, 10, 30);
        final result = AppDateFormatter.smart(pastDate, locale: 'en');
        // Should contain year
        expect(result, contains('2020'));
        expect(
          result,
          matches(
            RegExp(
              r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{1,2}, 2020 • \d{2}:\d{2} (AM|PM)$',
            ),
          ),
        );
      });

      test('Arabic smart with today', () {
        final now = DateTime.now();
        final result = AppDateFormatter.smart(now, locale: 'ar');
        // Should be time only
        expect(result, matches(RegExp(r'\d{2}:\d{2} (ص|م)$')));
      });

      test('Arabic smart with different year', () {
        final pastDate = DateTime(2020, 5, 15, 10, 30);
        final result = AppDateFormatter.smart(pastDate, locale: 'ar');
        // Should contain year
        expect(result, contains('2020'));
        expect(result, contains('مايو'));
      });
    });

    group('timeOnlyFromString', () {
      test('Valid ISO string', () {
        final result = AppDateFormatter.timeOnlyFromString(
          '2026-05-01T01:20:00',
          locale: 'en',
        );
        expect(result, '01:20 AM');
      });

      test('Null value returns dash', () {
        final result = AppDateFormatter.timeOnlyFromString(null, locale: 'en');
        expect(result, '-');
      });

      test('Empty string returns dash', () {
        final result = AppDateFormatter.timeOnlyFromString('', locale: 'en');
        expect(result, '-');
      });

      test('Whitespace only returns dash', () {
        final result = AppDateFormatter.timeOnlyFromString('   ', locale: 'en');
        expect(result, '-');
      });

      test('Invalid string returns dash', () {
        final result = AppDateFormatter.timeOnlyFromString(
          'not a date',
          locale: 'en',
        );
        expect(result, '-');
      });

      test('Arabic from string', () {
        final result = AppDateFormatter.timeOnlyFromString(
          '2026-05-01T01:20:00',
          locale: 'ar',
        );
        expect(result, '01:20 ص');
      });
    });

    group('compactFromString', () {
      test('Valid ISO string English', () {
        final result = AppDateFormatter.compactFromString(
          '2026-05-01T01:20:00',
          locale: 'en',
        );
        expect(result, 'May 1 • 01:20 AM');
      });

      test('Valid ISO string Arabic', () {
        final result = AppDateFormatter.compactFromString(
          '2026-05-01T01:20:00',
          locale: 'ar',
        );
        expect(result, '1 مايو • 01:20 ص');
      });

      test('Null returns dash', () {
        final result = AppDateFormatter.compactFromString(null, locale: 'en');
        expect(result, '-');
      });

      test('Invalid string returns dash', () {
        final result = AppDateFormatter.compactFromString(
          'bad date',
          locale: 'en',
        );
        expect(result, '-');
      });
    });

    group('fullFromString', () {
      test('Valid ISO string English', () {
        final result = AppDateFormatter.fullFromString(
          '2025-05-01T01:20:00',
          locale: 'en',
        );
        expect(result, 'May 1, 2025 • 01:20 AM');
      });

      test('Valid ISO string Arabic', () {
        final result = AppDateFormatter.fullFromString(
          '2025-05-01T01:20:00',
          locale: 'ar',
        );
        expect(result, '1 مايو، 2025 • 01:20 ص');
      });

      test('Null returns dash', () {
        final result = AppDateFormatter.fullFromString(null, locale: 'en');
        expect(result, '-');
      });

      test('Invalid string returns dash', () {
        final result = AppDateFormatter.fullFromString(
          'bad date',
          locale: 'en',
        );
        expect(result, '-');
      });
    });

    group('smartFromString', () {
      test('Valid ISO string', () {
        final result = AppDateFormatter.smartFromString(
          '2025-05-01T01:20:00',
          locale: 'en',
        );
        // Should return full format for past year
        expect(result, contains('2025'));
      });

      test('Null returns dash', () {
        final result = AppDateFormatter.smartFromString(null, locale: 'en');
        expect(result, '-');
      });

      test('Invalid string returns dash', () {
        final result = AppDateFormatter.smartFromString(
          'bad date',
          locale: 'en',
        );
        expect(result, '-');
      });

      test('Arabic smart from string', () {
        final result = AppDateFormatter.smartFromString(
          '2025-05-01T01:20:00',
          locale: 'ar',
        );
        expect(result, contains('مايو'));
      });
    });

    group('locale normalization', () {
      test('Full Arabic locale normalizes to ar', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final en = AppDateFormatter.timeOnly(date, locale: 'en');
        final ar1 = AppDateFormatter.timeOnly(date, locale: 'ar');
        final ar2 = AppDateFormatter.timeOnly(date, locale: 'ar_SA');
        final ar3 = AppDateFormatter.timeOnly(date, locale: 'AR');
        expect(ar1, ar2);
        expect(ar1, ar3);
        expect(en, isNot(ar1));
      });

      test('Unknown locale defaults to English', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final en = AppDateFormatter.timeOnly(date, locale: 'en');
        final unknown = AppDateFormatter.timeOnly(date, locale: 'fr');
        expect(en, unknown);
      });

      test('Empty locale defaults to English', () {
        final date = DateTime(2026, 5, 1, 1, 20);
        final en = AppDateFormatter.timeOnly(date, locale: 'en');
        final empty = AppDateFormatter.timeOnly(date, locale: '');
        expect(en, empty);
      });
    });

    group('edge cases', () {
      test('Leap year February 29', () {
        final date = DateTime(2024, 2, 29, 15, 30);
        final result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'Feb 29 • 03:30 PM');
      });

      test('End of month', () {
        final date = DateTime(2026, 12, 31, 23, 59);
        final result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'Dec 31 • 11:59 PM');
      });

      test('Beginning of year', () {
        final date = DateTime(2026, 1, 1, 0, 0);
        final result = AppDateFormatter.compact(date, locale: 'en');
        expect(result, 'Jan 1 • 12:00 AM');
      });

      test('Arabic month names are correct', () {
        final tests = [
          (DateTime(2026, 1, 1, 10, 0), 'يناير'),
          (DateTime(2026, 2, 1, 10, 0), 'فبراير'),
          (DateTime(2026, 3, 1, 10, 0), 'مارس'),
          (DateTime(2026, 4, 1, 10, 0), 'أبريل'),
          (DateTime(2026, 5, 1, 10, 0), 'مايو'),
          (DateTime(2026, 6, 1, 10, 0), 'يونيو'),
          (DateTime(2026, 7, 1, 10, 0), 'يوليو'),
          (DateTime(2026, 8, 1, 10, 0), 'أغسطس'),
          (DateTime(2026, 9, 1, 10, 0), 'سبتمبر'),
          (DateTime(2026, 10, 1, 10, 0), 'أكتوبر'),
          (DateTime(2026, 11, 1, 10, 0), 'نوفمبر'),
          (DateTime(2026, 12, 1, 10, 0), 'ديسمبر'),
        ];

        for (final (date, monthName) in tests) {
          final result = AppDateFormatter.compact(date, locale: 'ar');
          expect(result, contains(monthName), reason: 'Month ${date.month}');
        }
      });

      test('No duplication in output', () {
        final date = DateTime(2025, 5, 1, 1, 20);
        final result = AppDateFormatter.full(date, locale: 'en');
        // Should not have repeated numbers
        final parts = result.split(' • ');
        expect(parts.length, 2);
        expect(parts[0], 'May 1, 2025');
        expect(parts[1], '01:20 AM');
      });
    });

    group('conversion to local time', () {
      test('UTC string converted to local', () {
        // Parsing ISO string gives UTC, toLocal() converts it
        const utcString = '2026-05-01T01:20:00Z';
        final result = AppDateFormatter.timeOnlyFromString(
          utcString,
          locale: 'en',
        );
        // Should return a valid time (exact value depends on system timezone)
        expect(result, isNotEmpty);
        expect(result, isNot('-'));
        expect(result, matches(RegExp(r'\d{2}:\d{2} (AM|PM)$')));
      });
    });
  });
}
