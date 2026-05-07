import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/core/errors/app_exception.dart';
import 'package:ta2feela_app/core/localization/locale_controller.dart';
import 'package:ta2feela_app/core/network/models/paged_response.dart';
import 'package:ta2feela_app/features/transactions/data/models/transaction_record_model.dart';
import 'package:ta2feela_app/features/transactions/domain/entities/transaction_draft.dart';
import 'package:ta2feela_app/features/transactions/domain/entities/transaction_record.dart';
import 'package:ta2feela_app/features/transactions/domain/entities/transaction_submission_result.dart';
import 'package:ta2feela_app/features/transactions/domain/entities/transactions_filter_state.dart';
import 'package:ta2feela_app/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:ta2feela_app/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:ta2feela_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:ta2feela_app/l10n/generated/app_localizations.dart';

void main() {
  test('parses paginated transaction response and cash boolean', () {
    final response = PagedResponse<TransactionRecordModel>.fromJson({
      'content': [
        {
          'id': 'txn-1',
          'tenantId': 'tenant-1',
          'walletId': 'wallet-1',
          'walletName': 'Main Wallet',
          'externalTransactionId': 'trx-123',
          'amount': 1000.0,
          'type': 'CREDIT',
          'percent': 1.5,
          'phoneNumber': '01000000000',
          'cash': false,
          'description': 'topup',
          'occurredAt': '2026-04-30T12:00:00',
          'createdAt': '2026-04-30T12:01:00',
          'updatedAt': '2026-04-30T12:01:00',
          'createdBy': 'user-1',
          'createdByUsername': 'owner-user',
        },
      ],
      'page': 0,
      'size': 20,
      'totalElements': 155,
      'totalPages': 8,
      'last': false,
      'hasNext': true,
    }, TransactionRecordModel.fromJson);

    expect(response.content, hasLength(1));
    expect(response.page, 0);
    expect(response.size, 20);
    expect(response.totalElements, 155);
    expect(response.totalPages, 8);
    expect(response.last, isFalse);
    expect(response.hasNext, isTrue);
    expect(response.content.first.cash, isFalse);
    expect(response.content.first.createdBy, 'user-1');
    expect(response.content.first.createdByUsername, 'owner-user');
  });

  test(
    'initial page 0 load replaces list and refresh resets to page 0',
    () async {
      final repository = _FakeTransactionsRepository();
      repository.seedPage(
        page: 0,
        response: _pageResponse(
          page: 0,
          hasNext: true,
          items: [_transaction('txn-1'), _transaction('txn-2')],
        ),
      );
      repository.seedPage(
        page: 1,
        response: _pageResponse(
          page: 1,
          hasNext: false,
          items: [_transaction('txn-3')],
        ),
      );

      final container = ProviderContainer(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      container.read(transactionsControllerProvider);
      await _pumpQueue();

      expect(
        container
            .read(transactionsControllerProvider)
            .transactions
            .map((t) => t.id),
        ['txn-1', 'txn-2'],
      );

      await container.read(transactionsControllerProvider.notifier).loadMore();
      expect(
        container
            .read(transactionsControllerProvider)
            .transactions
            .map((t) => t.id),
        ['txn-1', 'txn-2', 'txn-3'],
      );

      repository.seedPage(
        page: 0,
        response: _pageResponse(
          page: 0,
          hasNext: false,
          items: [_transaction('txn-10')],
        ),
      );

      await container.read(transactionsControllerProvider.notifier).refresh();

      final state = container.read(transactionsControllerProvider);
      expect(state.currentPage, 0);
      expect(state.hasNext, isFalse);
      expect(state.transactions.map((t) => t.id), ['txn-10']);
    },
  );

  test('load more appends page 1 content', () async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: true,
        items: [_transaction('txn-1')],
      ),
    );
    repository.seedPage(
      page: 1,
      response: _pageResponse(
        page: 1,
        hasNext: false,
        items: [_transaction('txn-2')],
      ),
    );

    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(transactionsControllerProvider);
    await _pumpQueue();
    await container.read(transactionsControllerProvider.notifier).loadMore();

    final state = container.read(transactionsControllerProvider);
    expect(state.transactions.map((t) => t.id), ['txn-1', 'txn-2']);
    expect(state.currentPage, 1);
    expect(state.hasNext, isFalse);
  });

  test('load more is ignored when first page reports no next page', () async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-1')],
      ),
    );

    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(transactionsControllerProvider);
    await _pumpQueue();
    await container.read(transactionsControllerProvider.notifier).loadMore();

    expect(repository.requests, hasLength(1));
    expect(
      repository.requests.single,
      const _TransactionsRequest(
        page: 0,
        size: 20,
        filter: TransactionFilterType.all,
      ),
    );
  });

  test('filter change resets pagination to page 0', () async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: true,
        items: [_transaction('txn-1', type: TransactionEntryType.credit)],
      ),
      filter: TransactionFilterType.all,
    );
    repository.seedPage(
      page: 1,
      response: _pageResponse(
        page: 1,
        hasNext: false,
        items: [_transaction('txn-2', type: TransactionEntryType.debit)],
      ),
      filter: TransactionFilterType.all,
    );
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-3', type: TransactionEntryType.credit)],
      ),
      filter: TransactionFilterType.credit,
    );

    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(transactionsControllerProvider);
    await _pumpQueue();
    await container.read(transactionsControllerProvider.notifier).loadMore();
    await container
        .read(transactionsControllerProvider.notifier)
        .updateFilterType(TransactionFilterType.credit);

    final state = container.read(transactionsControllerProvider);
    expect(state.currentPage, 0);
    expect(state.activeFilterType, TransactionFilterType.credit);
    expect(state.transactions.map((t) => t.id), ['txn-3']);
    expect(
      repository.requests.last,
      const _TransactionsRequest(
        page: 0,
        size: 20,
        filter: TransactionFilterType.credit,
      ),
    );
  });

  test('selecting all after credit clears transaction type filter', () async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-all-initial')],
      ),
      filter: TransactionFilterType.all,
    );
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-credit', type: TransactionEntryType.credit)],
      ),
      filter: TransactionFilterType.credit,
    );

    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(transactionsControllerProvider);
    await _pumpQueue();
    await container
        .read(transactionsControllerProvider.notifier)
        .updateFilterType(TransactionFilterType.credit);

    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-all-returned')],
      ),
      filter: TransactionFilterType.all,
    );

    await container
        .read(transactionsControllerProvider.notifier)
        .updateFilterType(TransactionFilterType.all);

    final state = container.read(transactionsControllerProvider);
    expect(state.activeFilterType, TransactionFilterType.all);
    expect(state.filter.type, isNull);
    expect(state.transactions.map((t) => t.id), ['txn-all-returned']);
    expect(
      repository.requests.last,
      const _TransactionsRequest(
        page: 0,
        size: 20,
        filter: TransactionFilterType.all,
      ),
    );
  });

  test('latest quick filter request wins over stale in-flight response', () async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      filter: TransactionFilterType.all,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-initial')],
      ),
    );
    repository.prepareRequest(
      page: 0,
      filter: TransactionFilterType.credit,
    );

    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(transactionsControllerProvider);
    await _pumpQueue();
    repository.seedPage(
      page: 0,
      filter: TransactionFilterType.all,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-all')],
      ),
    );

    unawaited(
      container
          .read(transactionsControllerProvider.notifier)
          .updateFilterType(TransactionFilterType.credit),
    );
    await Future<void>.delayed(Duration.zero);
    await container
        .read(transactionsControllerProvider.notifier)
        .updateFilterType(TransactionFilterType.all);

    repository.completePreparedRequest(
      page: 0,
      filter: TransactionFilterType.credit,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-credit', type: TransactionEntryType.credit)],
      ),
    );

    await _pumpQueue();

    final state = container.read(transactionsControllerProvider);
    expect(state.activeFilterType, TransactionFilterType.all);
    expect(state.currentPage, 0);
    expect(state.transactions.map((t) => t.id), ['txn-all']);
    expect(state.isInitialLoading, isFalse);
    expect(state.isLoadingMore, isFalse);
  });

  test('load more error preserves already loaded list', () async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: true,
        items: [_transaction('txn-1')],
      ),
    );
    repository.seedError(
      page: 1,
      error: const AppException(
        code: 'NETWORK_ERROR',
        message: 'Unable to load page 1',
      ),
    );

    final container = ProviderContainer(
      overrides: [transactionsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.read(transactionsControllerProvider);
    await _pumpQueue();
    await container.read(transactionsControllerProvider.notifier).loadMore();

    final state = container.read(transactionsControllerProvider);
    expect(state.transactions.map((t) => t.id), ['txn-1']);
    expect(state.loadMoreError?.message, 'Unable to load page 1');
    expect(state.isLoadingMore, isFalse);
  });

  testWidgets('load more button is hidden when hasNext is false', (
    tester,
  ) async {
    final repository = _FakeTransactionsRepository();
    repository.seedPage(
      page: 0,
      response: _pageResponse(
        page: 0,
        hasNext: false,
        items: [_transaction('txn-1')],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localeControllerProvider.overrideWith((ref) {
            final controller = LocaleController(null);
            controller.setLocale(const Locale('en'));
            return controller;
          }),
          transactionsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: TransactionsPage()),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Load more'), findsNothing);
  });
}

Future<void> _pumpQueue() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(const Duration(milliseconds: 10));
}

PagedResponse<TransactionRecord> _pageResponse({
  required int page,
  required bool hasNext,
  required List<TransactionRecord> items,
  int size = 20,
}) {
  final totalElements = items.length + (hasNext ? size : 0);
  return PagedResponse<TransactionRecord>(
    content: items,
    page: page,
    size: size,
    totalElements: totalElements,
    totalPages: hasNext ? page + 2 : page + 1,
    last: !hasNext,
    hasNext: hasNext,
  );
}

TransactionRecord _transaction(
  String id, {
  TransactionEntryType type = TransactionEntryType.credit,
}) {
  return TransactionRecord(
    id: id,
    walletId: 'wallet-1',
    walletName: 'Main Wallet',
    type: type,
    amount: 100,
    date: DateTime(2026, 4, 30, 12),
    createdBy: 'owner-user',
    createdByUsername: 'owner-user',
    status: TransactionRecordStatus.recorded,
    note: 'topup',
  );
}

class _FakeTransactionsRepository implements TransactionsRepository {
  final Map<_TransactionsRequest, PagedResponse<TransactionRecord>> _responses =
      {};
  final Map<_TransactionsRequest, AppException> _errors = {};
  final Map<_TransactionsRequest, Completer<PagedResponse<TransactionRecord>>>
  _preparedResponses = {};
  final List<_TransactionsRequest> requests = [];

  void seedPage({
    required int page,
    required PagedResponse<TransactionRecord> response,
    TransactionFilterType filter = TransactionFilterType.all,
  }) {
    _responses[_TransactionsRequest(
          page: page,
          size: response.size,
          filter: filter,
        )] =
        response;
  }

  void seedError({
    required int page,
    required AppException error,
    TransactionFilterType filter = TransactionFilterType.all,
    int size = 20,
  }) {
    _errors[_TransactionsRequest(page: page, size: size, filter: filter)] =
        error;
  }

  Completer<PagedResponse<TransactionRecord>> prepareRequest({
    required int page,
    required TransactionFilterType filter,
    int size = 20,
  }) {
    final completer = Completer<PagedResponse<TransactionRecord>>();
    _preparedResponses[_TransactionsRequest(
      page: page,
      size: size,
      filter: filter,
    )] = completer;
    return completer;
  }

  void completePreparedRequest({
    required int page,
    required TransactionFilterType filter,
    required PagedResponse<TransactionRecord> response,
    int size = 20,
  }) {
    final request = _TransactionsRequest(page: page, size: size, filter: filter);
    final completer = _preparedResponses.remove(request);
    if (completer == null || completer.isCompleted) {
      return;
    }
    completer.complete(response);
  }

  @override
  Future<PagedResponse<TransactionRecord>> getTransactions({
    required TransactionsFilterState filter,
  }) async {
    final transactionFilter = switch (filter.type) {
      TransactionEntryType.credit => TransactionFilterType.credit,
      TransactionEntryType.debit => TransactionFilterType.debit,
      _ => TransactionFilterType.all,
    };
    final request = _TransactionsRequest(
      page: filter.page,
      size: filter.size,
      filter: transactionFilter,
    );
    requests.add(request);

    final preparedResponse = _preparedResponses[request];
    if (preparedResponse != null) {
      return preparedResponse.future;
    }

    final error = _errors[request];
    if (error != null) {
      throw error;
    }

    return _responses[request] ??
        PagedResponse<TransactionRecord>(
          content: const [],
          page: filter.page,
          size: filter.size,
          totalElements: 0,
          totalPages: 0,
          last: true,
          hasNext: false,
        );
  }

  @override
  Future<TransactionRecord> getTransactionById(String transactionId) {
    throw UnimplementedError();
  }

  @override
  Future<TransactionSubmissionResult> submitTransaction(
    TransactionDraft draft,
  ) {
    throw UnimplementedError();
  }
}

class _TransactionsRequest {
  const _TransactionsRequest({
    required this.page,
    required this.size,
    required this.filter,
  });

  final int page;
  final int size;
  final TransactionFilterType filter;

  @override
  bool operator ==(Object other) {
    return other is _TransactionsRequest &&
        other.page == page &&
        other.size == size &&
        other.filter == filter;
  }

  @override
  int get hashCode => Object.hash(page, size, filter);
}
