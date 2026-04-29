import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:wallet_owner_app/features/branches/data/repositories/mock_branches_repository.dart';
import 'package:wallet_owner_app/features/branches/domain/repositories/branches_repository.dart';
import 'package:wallet_owner_app/features/wallets/data/repositories/mock_wallets_repository.dart';
import 'package:wallet_owner_app/features/wallets/domain/repositories/wallets_repository.dart';
import 'package:wallet_owner_app/features/wallets/presentation/controllers/wallets_controller.dart';
import 'package:wallet_owner_app/features/wallets/presentation/pages/wallets_page.dart';

void main() {
  testWidgets('create wallet dialog cancels safely', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(),
              initialSession: const Session(
                accessToken: 'token',
                refreshToken: 'refresh',
                username: 'owner@example.com',
                role: UserRole.owner,
                backendRole: 'OWNER',
                tenantId: 'tenant-1',
                userId: 'owner-1',
                displayName: 'Owner User',
              ),
            ),
          ),
          walletsRepositoryProvider.overrideWithValue(MockWalletsRepository()),
          branchesRepositoryProvider.overrideWithValue(
            MockBranchesRepository(),
          ),
          walletTypesProvider.overrideWith((ref) async => ['STANDARD']),
        ],
        child: const MaterialApp(home: Scaffold(body: WalletsPage())),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Temp Wallet');
    await tester.pumpAndSettle();

    final cancelButton = find.text('Cancel');
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
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
