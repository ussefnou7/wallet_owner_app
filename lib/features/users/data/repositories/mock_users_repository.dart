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
        fullName: 'Omar Khaled',
        role: UserRole.owner,
        email: 'omar.khaled@tenant.com',
        status: AppUserStatus.active,
        walletCount: 4,
        branchName: 'Head Office',
        phone: '+20 100 111 2233',
      ),
      AppUserModel(
        id: 'user-2',
        fullName: 'Mariam Hassan',
        role: UserRole.user,
        email: 'mariam.hassan@tenant.com',
        status: AppUserStatus.active,
        walletCount: 2,
        branchName: 'Nasr City',
        phone: '+20 100 222 3344',
      ),
      AppUserModel(
        id: 'user-3',
        fullName: 'Salma Adel',
        role: UserRole.user,
        email: 'salma.adel@tenant.com',
        status: AppUserStatus.inactive,
        walletCount: 1,
        branchName: 'Alexandria',
        phone: '+20 100 333 4455',
      ),
      AppUserModel(
        id: 'user-4',
        fullName: 'Youssef Tarek',
        role: UserRole.user,
        email: 'youssef.tarek@tenant.com',
        status: AppUserStatus.active,
        walletCount: 3,
        branchName: 'Maadi',
      ),
    ];
  }
}
