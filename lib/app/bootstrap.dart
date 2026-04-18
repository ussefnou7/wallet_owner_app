import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/storage/app_secure_storage.dart';
import '../features/auth/data/repositories/mock_auth_repository.dart';
import '../features/auth/data/services/session_local_data_source.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/branches/data/repositories/mock_branches_repository.dart';
import '../features/branches/domain/repositories/branches_repository.dart';
import '../features/transactions/data/repositories/mock_transactions_repository.dart';
import '../features/transactions/domain/repositories/transactions_repository.dart';
import '../features/users/data/repositories/mock_users_repository.dart';
import '../features/users/domain/repositories/users_repository.dart';
import '../features/wallets/data/repositories/mock_wallets_repository.dart';
import '../features/wallets/domain/repositories/wallets_repository.dart';

Future<ProviderContainer> bootstrap() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = AppSecureStorage();
  final localDataSource = SessionLocalDataSource(
    secureStorage: secureStorage,
    sharedPreferences: sharedPreferences,
  );
  final authRepository = MockAuthRepository(localDataSource);
  final walletsRepository = MockWalletsRepository();
  final transactionsRepository = MockTransactionsRepository();
  final usersRepository = MockUsersRepository();
  final branchesRepository = MockBranchesRepository();
  final initialSession = await authRepository.getCurrentSession();

  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      secureStorageProvider.overrideWithValue(secureStorage),
      authRepositoryProvider.overrideWithValue(authRepository),
      walletsRepositoryProvider.overrideWithValue(walletsRepository),
      transactionsRepositoryProvider.overrideWithValue(transactionsRepository),
      usersRepositoryProvider.overrideWithValue(usersRepository),
      branchesRepositoryProvider.overrideWithValue(branchesRepository),
      authControllerProvider.overrideWith(
        (ref) => AuthController(
          authRepository: authRepository,
          initialSession: initialSession,
        ),
      ),
      initialSessionProvider.overrideWithValue(initialSession),
    ],
  );
}
