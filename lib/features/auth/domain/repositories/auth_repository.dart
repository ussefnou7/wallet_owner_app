import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class AuthRepository {
  Future<Session?> getCurrentSession();

  Future<Session> login({required String email, required String password});

  Future<void> logout();
}
