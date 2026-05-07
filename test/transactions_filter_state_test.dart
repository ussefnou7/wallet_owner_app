import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/features/transactions/domain/entities/transaction_draft.dart';
import 'package:ta2feela_app/features/transactions/domain/entities/transactions_filter_state.dart';

void main() {
  test('builds transaction query params with normalized date range', () {
    final filter = TransactionsFilterState(
      walletId: 'wallet-1',
      type: TransactionEntryType.credit,
      dateFrom: DateTime(2026, 5, 2),
      dateTo: DateTime(2026, 5, 3),
      createdBy: 'user-1',
      page: 0,
      size: 20,
    );

    final params = filter.toQueryParameters();

    expect(params['walletId'], 'wallet-1');
    expect(params['type'], 'CREDIT');
    expect(params['createdBy'], 'user-1');
    expect(params['page'], 0);
    expect(params['size'], 20);
    expect(params['dateFrom'], '2026-05-02T00:00:00.000');
    expect(params['dateTo'], '2026-05-03T23:59:59.000');
  });

  test('omits createdBy when the caller disables it', () {
    const filter = TransactionsFilterState(
      createdBy: 'user-1',
      page: 0,
      size: 20,
    );

    final params = filter.toQueryParameters(includeCreatedBy: false);

    expect(params.containsKey('createdBy'), false);
  });
}
