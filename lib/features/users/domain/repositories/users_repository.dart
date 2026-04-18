import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/app_user.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  throw UnimplementedError(
    'usersRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class UsersRepository {
  Future<List<AppUser>> getUsers();
}
