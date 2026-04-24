import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/session.dart';
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
    final repository = ref.watch(usersRepositoryProvider);
    return repository.getUsers();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(usersRepositoryProvider);
      return repository.getUsers();
    });
  }

  void updateQuery(String value) {
    ref.read(usersSearchQueryProvider.notifier).state = value;
  }

  void updateRoleFilter(UserRoleFilter value) {
    ref.read(usersRoleFilterProvider.notifier).state = value;
  }
}
