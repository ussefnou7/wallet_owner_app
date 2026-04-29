import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_owner_app/features/branches/data/repositories/mock_branches_repository.dart';
import 'package:wallet_owner_app/features/branches/domain/repositories/branches_repository.dart';
import 'package:wallet_owner_app/features/branches/presentation/pages/branches_page.dart';

void main() {
  testWidgets('create branch dialog cancels safely', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          branchesRepositoryProvider.overrideWithValue(
            MockBranchesRepository(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: BranchesPage())),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Branch'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Temp Branch');
    await tester.pumpAndSettle();

    final cancelButton = find.text('Cancel');
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
