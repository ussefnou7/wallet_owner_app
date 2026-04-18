import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_owner_app/app/app.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:wallet_owner_app/features/branches/data/repositories/mock_branches_repository.dart';
import 'package:wallet_owner_app/features/branches/domain/repositories/branches_repository.dart';
import 'package:wallet_owner_app/features/transactions/data/repositories/mock_transactions_repository.dart';
import 'package:wallet_owner_app/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:wallet_owner_app/features/transactions/presentation/pages/transactions_page.dart';
import 'package:wallet_owner_app/features/users/data/repositories/mock_users_repository.dart';
import 'package:wallet_owner_app/features/users/domain/repositories/users_repository.dart';
import 'package:wallet_owner_app/features/users/presentation/pages/users_page.dart';
import 'package:wallet_owner_app/features/wallets/data/repositories/mock_wallets_repository.dart';
import 'package:wallet_owner_app/features/wallets/domain/repositories/wallets_repository.dart';

void main() {
  testWidgets('renders login page when unauthenticated', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(),
              initialSession: null,
            ),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Continue as Owner'), findsOneWidget);
  });

  testWidgets('shows validation messages for empty login form', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(),
              initialSession: null,
            ),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.tap(find.text('Continue as Owner'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('renders wallets list for authenticated owner', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(),
              initialSession: const Session(
                accessToken: 'token',
                refreshToken: 'refresh',
                role: UserRole.owner,
                tenantId: 'tenant-demo',
                userId: 'owner@example.com',
                displayName: 'Owner User',
              ),
            ),
          ),
          walletsRepositoryProvider.overrideWithValue(MockWalletsRepository()),
          transactionsRepositoryProvider.overrideWithValue(
            MockTransactionsRepository(),
          ),
          usersRepositoryProvider.overrideWithValue(MockUsersRepository()),
          branchesRepositoryProvider.overrideWithValue(
            MockBranchesRepository(),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();

    expect(find.text('Wallet Directory'), findsOneWidget);
    expect(find.text('Main Wallet'), findsOneWidget);
    expect(find.text('Branch Wallet'), findsOneWidget);
  });

  testWidgets('filters transactions list by search query', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(
              (ref) => AuthController(
                authRepository: _FakeAuthRepository(),
                initialSession: const Session(
                  accessToken: 'token',
                  refreshToken: 'refresh',
                  role: UserRole.owner,
                  tenantId: 'tenant-demo',
                  userId: 'owner@example.com',
                  displayName: 'Owner User',
                ),
              ),
            ),
            transactionsRepositoryProvider.overrideWithValue(
              MockTransactionsRepository(),
            ),
          ],
          child: const TransactionsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Main Wallet'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Search transactions'),
      'VIP',
    );
    await tester.pumpAndSettle();

    expect(find.text('VIP Customer Wallet'), findsOneWidget);
    expect(find.text('Main Wallet'), findsNothing);
  });

  testWidgets('filters users list by search query', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(
              (ref) => AuthController(
                authRepository: _FakeAuthRepository(),
                initialSession: const Session(
                  accessToken: 'token',
                  refreshToken: 'refresh',
                  role: UserRole.owner,
                  tenantId: 'tenant-demo',
                  userId: 'owner@example.com',
                  displayName: 'Owner User',
                ),
              ),
            ),
            usersRepositoryProvider.overrideWithValue(MockUsersRepository()),
          ],
          child: const UsersPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Omar Khaled'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Search users'),
      'Salma',
    );
    await tester.pumpAndSettle();

    expect(find.text('Salma Adel'), findsOneWidget);
    expect(find.text('Omar Khaled'), findsNothing);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Session?> getCurrentSession() async => null;

  @override
  Future<Session> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}
}
