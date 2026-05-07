import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ta2feela_app/app/router/app_routes.dart';
import 'package:ta2feela_app/core/providers/app_version_provider.dart';
import 'package:ta2feela_app/core/widgets/owner_app_drawer.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  testWidgets('renders owner identity from current session', (tester) async {
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
                tenantId: 'tenant-demo',
                userId: 'owner@example.com',
                displayName: 'Owner User',
              ),
            ),
          ),
          appVersionProvider.overrideWith((ref) async => '9.8.7'),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: OwnerAppDrawer(currentRoute: AppRoutes.dashboard),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Owner User'), findsOneWidget);
    expect(find.text('@owner@example.com'), findsOneWidget);
    expect(find.text('OWNER'), findsOneWidget);
    expect(find.text('Version 9.8.7'), findsOneWidget);
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
  Future<Session> refreshSession({Session? currentSession}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveSession(Session session) async {}

  @override
  Future<String?> forgotPassword({required String username}) async {
    return null;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<void> logout() async {}
}
