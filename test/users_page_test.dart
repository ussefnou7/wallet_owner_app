import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_owner_app/features/branches/data/repositories/mock_branches_repository.dart';
import 'package:wallet_owner_app/features/branches/domain/repositories/branches_repository.dart';
import 'package:wallet_owner_app/features/users/data/repositories/mock_users_repository.dart';
import 'package:wallet_owner_app/features/users/domain/repositories/users_repository.dart';
import 'package:wallet_owner_app/features/users/presentation/pages/users_page.dart';

void main() {
  testWidgets('create user dialog cancels safely', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          usersRepositoryProvider.overrideWithValue(MockUsersRepository()),
          branchesRepositoryProvider.overrideWithValue(
            MockBranchesRepository(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: UsersPage())),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Create User'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'temp_user');
    await tester.pumpAndSettle();

    final cancelButton = find.text('Cancel');
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
