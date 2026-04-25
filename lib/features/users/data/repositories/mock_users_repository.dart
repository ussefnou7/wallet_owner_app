import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';
import '../models/app_user_model.dart';

class MockUsersRepository implements UsersRepository {
  final List<AppUserModel> _users = [
    const AppUserModel(
      id: 'user-1',
      username: 'Omar Khaled',
      role: UserRole.owner,
      tenantName: 'BTC',
      tenantId: 'tenant-1',
      active: true,
      branchId: 'branch-1',
      branchName: 'Head Office',
    ),
    const AppUserModel(
      id: 'user-2',
      username: 'Mariam Hassan',
      role: UserRole.user,
      tenantName: 'BTC',
      tenantId: 'tenant-1',
      active: true,
      branchId: 'branch-2',
      branchName: 'Nasr City Branch',
    ),
    const AppUserModel(
      id: 'user-3',
      username: 'Salma Adel',
      role: UserRole.user,
      tenantName: 'BTC',
      tenantId: 'tenant-1',
      active: false,
    ),
    const AppUserModel(
      id: 'user-4',
      username: 'Youssef Tarek',
      role: UserRole.user,
      tenantName: 'BTC',
      tenantId: 'tenant-1',
      active: true,
    ),
  ];

  @override
  Future<List<AppUser>> getUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return List<AppUser>.from(_users);
  }

  @override
  Future<AppUser> createUser(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final user = AppUserModel(
      id: 'user-${_users.length + 1}',
      username: username,
      role: UserRole.user,
      tenantName: 'BTC',
      tenantId: 'tenant-1',
      active: true,
    );
    _users.insert(0, user);
    return user;
  }

  @override
  Future<AppUser> updateUser(
    String userId,
    String username,
    String password,
    bool active,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _users.indexWhere((user) => user.id == userId);
    final current = _users[index];
    final updated = AppUserModel(
      id: current.id,
      username: username,
      role: current.role,
      tenantName: current.tenantName,
      tenantId: current.tenantId,
      branchId: current.branchId,
      branchName: current.branchName,
      active: active,
    );
    _users[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteUser(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _users.removeWhere((user) => user.id == userId);
  }

  @override
  Future<AppUser> assignUserToBranch(String userId, String branchId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _users.indexWhere((user) => user.id == userId);
    final current = _users[index];
    final updated = AppUserModel(
      id: current.id,
      username: current.username,
      role: current.role,
      tenantName: current.tenantName,
      tenantId: current.tenantId,
      branchId: branchId,
      branchName: switch (branchId) {
        'branch-1' => 'Head Office',
        'branch-2' => 'Nasr City Branch',
        'branch-3' => 'Alexandria Branch',
        'branch-4' => 'Maadi Branch',
        _ => 'Assigned Branch',
      },
      active: current.active,
    );
    _users[index] = updated;
    return updated;
  }

  @override
  Future<void> unassignUserFromBranch(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _users.indexWhere((user) => user.id == userId);
    final current = _users[index];
    _users[index] = AppUserModel(
      id: current.id,
      username: current.username,
      role: current.role,
      tenantName: current.tenantName,
      tenantId: current.tenantId,
      active: current.active,
    );
  }
}
