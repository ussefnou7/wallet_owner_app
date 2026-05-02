import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class AuthRepository {
  Future<Session?> getCurrentSession();

  Future<Session> login({required String username, required String password});

  Future<String?> forgotPassword({required String username});

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> logout();
}
