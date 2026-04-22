import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_owner_app/app/app.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:wallet_owner_app/features/branches/data/repositories/mock_branches_repository.dart';
import 'package:wallet_owner_app/features/branches/domain/repositories/branches_repository.dart';
import 'package:wallet_owner_app/features/transactions/data/repositories/mock_transactions_repository.dart';
import 'package:wallet_owner_app/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:wallet_owner_app/features/users/data/repositories/mock_users_repository.dart';
import 'package:wallet_owner_app/features/users/domain/repositories/users_repository.dart';
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

  testWidgets('shows dashboard inside authenticated owner shell', (
    tester,
  ) async {
    await tester.pumpWidget(_buildAuthenticatedApp());
    await tester.pumpAndSettle();

    expect(find.text('Portfolio Overview'), findsOneWidget);
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsOneWidget);
    expect(find.byTooltip('Dashboard'), findsOneWidget);
    expect(find.byTooltip('Wallets'), findsOneWidget);
    expect(find.byTooltip('Transactions'), findsOneWidget);
    expect(find.byTooltip('New transaction'), findsOneWidget);
  });

  testWidgets('switches between shell tabs using bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(_buildAuthenticatedApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Wallets'));
    await tester.pumpAndSettle();
    expect(find.text('Wallet Directory'), findsOneWidget);

    await tester.tap(find.byTooltip('Transactions'));
    await tester.pumpAndSettle();
    expect(find.text('Transactions History'), findsOneWidget);
  });

  testWidgets('logout from drawer returns user to login', (tester) async {
    await tester.pumpWidget(_buildAuthenticatedApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
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

    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}

Widget _buildAuthenticatedApp() {
  return ProviderScope(
    overrides: [
      authControllerProvider.overrideWith(
        (ref) => AuthController(
          authRepository: _FakeAuthRepository(),
          initialSession: const Session(
            accessToken: 'token',
            refreshToken: 'refresh',
            username: 'owner@example.com',
            role: UserRole.owner,
            backendRole: 'SYSTEM_ADMIN',
            tenantId: 'tenant-demo',
            userId: 'owner-1',
            displayName: 'Owner User',
          ),
        ),
      ),
      walletsRepositoryProvider.overrideWithValue(MockWalletsRepository()),
      transactionsRepositoryProvider.overrideWithValue(
        MockTransactionsRepository(),
      ),
      usersRepositoryProvider.overrideWithValue(MockUsersRepository()),
      branchesRepositoryProvider.overrideWithValue(MockBranchesRepository()),
    ],
    child: const App(),
  );
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Session?> getCurrentSession() async => null;

  @override
  Future<Session> login({required String username, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}
}
