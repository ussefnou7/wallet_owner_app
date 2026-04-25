import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/app_user.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  throw UnimplementedError(
    'usersRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class UsersRepository {
  Future<List<AppUser>> getUsers();

  Future<AppUser> createUser(String username, String password);

  Future<AppUser> updateUser(
    String userId,
    String username,
    String password,
    bool active,
  );

  Future<void> deleteUser(String userId);

  Future<AppUser> assignUserToBranch(String userId, String branchId);

  Future<void> unassignUserFromBranch(String userId);
}
