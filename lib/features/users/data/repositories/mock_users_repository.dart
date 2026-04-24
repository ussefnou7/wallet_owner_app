import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';
import '../models/app_user_model.dart';

class MockUsersRepository implements UsersRepository {
  @override
  Future<List<AppUser>> getUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    return const [
      AppUserModel(
        id: 'user-1',
        username: 'Omar Khaled',
        role: UserRole.owner,
        tenantName: 'BTC',
      ),
      AppUserModel(
        id: 'user-2',
        username: 'Mariam Hassan',
        role: UserRole.user,
        tenantName: 'BTC',
      ),
      AppUserModel(
        id: 'user-3',
        username: 'Salma Adel',
        role: UserRole.user,
        tenantName: 'BTC',
      ),
      AppUserModel(
        id: 'user-4',
        username: 'Youssef Tarek',
        role: UserRole.user,
        tenantName: 'BTC',
      ),
    ];
  }
}
