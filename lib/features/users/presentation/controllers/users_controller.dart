import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';

enum UserRoleFilter { all, owner, user }

final usersSearchQueryProvider = StateProvider<String>((ref) => '');
final usersRoleFilterProvider = StateProvider<UserRoleFilter>(
  (ref) => UserRoleFilter.all,
);

final usersControllerProvider =
    AsyncNotifierProvider<UsersController, List<AppUser>>(UsersController.new);

final filteredUsersProvider = Provider<List<AppUser>>((ref) {
  final usersAsync = ref.watch(usersControllerProvider);
  final query = ref.watch(usersSearchQueryProvider).trim().toLowerCase();
  final roleFilter = ref.watch(usersRoleFilterProvider);

  return usersAsync.maybeWhen(
    data: (users) {
      final roleFiltered = switch (roleFilter) {
        UserRoleFilter.all => users,
        UserRoleFilter.owner =>
          users.where((user) => user.role == UserRole.owner).toList(),
        UserRoleFilter.user =>
          users.where((user) => user.role == UserRole.user).toList(),
      };

      if (query.isEmpty) {
        return roleFiltered;
      }

      return roleFiltered.where((user) {
        return user.username.toLowerCase().contains(query) ||
            user.tenantName.toLowerCase().contains(query) ||
            user.role.name.toLowerCase().contains(query);
      }).toList();
    },
    orElse: () => const [],
  );
});

class UsersController extends AsyncNotifier<List<AppUser>> {
  @override
  Future<List<AppUser>> build() async {
    final session = ref.watch(authenticatedSessionProvider);
    if (session == null) {
      return const [];
    }

    final repository = ref.watch(usersRepositoryProvider);
    return repository.getUsers();
  }

  Future<void> reload() async {
    if (!_hasAuthenticatedSession) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(usersRepositoryProvider);
      return repository.getUsers();
    });
  }

  Future<void> createUser(String username, String password) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    final repository = ref.read(usersRepositoryProvider);
    await repository.createUser(username, password);
    await reload();
  }

  Future<void> updateUser(
    String userId,
    String username,
    String password,
    bool active,
  ) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    final repository = ref.read(usersRepositoryProvider);
    await repository.updateUser(userId, username, password, active);
    await reload();
  }

  Future<void> deleteUser(String userId) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    final repository = ref.read(usersRepositoryProvider);
    await repository.deleteUser(userId);
    await reload();
  }

  Future<void> assignUserToBranch(String userId, String branchId) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    final repository = ref.read(usersRepositoryProvider);
    await repository.assignUserToBranch(userId, branchId);
    await reload();
  }

  Future<void> unassignUserFromBranch(String userId) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    final repository = ref.read(usersRepositoryProvider);
    await repository.unassignUserFromBranch(userId);
    await reload();
  }

  void updateQuery(String value) {
    ref.read(usersSearchQueryProvider.notifier).state = value;
  }

  void updateRoleFilter(UserRoleFilter value) {
    ref.read(usersRoleFilterProvider.notifier).state = value;
  }

  bool get _hasAuthenticatedSession {
    return ref.read(authenticatedSessionProvider) != null;
  }
}
